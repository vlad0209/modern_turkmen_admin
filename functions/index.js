const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const spawn = require("child-process-promise").spawn;
const path = require("path");
const os = require("os");
const fs = require("fs");
const {v4: uuidv4} = require("uuid");

exports.generateThumbnail = functions.storage.object()
    .onFinalize(async (object) => {
      const fileBucket = object.bucket;
      const filePath = object.name; // File path in the bucket.
      const contentType = object.contentType;

      if (!contentType.startsWith("image/")) {
        return functions.logger.log("This is not an image.");
      }

      // Get the file name.
      const fileName = path.basename(filePath);
      // Exit if the image is already a thumbnail.
      if (fileName.startsWith("thumb_")) {
        return functions.logger.log("Already a Thumbnail.");
      }

      // Download file from bucket.
      const bucket = admin.storage().bucket(fileBucket);
      const tempFilePath = path.join(os.tmpdir(), fileName);
      const uuid = uuidv4();
      const metadata = {
        contentType: contentType,
        metadata: {
          firebaseStorageDownloadTokens: uuid,
        },
      };
      await bucket.file(filePath).download({destination: tempFilePath});
      functions.logger.log("Image downloaded locally to", tempFilePath);
      // Generate a thumbnail using ImageMagick.
      await spawn(
          "convert",
          [tempFilePath, "-thumbnail", "200x200>", tempFilePath],
      );
      functions.logger.log("Thumbnail created at", tempFilePath);
      // We add a 'thumb_' prefix to thumbnails file name.
      // That's where we'll upload the thumbnail.
      const thumbFileName = `thumb_${fileName}`;
      const thumbFilePath = path.join(path.dirname(filePath), thumbFileName);

      // Uploading the thumbnail.
      await bucket.upload(
          tempFilePath,
          {
            destination: thumbFilePath,
            metadata: metadata,
          });
      if (fileName.startsWith("tutorial_image_")) {
        const tutorialId = path.parse(fileName).name.replace(
            "tutorial_image_",
            "",
        );
        const downloadUrl = `https://firebasestorage.googleapis.com/v0/b/modern-turkmen.appspot.com/o/${thumbFileName}?alt=media&token=${uuid}`;
        await admin.firestore().collection("tutorials").doc(tutorialId).update({
          "thumb_url": downloadUrl,
        });
      }

      return fs.unlinkSync(tempFilePath);
    });

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modern_turkmen_admin/data/services/image_picker_service.dart';

void main() {
  late ImagePickerService service;

  setUpAll(() {
    // Initialize Flutter binding for platform channels
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // Mock the image_picker method channel using the new approach
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/image_picker'),
      (MethodCall methodCall) async {
        // Return null for all methods to simulate no files selected
        switch (methodCall.method) {
          case 'pickImage':
          case 'pickVideo':
          case 'pickMedia':
            return null;
          case 'pickMultiImage':
          case 'pickMultipleMedia':
            return <String>[];
          default:
            return null;
        }
      },
    );
  });

  setUp(() {
    service = ImagePickerService();
  });

  group('ImagePickerService', () {
    test('pickFile returns empty list when no files selected for multiple media', () async {
      // The method channel is set to return empty list for multiple selection
      final result = await service.pickFile(['image/jpeg', 'video/mp4'], true);

      expect(result, equals([]));
    });

    test('pickFile returns null when no files selected for single media', () async {
      // The method channel is already set to return null in setUpAll
      final result = await service.pickFile(['image/jpeg', 'video/mp4'], false);

      expect(result, isNull);
    });

    test('pickFile returns empty list when no images selected for multiple images', () async {
      // The method channel is set to return empty list for multiple selection
      final result = await service.pickFile(['image/jpeg'], true);

      expect(result, equals([]));
    });

    test('pickFile returns null when no image selected for single image', () async {
      // The method channel is already set to return null in setUpAll
      final result = await service.pickFile(['image/jpeg'], false);

      expect(result, isNull);
    });

    test('pickFile returns null when no video selected', () async {
      // The method channel is already set to return null in setUpAll
      final result = await service.pickFile(['video/mp4'], false);

      expect(result, isNull);
    });

    test('pickFile handles method properly when both image and video mime types supported', () async {
      // Test that the method doesn't throw and returns null when no files selected
      final result = await service.pickFile(['image/jpeg', 'video/mp4'], false);
      expect(result, isNull);
    });

    test('pickFile handles method properly when only image mime type supported', () async {
      // Test that the method doesn't throw and returns null when no files selected
      final result = await service.pickFile(['image/jpeg'], false);
      expect(result, isNull);
    });

    test('pickFile handles method properly when only video mime type supported', () async {
      // Test that the method doesn't throw and returns null when no files selected
      final result = await service.pickFile(['video/mp4'], false);
      expect(result, isNull);
    });

    test('pickFile returns null when no supported mime types provided', () async {
      final result = await service.pickFile(['application/pdf'], false);

      expect(result, isNull);
    });
  });
}
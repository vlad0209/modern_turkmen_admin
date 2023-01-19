# modern_turkmen_admin

Content management system for [Modern Turkmen app](https://github.com/vlad0209/modern_turkmen)

## Requirements

This tool requires [Flutter](https://docs.flutter.dev/get-started/install), [Firebase CLI](https://firebase.google.com/docs/cli?authuser=0&hl=en#install_the_firebase_cli), [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup), [Nodejs and npm](https://nodejs.org/)

## Getting Started

Clone the repository:

```bash
$ git clone https://github.com/vlad0209/modern_turkmen_admin.git
$ cd modern_turkmen_admin
```

Install dependencies:

```bash
$ flutter pub get
$ cd functions
$ npm install
$ cd ..
```

Run the FlutterFire CLI:

```bash
$ flutterfire configure
```

Select the same Firebase project you use for the modern_turkmen app.

Build the app for Web:

```bash
$ flutter build web --web-renderer html
```

Init Firebase hosting:

```bash
$ firebase init hosting
```

Deploy the project to Firebase:

```bash
$ firebase deploy
```

In the [Firebase Console](https://console.firebase.google.com/) 


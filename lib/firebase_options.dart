// ignore_for_file: lines_longer_than_80_chars

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase options for project `mad-ica12-inventory-tmaku` (ICA #12).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDFgAS8TGn0rVzlXmZTePulHSy0Z6jppLY',
    appId: '1:986411634949:web:6721eab783318fdc58676c',
    messagingSenderId: '986411634949',
    projectId: 'mad-ica12-inventory-tmaku',
    authDomain: 'mad-ica12-inventory-tmaku.firebaseapp.com',
    storageBucket: 'mad-ica12-inventory-tmaku.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDmlMN6gi5woHiKxmgj_sJoq18Rlfv3su4',
    appId: '1:986411634949:android:53e8054b9595c22b58676c',
    messagingSenderId: '986411634949',
    projectId: 'mad-ica12-inventory-tmaku',
    storageBucket: 'mad-ica12-inventory-tmaku.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAU3uWa-Ec5RAGQUWgHIDBbxfiR_bqt11s',
    appId: '1:986411634949:ios:fcffb3d82796d7ca58676c',
    messagingSenderId: '986411634949',
    projectId: 'mad-ica12-inventory-tmaku',
    storageBucket: 'mad-ica12-inventory-tmaku.firebasestorage.app',
    iosBundleId: 'edu.gsu.tmaku.madFirebase2',
  );
}

// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCBYbzDqGNGKB0_zJOZsRZs5PrF6zux4mQ',
    appId: '1:133678038414:web:ed058dd28e986fc809b8df',
    messagingSenderId: '133678038414',
    projectId: 'mlm-app-vijayawada',
    authDomain: 'mlm-app-vijayawada.firebaseapp.com',
    storageBucket: 'mlm-app-vijayawada.appspot.com',
    measurementId: 'G-J2T3GREMRL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBmDvYHdwAt3hLgiqHpyHhgni3iLlOHC_k',
    appId: '1:133678038414:android:cc870bbda5c07be309b8df',
    messagingSenderId: '133678038414',
    projectId: 'mlm-app-vijayawada',
    storageBucket: 'mlm-app-vijayawada.appspot.com',
  );
}

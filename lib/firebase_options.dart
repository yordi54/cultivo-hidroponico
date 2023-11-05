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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyB6d7uPAbvNDir-H4rocoiDvmAIruW2xEg',
    appId: '1:207969446348:web:c06cd251642ff62c7b1569',
    messagingSenderId: '207969446348',
    projectId: 'sistemahidroponico-cb0a5',
    authDomain: 'sistemahidroponico-cb0a5.firebaseapp.com',
    databaseURL: 'https://sistemahidroponico-cb0a5-default-rtdb.firebaseio.com',
    storageBucket: 'sistemahidroponico-cb0a5.appspot.com',
    measurementId: 'G-936FD45H01',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBj16JZXkBlcq8-q6BKgxs5WhMcSTJ01s8',
    appId: '1:207969446348:android:584d70655277bc427b1569',
    messagingSenderId: '207969446348',
    projectId: 'sistemahidroponico-cb0a5',
    databaseURL: 'https://sistemahidroponico-cb0a5-default-rtdb.firebaseio.com',
    storageBucket: 'sistemahidroponico-cb0a5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB03UdM88aIvn3AI3VfGqLE74CYRFrh0eM',
    appId: '1:207969446348:ios:4981005d7b0e869e7b1569',
    messagingSenderId: '207969446348',
    projectId: 'sistemahidroponico-cb0a5',
    databaseURL: 'https://sistemahidroponico-cb0a5-default-rtdb.firebaseio.com',
    storageBucket: 'sistemahidroponico-cb0a5.appspot.com',
    iosBundleId: 'com.example.cultivoHidroponico',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB03UdM88aIvn3AI3VfGqLE74CYRFrh0eM',
    appId: '1:207969446348:ios:a4f563f5b4765ae07b1569',
    messagingSenderId: '207969446348',
    projectId: 'sistemahidroponico-cb0a5',
    databaseURL: 'https://sistemahidroponico-cb0a5-default-rtdb.firebaseio.com',
    storageBucket: 'sistemahidroponico-cb0a5.appspot.com',
    iosBundleId: 'com.example.cultivoHidroponico.RunnerTests',
  );
}

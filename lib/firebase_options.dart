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
    apiKey: 'AIzaSyDLiI9AuviVaKSEqe-trYv_z5G9Z36Uzt4',
    appId: '1:272606286201:web:fef7bee851e988897e5fa8',
    messagingSenderId: '272606286201',
    projectId: 'obsmngmnt',
    authDomain: 'obsmngmnt.firebaseapp.com',
    storageBucket: 'obsmngmnt.appspot.com',
    measurementId: 'G-5HJ7ZNCZ4S',
    databaseURL : 'https://obsmngmnt-default-rtdb.asia-southeast1.firebasedatabase.app'
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8qH-dKquBfkeg_sgGzRTEX3vjvwVQOdw',
    appId: '1:272606286201:android:9449785670b510f07e5fa8',
    messagingSenderId: '272606286201',
    projectId: 'obsmngmnt',
    storageBucket: 'obsmngmnt.appspot.com',
    databaseURL : 'https://obsmngmnt-default-rtdb.asia-southeast1.firebasedatabase.app'
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDSWYRIXtqbUzrDBsQY9AgvhW6F1QN0vHU',
    appId: '1:272606286201:ios:9865b3e43ffbb9de7e5fa8',
    messagingSenderId: '272606286201',
    projectId: 'obsmngmnt',
    storageBucket: 'obsmngmnt.appspot.com',
    iosBundleId: 'com.example.desktopadmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDSWYRIXtqbUzrDBsQY9AgvhW6F1QN0vHU',
    appId: '1:272606286201:ios:0005772a719eb4987e5fa8',
    messagingSenderId: '272606286201',
    projectId: 'obsmngmnt',
    storageBucket: 'obsmngmnt.appspot.com',
    iosBundleId: 'com.example.desktopadmin.RunnerTests',
  );
}

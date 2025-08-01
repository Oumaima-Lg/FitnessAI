// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyA-XMTWnVQX7zT9fjwi54fqgB4L9zPFELw',
    appId: '1:982607634011:web:22e8be842fecc93893697e',
    messagingSenderId: '982607634011',
    projectId: 'fitnessai-ed9b6',
    authDomain: 'fitnessai-ed9b6.firebaseapp.com',
    storageBucket: 'fitnessai-ed9b6.firebasestorage.app',
    measurementId: 'G-Z5YJ2MYW24',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAMzUyJ5rpbqtSEboZAAKzmgKc5nC5kzaw',
    appId: '1:982607634011:android:ff2813dc269a609a93697e',
    messagingSenderId: '982607634011',
    projectId: 'fitnessai-ed9b6',
    storageBucket: 'fitnessai-ed9b6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCyVXDqT0rA-IFJfNn1HF26y1AlF1TLaKw',
    appId: '1:982607634011:ios:cdc1800dfbc82c4e93697e',
    messagingSenderId: '982607634011',
    projectId: 'fitnessai-ed9b6',
    storageBucket: 'fitnessai-ed9b6.firebasestorage.app',
    iosBundleId: 'com.example.fitness',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCyVXDqT0rA-IFJfNn1HF26y1AlF1TLaKw',
    appId: '1:982607634011:ios:cdc1800dfbc82c4e93697e',
    messagingSenderId: '982607634011',
    projectId: 'fitnessai-ed9b6',
    storageBucket: 'fitnessai-ed9b6.firebasestorage.app',
    iosBundleId: 'com.example.fitness',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA-XMTWnVQX7zT9fjwi54fqgB4L9zPFELw',
    appId: '1:982607634011:web:810c28e5e050e14593697e',
    messagingSenderId: '982607634011',
    projectId: 'fitnessai-ed9b6',
    authDomain: 'fitnessai-ed9b6.firebaseapp.com',
    storageBucket: 'fitnessai-ed9b6.firebasestorage.app',
    measurementId: 'G-ZWBKBZESDD',
  );
}

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
      apiKey: 'AIzaSyDyRTPtmXloofEquEH6vh_7C1ZQ-kunuME',
      appId: '1:855471216767:web:4615fce9daf0d01d13074a',
      messagingSenderId: '855471216767',
      projectId: 'univadventure',
      authDomain: 'univadventure.firebaseapp.com',
      storageBucket: 'univadventure.appspot.com',
      measurementId: 'G-21344JZW4K',
      databaseURL:
          "https://univadventure-palme-default-rtdb.europe-west1.firebasedatabase.app/");

  static const FirebaseOptions android = FirebaseOptions(
      apiKey: 'AIzaSyC-RMNovBKCpts-HIwLut-9F2ZOKro9_PE',
      appId: '1:855471216767:android:7b2fe5a41908f21613074a',
      messagingSenderId: '855471216767',
      projectId: 'univadventure',
      storageBucket: 'univadventure.appspot.com',
      databaseURL:
          "https://univadventure-palme-default-rtdb.europe-west1.firebasedatabase.app/");

  static const FirebaseOptions ios = FirebaseOptions(
      apiKey: 'AIzaSyCpTazCM3H7uxhN9dlsDujpfVa4sIgj5Is',
      appId: '1:855471216767:ios:f673052e6651d54d13074a',
      messagingSenderId: '855471216767',
      projectId: 'univadventure',
      storageBucket: 'univadventure.appspot.com',
      iosBundleId: 'com.example.univAdventure',
      databaseURL:
          "https://univadventure-palme-default-rtdb.europe-west1.firebasedatabase.app/");

  static const FirebaseOptions macos = FirebaseOptions(
      apiKey: 'AIzaSyCpTazCM3H7uxhN9dlsDujpfVa4sIgj5Is',
      appId: '1:855471216767:ios:f673052e6651d54d13074a',
      messagingSenderId: '855471216767',
      projectId: 'univadventure',
      storageBucket: 'univadventure.appspot.com',
      iosBundleId: 'com.example.univAdventure',
      databaseURL:
          "https://univadventure-palme-default-rtdb.europe-west1.firebasedatabase.app/");

  static const FirebaseOptions windows = FirebaseOptions(
      apiKey: 'AIzaSyDyRTPtmXloofEquEH6vh_7C1ZQ-kunuME',
      appId: '1:855471216767:web:c62a340100bdd5b713074a',
      messagingSenderId: '855471216767',
      projectId: 'univadventure',
      authDomain: 'univadventure.firebaseapp.com',
      storageBucket: 'univadventure.appspot.com',
      measurementId: 'G-CTNR3K8V0L',
      databaseURL:
          "https://univadventure-palme-default-rtdb.europe-west1.firebasedatabase.app/");
}

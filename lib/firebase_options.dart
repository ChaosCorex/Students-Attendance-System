// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBCV6tnmMR9zwHoeJNu-pHxMpnSM594eTU',
    appId: '1:622195409889:web:0811f3fff69a016fe908a0',
    messagingSenderId: '622195409889',
    projectId: 'ssas-1fe14',
    authDomain: 'ssas-1fe14.firebaseapp.com',
    databaseURL: 'https://ssas-1fe14-default-rtdb.firebaseio.com',
    storageBucket: 'ssas-1fe14.appspot.com',
    measurementId: 'G-S9BHE4KFNH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjJQ6WjDnSv3yl28PgYWDlvCG4An76pB4',
    appId: '1:622195409889:android:035ac922f07bc97be908a0',
    messagingSenderId: '622195409889',
    projectId: 'ssas-1fe14',
    databaseURL: 'https://ssas-1fe14-default-rtdb.firebaseio.com',
    storageBucket: 'ssas-1fe14.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDxwsUU6vlQOw9ExsZMhSnywwVmv6iy4bs',
    appId: '1:622195409889:ios:4703e52249ef2a34e908a0',
    messagingSenderId: '622195409889',
    projectId: 'ssas-1fe14',
    databaseURL: 'https://ssas-1fe14-default-rtdb.firebaseio.com',
    storageBucket: 'ssas-1fe14.appspot.com',
    androidClientId: '622195409889-8du7c505kihqscr5jn8105lb83oj9j33.apps.googleusercontent.com',
    iosClientId: '622195409889-9tsmg6lq3e12ckvek08qeego1ughj6k0.apps.googleusercontent.com',
    iosBundleId: 'com.example.ssas',
  );
}

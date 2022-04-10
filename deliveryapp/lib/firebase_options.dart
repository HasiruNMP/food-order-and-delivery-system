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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByjnZQvSRstT9GITY69FeABYTD72N3cDs',
    appId: '1:67083259260:android:a1924897c4102ba08a68f9',
    messagingSenderId: '67083259260',
    projectId: 'ddhprr-fods',
    storageBucket: 'ddhprr-fods.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBvjEt3iFXP0ss7y2XQFmoIjgLwf-VoBFI',
    appId: '1:67083259260:ios:aa601598660be4938a68f9',
    messagingSenderId: '67083259260',
    projectId: 'ddhprr-fods',
    storageBucket: 'ddhprr-fods.appspot.com',
    iosClientId: '67083259260-fpd3u40pm9thom2fove4ue5pamkcb555.apps.googleusercontent.com',
    iosBundleId: 'com.fods.deliveryapp',
  );
}
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
    apiKey: 'AIzaSyCrmHP8wvr-3GbLDgIUxlRXWZ1BTGWVZYM',
    appId: '1:538083653908:web:6ff357399d717aab01aa01',
    messagingSenderId: '538083653908',
    projectId: 'eatery-c9660',
    authDomain: 'eatery-c9660.firebaseapp.com',
    storageBucket: 'eatery-c9660.appspot.com',
    measurementId: 'G-5QKQ3Y0NZQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzrp17dtA-LBbvcCv2DXeYdBAvRrkEQF8',
    appId: '1:538083653908:android:d361e7aae18bd3c501aa01',
    messagingSenderId: '538083653908',
    projectId: 'eatery-c9660',
    storageBucket: 'eatery-c9660.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDa83_n-jJdjgoMng3xv1v31qVuS4rGD5Y',
    appId: '1:538083653908:ios:04b4008eda827da101aa01',
    messagingSenderId: '538083653908',
    projectId: 'eatery-c9660',
    storageBucket: 'eatery-c9660.appspot.com',
    iosClientId: '538083653908-24nk1v1nmvn36n4pd3thurm1nv4pd5qp.apps.googleusercontent.com',
    iosBundleId: 'com.example.eatery',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDa83_n-jJdjgoMng3xv1v31qVuS4rGD5Y',
    appId: '1:538083653908:ios:04b4008eda827da101aa01',
    messagingSenderId: '538083653908',
    projectId: 'eatery-c9660',
    storageBucket: 'eatery-c9660.appspot.com',
    iosClientId: '538083653908-24nk1v1nmvn36n4pd3thurm1nv4pd5qp.apps.googleusercontent.com',
    iosBundleId: 'com.example.eatery',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCrmHP8wvr-3GbLDgIUxlRXWZ1BTGWVZYM',
    appId: '1:538083653908:web:a6fb2bedf6b4abcd01aa01',
    messagingSenderId: '538083653908',
    projectId: 'eatery-c9660',
    authDomain: 'eatery-c9660.firebaseapp.com',
    storageBucket: 'eatery-c9660.appspot.com',
    measurementId: 'G-71KBBZ8XR8',
  );

}
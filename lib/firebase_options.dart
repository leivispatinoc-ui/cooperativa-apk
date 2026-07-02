import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyAD1O6V-9b_9xo4miTvHJRGvupCup_O-dI",
      appId: "1:420960631788:android:957bfd5b15a20d07ee5ec9",
      messagingSenderId: "420960631788",
      projectId: "cooperativa-motorizados",
      storageBucket: "cooperativa-motorizados.firebasestorage.app",
    );
  }
}
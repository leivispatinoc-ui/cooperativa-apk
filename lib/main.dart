import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAD1O6V-9b_9xo4miTvHJRGvupCup_O-dI",
        authDomain: "cooperativa-motorizados.firebaseapp.com",
        projectId: "cooperativa-motorizados",
        storageBucket: "cooperativa-motorizados.firebasestorage.app",
        messagingSenderId: "420960631788",
        appId: "1:420960631788:web:957bfd5b15a20d07ee5ec9",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
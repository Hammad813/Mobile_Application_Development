import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBBlCPfPProXWpI08rldPJhcAOfPeXtbB8",
        authDomain: "loginsignupquiz-78767.firebaseapp.com",
        projectId: "loginsignupquiz-78767",
        storageBucket: "loginsignupquiz-78767.firebasestorage.app",
        messagingSenderId: "783939520258",
        appId: "1:783939520258:web:46961c5fa25dba40f7a41b",
        measurementId: "G-4D63Z0F6SW",
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
    return MaterialApp(
      title: 'Login/Signup Firebase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}

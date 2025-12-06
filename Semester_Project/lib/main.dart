import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mid_project/login.dart';
import 'package:mid_project/provider/theme_changer_provider.dart';
import 'package:provider/provider.dart';

// Add these imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Add these lines
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChanger>(
      builder: (context, themeChanger, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeChanger.themeMode,
          theme: themeChanger.lightTheme,
          darkTheme: themeChanger.darkTheme,
          home: const GetStarted(),
        );
      },
    );
  }
}

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffc5d3),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              'assets/animation/Delivery.json',
              reverse: false,
              repeat: true,
              animate: true,
              width: 300,
              height: 300,
            ),
          ),
          const Text(
            'Delicious Food',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          ),
          const Center(child: Text('We help you to find best and')),
          const Center(child: Text('Delicious Food')),
          const SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/animation/pic.PNG', width: 30, height: 20),
                const SizedBox(width: 5),
                Image.asset('assets/animation/pic.PNG', width: 20, height: 20),
                const SizedBox(width: 5),
                Image.asset('assets/animation/pic.PNG', width: 20, height: 20),
              ],
            ),
          ),
          const SizedBox(height: 100),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Login()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              fixedSize: const Size(280, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Get Started',
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  void _signup() async {
    final res = await _auth.signup(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    if (res == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful')));
      Navigator.pop(context); // go back to login screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res ?? 'Error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white10,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white10,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signup,
              child: const Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}

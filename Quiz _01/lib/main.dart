import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Entry point
  runApp(const ProfileApp());
}

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProfileApp',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.indigo),
      home: const ProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // --- constants for original data ---
  static const String _originalName = 'Md.Hammad';
  static const String _originalEmail = 'hammadgamer813@gmail.com';

  final TextEditingController _nameController = TextEditingController();
  String? _validationMessage;
  String _displayName = _originalName; // default display name

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // --- save new username ---
  void _saveName() {
    final text = _nameController.text.trim();
    setState(() {
      if (text.isEmpty) {
        _validationMessage = 'Username cannot be empty.';
      } else {
        _validationMessage = null;
        _displayName = text;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Username saved')));
      }
    });
  }

  // --- reset to original data ---
  void _clearName() {
    setState(() {
      _displayName = _originalName;
      _nameController.clear();
      _validationMessage = null;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile reset to original')));
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Screen'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- top content ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // profile picture
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: ClipOval(
                      child: Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.person, size: 64),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- name & email ---
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: '$_displayName\n',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: _originalEmail,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- buttons row ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Profile'),
                              content: Text(
                                'Name: $_displayName\nEmail: $_originalEmail',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('View Profile'),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: _clearName,
                        child: const Text('Reset'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- about section ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'I am a 5th semester Software Engineering student, '
                      'currently studying the Mobile Application Development (MAD) course. '
                      'I enjoy learning Flutter and Dart to build real mobile apps!',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- textfield to edit username ---
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Edit username',
                      border: const OutlineInputBorder(),
                      errorText: _validationMessage,
                      hintText: 'Enter a username',
                    ),
                    onSubmitted: (_) => _saveName(),
                  ),

                  const SizedBox(height: 8),

                  // --- save/reset buttons below text field ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _clearName,
                        child: const Text('Reset'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _saveName,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),

              // --- bottom: orientation display ---
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Orientation: ${isPortrait ? 'Portrait' : 'Landscape'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

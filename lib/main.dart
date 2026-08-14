import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Batman Password Generator',
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFFC8B9DA),
        scaffoldBackgroundColor: CupertinoColors.black,
      ),
      home: PasswordScreen(),
    );
  }
}

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _editTextController = TextEditingController();
  String _message = '';

  void _getNewestPassword() {
    setState(() {
      String input = _editTextController.text;
      if (input.length >= 3) {
        int hashCode = input.hashCode.abs();
        String salt = hashCode.toString().substring(0,3);
        _message = '${input}BTM${salt}#';
      } else {
        _message = 'Enter at least 3 digits';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        children: [
          // 1. Background Image with Dark Overlay
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                CupertinoColors.black.withOpacity(0.65),
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/batman_dark.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Foreground iOS UI Content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // iOS Styled Text Field
                    CupertinoTextField(
                      controller: _editTextController,
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                      textAlign: TextAlign.center,
                      placeholder: 'Enter 5-digit code',
                      placeholderStyle: const TextStyle(color: CupertinoColors.systemGrey),
                      style: const TextStyle(color: CupertinoColors.white, fontSize: 18),
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // iOS Styled Button
                    CupertinoButton.filled(
                      onPressed: _getNewestPassword,
                      child: const Text(
                        'Generate',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _message,
                        key: ValueKey(_message),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE0E0E0),
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
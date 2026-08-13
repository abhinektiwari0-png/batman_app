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

  // Dart implementation of the Java calNewest algorithm
  String _calNewest(String str) {
    if (str.length != 5) return "Length error";

    DateTime now = DateTime.now();
    int i = now.year;
    int i2 = now.month; // 1-based month matching Java's month + 1
    int i3 = now.day;

    // Dart weekday: Monday=1 ... Sunday=7. Java Time weekDay: Sunday=0, Monday=1 ... Saturday=6
    int i4 = now.weekday == 7 ? 7 : now.weekday;
    int i5 = int.parse(DateTime(now.year, now.month, now.day).difference(DateTime(now.year, 1, 1)).inDays.toString()) + 1;

    try {
      int j = int.parse(str);
      int j2 = j ~/ 100000000;
      int j3 = j % 100000000;
      int j4 = j2 + (j3 ~/ 10000000);
      int j5 = j3 % 10000000;
      int j6 = j4 + (j5 ~/ 1000000);
      int j7 = j5 % 1000000;
      int j8 = j6 + (j7 ~/ 100000);
      int j9 = j7 % 100000;
      int j10 = j8 + (j9 ~/ 10000);
      int j11 = j9 % 10000;
      int j12 = j10 + (j11 ~/ 1000);
      int j13 = j11 % 1000;
      int j14 = j12 + (j13 ~/ 100);
      int j15 = j13 % 100;
      int j16 = j14 + (j15 ~/ 10) + (j15 % 10);

      int part1 = int.parse("${str[0]}${str[2]}${str[4]}");
      int part2 = int.parse("${str[4]}${str[2]}${str[0]}");

      int j17 = (((((((i2 * i3) + i)) + ((j16 * j16) * j16)) + (i4 * i4)) + i5) + (part1 * part2)) ^ 36873;

      int r1 = j17 % 10;
      int r2 = (j17 ~/ 10) % 10;
      int r3 = (j17 ~/ 100) % 10;
      int r4 = (j17 ~/ 1000) % 10;
      int r5 = (j17 ~/ 10000) % 10;

      int finalVal = (r1 * 10000) + (r2 * 1000) + (r3 * 100) + (r4 * 10) + r5;
      return finalVal.toString().padLeft(5, '0');
    } catch (e) {
      return "Error";
    }
  }

  void _getNewestPassword() {
    setState(() {
      String strTrim = _editTextController.text.trim();
      if (strTrim.length != 5) {
        _message = "Length error";
        _editTextController.text = "";
      } else {
        _message = _calNewest(strTrim);
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

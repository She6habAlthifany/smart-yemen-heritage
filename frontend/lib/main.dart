// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/OnboardingScreen1.dart';
void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'المتحف الرقمي',
      theme: ThemeData(textTheme: GoogleFonts.tajawalTextTheme()),
      home:  Directionality(
        textDirection: TextDirection.rtl,
        child: OnboardingScreen1(),
      ),
    );
  }
}


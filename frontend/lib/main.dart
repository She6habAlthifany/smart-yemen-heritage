import 'package:flutter/material.dart';
import 'package:frontend/features/schedule/schedule_screen.dart';
import 'package:frontend/features/schedule2/schedule2_screen.dart';
import 'core/constants/app_colors.dart';

//  استيراد الصفحات
import 'features/auth/login/login_screen.dart';
import 'features/auth/signup/signup_screen.dart';
import 'features/auth/forgot_password/forgot_password_screen.dart';
import 'features/auth/forgot_password/verification_screen.dart';
import 'features/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق تسجيل الدخول',
      debugShowCheckedModeBanner: false,

      //  إعداد الثيم الأساسي
      theme: ThemeData(
        fontFamily: 'Tajawal',
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      //  الصفحة التي تبدأ عند تشغيل التطبيق
      initialRoute: '/login',

      //  جميع الصفحات (Routes)
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/verify': (context) => const VerificationScreen(),
        '/home': (context) => const HomeScreen(userName: '',),
        '/schedule': (context) => const ScheduleScreen(),
        '/schedule2': (context) => const Schedule2Screen(),
      },
    );
  }
}

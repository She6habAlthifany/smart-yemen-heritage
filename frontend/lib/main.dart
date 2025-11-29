import 'package:flutter/material.dart';

// -------------------------
// 🧱 Core
// -------------------------
import 'core/constants/app_colors.dart';

// -------------------------
// 📱 Features – Auth
// -------------------------
import 'features/auth/login/login_screen.dart';
import 'features/auth/signup/signup_screen.dart';
import 'features/auth/forgot_password/forgot_password_screen.dart';
import 'features/auth/forgot_password/verification_screen.dart';

// -------------------------
// 📱 Features – Main App
// -------------------------
import 'features/home/home_screen.dart';
import 'features/landmarks/schedule_screen.dart';
import 'features/Kingdoms/schedule2_screen.dart';
import 'features/favorites/favorites_screen.dart';
import 'features/profile/profile_screen.dart';

// -------------------------
// 🏁 Startup Screens
// -------------------------
import 'features/onboarding/onboarding_screen.dart';
import 'features/splash/splash_screen.dart';


// ******************************************************
// 🌐 API Base URL
// (قم بتعديل الرابط عند الاتصال بالسيرفر الحقيقي)
// ******************************************************
const String apiBaseUrl = "http://10.0.2.2:5000/api";


// ******************************************************
// 🚀 Application Entry Point
// ******************************************************
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


// ******************************************************
// 🎨 MyApp Widget
// ******************************************************
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'التطبيق السياحي',
      debugShowCheckedModeBanner: false,

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

      // 🔰 الصفحة التي يبدأ عليها التطبيق
      initialRoute: '/splash',

      // 🗺️ تعريف جميع الصفحات هنا
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/verify': (context) => const VerificationScreen(),

        '/home': (context) => const HomeScreen(userName: ''),

        '/landmarks': (context) => const LandmarksScreen(),
        '/Kingdoms': (context) => const KingdomsScreen(),

        '/favorites': (context) => const FavoritesScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

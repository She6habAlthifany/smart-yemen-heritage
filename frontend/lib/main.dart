import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/login/login_screen.dart';
import 'features/auth/signup/signup_screen.dart';
import 'features/auth/forgot_password/forgot_password_screen.dart';
import 'features/auth/forgot_password/verification_screen.dart';
import 'features/favorites/favorites_screen.dart';
import 'features/home/home_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/schedule/schedule_screen.dart';
import 'features/schedule2/schedule2_screen.dart';

// 📌 API Base URL (بعد الربط غيره إلى رابط السيرفر)
const String apiBaseUrl = "http://10.0.2.2:5000/api";

//  استيراد الصفحات


void main() async {
  // ضروري لانتظار أي عمليات async قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();

  // ⚡ إذا عندك Services تحتاج تهيئة قبل التشغيل (مثل shared prefs)
  // await FavoritesService.instance.init();

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

      //  الصفحة التي يبدأ عليها التطبيق
      initialRoute: '/login',

      //  تعريف جميع الصفحات
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/verify': (context) => const VerificationScreen(),
        '/home': (context) => const HomeScreen(userName: '',),
        '/schedule': (context) => const ScheduleScreen(),
        '/schedule2': (context) => const Schedule2Screen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

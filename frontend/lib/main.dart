import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/settings_provider.dart';
import 'core/constants/app_colors.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/login/login_screen.dart';
import 'features/auth/signup/signup_screen.dart';
import 'features/auth/forgot_password/forgot_password_screen.dart';
import 'features/auth/forgot_password/verification_screen.dart';
import 'features/home/home_screen.dart';
import 'features/schedule/schedule_screen.dart';
import 'features/schedule2/schedule2_screen.dart';
import 'features/favorites/favorites_screen.dart';
import 'features/profile/profile_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    ChangeNotifierProvider<SettingsProvider>.value(
      value: settingsProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'Yemen Heritage',
          debugShowCheckedModeBanner: false,
          locale: settings.locale,
          supportedLocales: const [
            Locale('ar'),
            Locale('en'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // Theme - light and dark
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
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.light),
          ),

          darkTheme: ThemeData(
            fontFamily: 'Tajawal',
            brightness: Brightness.dark,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: Colors.grey[900],
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.primary,
              centerTitle: true,
              titleTextStyle: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.dark),
          ),

          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          // routes
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/forgot_password': (context) => const ForgotPasswordScreen(),
            '/verify': (context) => const VerificationScreen(),
            '/home': (context) => const HomeScreen(userName: ''),
            '/schedule': (context) => const ScheduleScreen(),
            '/schedule2': (context) => const Schedule2Screen(),
            '/favorites': (context) => const FavoritesScreen(),
            '/profile': (context) => const ProfileScreen(),
          },
        );
      },
    );
  }
}

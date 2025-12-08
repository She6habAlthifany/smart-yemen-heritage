import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'core/app_controller.dart';
import 'core/settings/settings_controller.dart';
import 'features/profile/about_app_screen.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/login/login_screen.dart';
import 'features/auth/signup/signup_screen.dart';
import 'features/auth/forgot_password/forgot_password_screen.dart';
import 'features/auth/forgot_password/verification_screen.dart';
import 'features/home/home_screen.dart';
import 'features/favorites/favorites_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/landmarks/schedule_screen.dart';
import 'features/Kingdoms/schedule2_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = SettingsController();
  await settingsController.loadFromPrefs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsController>.value(value: settingsController),
        // يمكنك إضافة مزوّدات أخرى هنا
      ],
      child: const AppRoot(),
    ),
  );
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppController.themeMode,
      builder: (context, themeModeValue, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: AppController.locale,
          builder: (context, localeValue, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Yemen Heritage',
              locale: localeValue,
              themeMode: themeModeValue,
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
              darkTheme: ThemeData.dark(),
              initialRoute: '/splash',
              routes: {
                '/splash': (c) => const SplashScreen(),
                '/onboarding': (c) => const OnboardingScreen(),
                '/login': (c) => const LoginPage(),
                '/signup': (c) => const SignupScreen(),
                '/forgot_password': (c) => const ForgotPasswordScreen(),
                '/verify': (c) => const VerificationScreen(),
                '/home': (c) => const HomeScreen(userName: ''),
                '/schedule': (c) => const LandmarksScreen(),
                '/schedule2': (c) => const KingdomsScreen(),
                '/favorites': (c) => const FavoritesScreen(),
                '/profile': (c) => const ProfileScreen(),
                '/about_app': (context) => const AboutAppScreen(),
              },
            );
          },
        );
      },
    );
  }
}

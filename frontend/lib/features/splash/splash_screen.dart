import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      setState(() => _initializationStatus = 'Checking authentication...');
      await Future.delayed(const Duration(milliseconds: 500));

      final isAuthenticated = await _checkAuthenticationStatus();

      setState(() => _initializationStatus = 'Loading preferences...');
      await Future.delayed(const Duration(milliseconds: 500));

      await _loadLanguagePreferences();

      setState(() => _initializationStatus = 'Loading heritage content...');
      await Future.delayed(const Duration(milliseconds: 500));

      await _fetchCachedContent();

      setState(() => _initializationStatus = 'Preparing AR features...');
      await Future.delayed(const Duration(milliseconds: 500));

      await _prepareARCapabilities();

      await _animationController.forward();
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      _navigateToNextScreen(isAuthenticated);
    } catch (e) {
      if (!mounted) return;
      _showRetryDialog();
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return false;
  }

  Future<void> _loadLanguagePreferences() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _fetchCachedContent() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _prepareARCapabilities() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _navigateToNextScreen(bool isAuthenticated) async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingSeen = prefs.getBool("onboarding_seen") ?? false;

    if (!onboardingSeen) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else if (!isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Connection Error'),
        content: const Text(
          'Unable to initialize the application. Please check your connection and try again.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => _isInitializing = true);
              _initializeApp();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,

          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // الشعار
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.account_balance,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  '𐩬𐩣𐩺𐩡𐩱 𐩻𐩧𐩩',
                  style: TextStyle(
                    fontFamily: 'OldSouthArabian',
                    color: AppColors.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),


                const SizedBox(height: 8),

                Text(
                  'الموسوعة الذكية في تاريخ اليمن القديم',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                  ),
                ),

                const Spacer(flex: 2),

                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 16),

                AnimatedOpacity(
                  opacity: _isInitializing ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _initializationStatus,
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

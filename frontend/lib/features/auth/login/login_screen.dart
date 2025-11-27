import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_colors.dart';
import '../../home/home_screen.dart';
import '../signup/signup_screen.dart';
import '../forgot_password/forgot_password_screen.dart';

// تعريف لون الخلفية البيج الفاتح الذي سيستخدم الآن كخلفية للحقول
const Color _fieldsBackgroundColor = Color(0xFFFBF8F0);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool isLoading = false;
  bool rememberMe = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  // ... (دوال _loadSavedLogin و _saveLoginData و loginUser كما هي)

  Future<void> _loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString("saved_email");
    final savedPassword = prefs.getString("saved_password");
    final savedRemember = prefs.getBool("remember_me") ?? false;

    if (savedRemember && savedEmail != null && savedPassword != null) {
      setState(() {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
        rememberMe = true;
      });
    }
  }

  Future<void> _saveLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('saved_email', emailController.text);
      await prefs.setString('saved_password', passwordController.text);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }
  }

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => isLoading = true);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      const String BASE_URL = "http://10.0.2.2:5000/api/users";

      final response = await http
          .post(
        Uri.parse("$BASE_URL/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_email": email,
          "user_password": password,
        }),
      )
          .timeout(const Duration(seconds: 7));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);
        await prefs.setString("user_name", data["user"]["user_name"]);
        await _saveLoginData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم تسجيل الدخول بنجاح 🎉")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              userName: data["user"]["user_name"],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "بيانات الدخول غير صحيحة"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("انتهت مهلة الاتصال بالسيرفر"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("خطأ في الاتصال بالسيرفر"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => isLoading = false);
  }


  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // التعديل 1: جعل الخلفية بيضاء نقية
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo Circle (بلون AppColors.primary)
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child:
                  const Icon(Icons.person, color: Colors.white, size: 35),
                ),

                const SizedBox(height: 15),

                const Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4A4A),
                  ),
                ),

                const SizedBox(height: 30),

                // EMAIL
                TextFormField(
                  controller: emailController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: "البريد الإلكتروني",
                    prefixIcon: Icon(Icons.email, color: AppColors.primary),
                    // التعديل 2: جعل خلفية الحقل بيج فاتح
                    filled: true,
                    fillColor: _fieldsBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "الرجاء إدخال البريد الإلكتروني";
                    }
                    final emailRegex =
                    RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return "البريد الإلكتروني غير صالح";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // PASSWORD
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "كلمة المرور",
                    prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                    // التعديل 2: جعل خلفية الحقل بيج فاتح
                    filled: true,
                    fillColor: _fieldsBackgroundColor,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "الرجاء إدخال كلمة المرور";
                    }
                    if (value.length < 6) {
                      return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // Remember Me
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() => rememberMe = value!);
                      },
                      activeColor: AppColors.primary,
                    ),
                    const Text("تذكرني", style: TextStyle(fontSize: 16)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())
                        );
                      },
                      child: Text(
                        "نسيت كلمة المرور؟",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "تسجيل الدخول",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Signup Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("ليس لديك حساب؟ "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "إنشاء حساب",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
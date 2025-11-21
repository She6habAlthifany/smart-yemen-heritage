import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupService {
  static const String baseUrl = "http://10.0.2.2:5000/api/users/register";

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_name": name,
          "user_email": email,
          "user_password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          "success": true,
          "user": data["user"],
          "token": data["token"],
        };
      } else {
        return {
          "success": false,
          "message": data["message"] ?? "حدث خطأ غير متوقع"
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class AssistantService {
  static const String baseUrl = "http://10.0.2.2:5000/api/ai"; // ضع هنا عنوان backend

  static Future<String> sendMessage(String message) async {
    final url = Uri.parse('$baseUrl/chat');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? "لا يوجد رد";
      } else {
        return "خطأ في الخادم: ${response.statusCode}";
      }
    } catch (e) {
      return "فشل الاتصال بالخادم: $e";
    }
  }
}

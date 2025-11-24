import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/content_model.dart';

class ContentService {
  static const String baseUrl = "http://10.0.2.2:5000/api";

  // جلب كل المحتوى
  static Future<List<Content>> fetchContents() async {
    final response = await http.get(Uri.parse("$baseUrl/content"));

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((item) => Content.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load contents");
    }
  }
}

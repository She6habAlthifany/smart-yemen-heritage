import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/content_details_model.dart';

class ContentDetailsService {
  static const String baseUrl = "http://10.0.2.2:5000/api/content-details/by-content/";

  static Future<List<ContentDetails>> fetchContentDetails(String contentId) async {
    final url = Uri.parse('$baseUrl$contentId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => ContentDetails.fromJson(json)).toList();
    } else {
      throw Exception('فشل في جلب البيانات: ${response.statusCode}');
    }
  }
}

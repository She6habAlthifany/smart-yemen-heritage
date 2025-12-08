// lib/services/content_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/content_model.dart';

class ContentService {
  static const String baseUrl = "http://10.0.2.2:5000/api";

  // 🌟 التعديل: الدالة تقبل الآن معامل اختياري لنوع المحتوى
  static Future<List<Content>> fetchContents({String? type}) async {
    // 1. بناء الرابط الأساسي
    String url = "$baseUrl/content";

    // 2. إذا كان نوع المحتوى مُمررًا، أضف الـ Query Parameter
    if (type != null && type.isNotEmpty) {
      // بناء رابط مثل: http://10.0.2.2:5000/api/content?type=معالم
      url = "$url?type=$type";
    }

    final response = await http.get(Uri.parse(url)); // استخدام الرابط الجديد المُعدل

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((item) => Content.fromJson(item)).toList();
    } else {
      // يمكنك فحص حالة 404 إذا لم يتم العثور على النوع
      if (response.statusCode == 404) {
        // إذا كان السيرفر لم يجد نوع المحتوى، قد يكون الرد "[]" أو رسالة خطأ
        return [];
      }
      throw Exception("Failed to load contents. Status code: ${response.statusCode}");
    }
  }
}
import 'package:flutter/material.dart';
import '../../models/content_model.dart';
import '../../services/content_service.dart';
import 'details/content_details_screen.dart';

// تعريف الألوان الحديثة
// تم تحديث اللون الأساسي ليتناسب مع اللون الترابي/الذهبي الغامق في الصورة المرفقة
const Color _primaryColor = Color(0xFFCD853F); // لون ترابي دافئ (Peruvian Brown)
const Color _backgroundColor = Colors.white; // اللون الأبيض للخلفية
const Color _cardColor = Colors.white; // لون البطاقة (أبيض)

class LandmarksScreen extends StatefulWidget {
  const LandmarksScreen({super.key});

  @override
  State<LandmarksScreen> createState() => _LandmarksScreenState();
}

class _LandmarksScreenState extends State<LandmarksScreen> {
  late Future<List<Content>> _contentsFuture;

  // 🔹 صور افتراضية من assets
  final List<String> defaultImages = [
    "assets/images/dar_alhajar.jpg",
    "assets/images/bab_yemen.jpg",
    "assets/images/hadramout.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _contentsFuture = ContentService.fetchContents();
  }

  // 🔹 دالة عرض الصورة من API أو assets
  Widget buildImage(String? imageUrl, int index) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            defaultImages[index % defaultImages.length],
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(
      defaultImages[index % defaultImages.length],
      width: 80,
      height: 80,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // خلفية بيضاء خفيفة جداً لتباين أفضل
      appBar: AppBar(
        backgroundColor: _primaryColor, // اللون الترابي الجديد لشريط التطبيق
        title: const Text(
          "المعالم التاريخية",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // نص أبيض للتباين
        ),
        elevation: 4, // ظل خفيف لشريط التطبيق
      ),
      body: FutureBuilder<List<Content>>(
        future: _contentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: _primaryColor)); // مؤشر باللون الجديد
          } else if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ: ${snapshot.error}", style: const TextStyle(color: _primaryColor)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("لا توجد معالم متاحة"));
          }

          final contents = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: contents.length,
            itemBuilder: (context, index) {
              final item = contents[index];

              return GestureDetector(
                onTap: () {
                  // عند الضغط، انتقل لصفحة ContentDetailsScreen مع contentId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ContentDetailsScreen(contentId: item.id),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _cardColor, // لون البطاقة أبيض
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _primaryColor.withOpacity(0.5), width: 1), // حدود بلون ترابي خفيف
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15), // ظل أغمق قليلاً
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: buildImage(item.imageUrl, index),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  color: _primaryColor, // نص بلون ترابي على خلفية بيضاء
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              if (item.address != null)
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.grey, size: 16), // أيقونة بلون رمادي على خلفية بيضاء
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        item.address!,
                                        style: const TextStyle(
                                          color: Colors.grey, // نص رمادي
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            color: _primaryColor, size: 16), // أيقونة بلون ترابي
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

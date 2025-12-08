import 'package:flutter/material.dart';
// 💡 استيراد الموديل والخدمة من مساراتهما المشتركة
import '../../models/content_model.dart';
import '../../services/content_service.dart';
// 💡 استيراد شاشة التفاصيل العامة التي تتوقع contentId بدلاً من الشاشات المحددة
import '../landmarks/details/content_details_screen.dart';

// نفس الألوان المستخدمة في صفحة المعالم
const Color _primaryColor = Color(0xFFCD853F);
const Color _backgroundColor = Colors.white;

class KingdomsScreen extends StatefulWidget {
  const KingdomsScreen({super.key});

  @override
  State<KingdomsScreen> createState() => _KingdomsScreenState();
}

class _KingdomsScreenState extends State<KingdomsScreen> {

  // 1. تعريف Future لجلب قائمة المحتويات (الممالك)
  late Future<List<Content>> _contentsFuture;

  // 2. صور افتراضية (لحل مشكلة عدم وجود رابط صورة من API)
  final List<String> defaultImages = [
    "assets/images/saba.jpg",
    "assets/images/maeen.jpg",
    "assets/images/sayoon.jpg",
  ];

  @override
  void initState() {
    super.initState();
    // 3. 🎯 جلب المحتوى الخاص بالممالك فقط
    _contentsFuture = ContentService.fetchContents(type: 'Kingdoms');
  }

  // 4. دالة عرض الصورة (مماثلة لـ LandmarksScreen)
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
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _primaryColor,
        elevation: 4,
        title: const Text(
          "الممالك القديمة",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),

      // 5. استخدام FutureBuilder لعرض البيانات من الـ API
      body: FutureBuilder<List<Content>>(
        future: _contentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: _primaryColor));
          } else if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("لا توجد ممالك متاحة"));
          }

          final contents = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: contents.length,
            itemBuilder: (context, index) {
              final item = contents[index];
              return GestureDetector(
                onTap: () {
                  // 6. الانتقال إلى شاشة التفاصيل العامة باستخدام contentId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ContentDetailsScreen(contentId: item.id)),
                  );
                },
                child: _buildKingdomCard(item, index), // تمرير item و index
              );
            },
          );
        },
      ),
    );
  }

  // 👑 تصميم البطاقة معدّل ليقبل موديل Content
  Widget _buildKingdomCard(Content item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryColor.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
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
              // 7. استخدام دالة عرض الصورة الجديدة
              child: buildImage(item.imageUrl, index),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title, // استخدام title
                    style: const TextStyle(
                      color: _primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (item.address != null) // استخدام address
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.address!,
                            style: const TextStyle(
                              color: Colors.grey,
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
                color: _primaryColor, size: 16),
          ],
        ),
      ),
    );
  }
}
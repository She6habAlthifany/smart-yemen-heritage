import 'package:flutter/material.dart';
import '../../models/content_model.dart';
import '../../services/content_service.dart';
import 'details/content_details_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
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
      backgroundColor: const Color(0xFFFBE9D0),
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("المعالم التاريخية"),
      ),
      body: FutureBuilder<List<Content>>(
        future: _contentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ: ${snapshot.error}"));
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
                    color: const Color(0xFFA0522D),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
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
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              if (item.address != null)
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.white, size: 16),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        item.address!,
                                        style: const TextStyle(
                                          color: Colors.white,
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
                            color: Colors.white, size: 16),
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

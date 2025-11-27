import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../schedule/details/details_bab_yemen.dart';
import '../schedule/schedule_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  // قائمة المعالم والممالك
  final List<Map<String, dynamic>> allItems = [
    {
      "title": "باب اليمن",
      "image": "assets/images/bab_yemen.jpg",
      "page": const DetailsBabYemen(),
    },
    {
      "title": "دار الحجر",
      "image": "assets/images/dar_alhajar.jpg",
      "page": const ScheduleScreen(), // غيّرها حسب ملفك
    },
    {
      "title": "مملكة معين",
      "image": "assets/images/maeen.jpg",
      "page": null, // ضع صفحتها لاحقاً
    },
  ];

  List<Map<String, dynamic>> searchResults = [];

  void search(String text) {
    setState(() {
      searchResults = allItems
          .where((item) =>
      item["title"].toString().contains(text.trim()) ||
          item["title"]
              .toString()
              .startsWith(text.trim()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.40,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // مربع البحث
              TextField(
                controller: searchController,
                textAlign: TextAlign.right,
                onChanged: search,
                decoration: InputDecoration(
                  hintText: "ابحث عن معلم أو مملكة",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // قائمة النتائج
              Expanded(
                child: searchResults.isEmpty
                    ? const Center(
                  child: Text("لا توجد نتائج", style: TextStyle(fontSize: 18)),
                )
                    : ListView.builder(
                  controller: controller,
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final item = searchResults[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      trailing: Text(
                        item["title"],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item["image"],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context); // إغلاق نافذة البحث
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => item["page"],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

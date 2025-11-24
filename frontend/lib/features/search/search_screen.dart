import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../features/schedule/details/details_screen.dart'; // عدّل المسار

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  final List<Map<String, String>> allPlaces = [
    {'id': 'dar_alhajar', 'name': 'دار الحجر', 'image': 'assets/images/dar_alhajar.jpg', 'category': 'آثار'},
    {'id': 'bab_yemen', 'name': 'باب اليمن', 'image': 'assets/images/bab_yemen.jpg', 'category': 'آثار'},
    {'id': 'saba', 'name': 'مملكة سبأ', 'image': 'assets/images/saba.jpg', 'category': 'ممالك'},
    // أضف بياناتك هنا...
  ];

  List<Map<String, String>> get results {
    if (_query.trim().isEmpty) return allPlaces;
    final q = _query.trim().toLowerCase();
    return allPlaces.where((p) {
      return p['name']!.toLowerCase().contains(q) ||
          (p['category']?.toLowerCase().contains(q) ?? false) ||
          (p['id']!.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: TextField(
          controller: _controller,
          autofocus: true,
          textAlign: TextAlign.right,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(border: InputBorder.none, hintText: 'ابحث...', hintStyle: TextStyle(color: Colors.white70)),
          onChanged: (v) => setState(() => _query = v),
        ),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: results.length,
        itemBuilder: (context, i) {
          final p = results[i];
          return Card(
            child: ListTile(
              leading: Image.asset(p['image']!, width: 60, fit: BoxFit.cover),
              title: Text(p['name']!, textAlign: TextAlign.right),
              subtitle: Text(p['category'] ?? '', textAlign: TextAlign.right),
              onTap: () {
                // افتح التفاصيل - هنا نفتح نفس DetailsScreen كمثال
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailsScreen(placeId: null, title: null, image: null, description: null, images: [],)));
              },
            ),
          );
        },
      ),
    );
  }
}

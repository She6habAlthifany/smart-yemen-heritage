import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

// استدعاء صفحات التفاصيل
import '../../features/Landmarks/details/details_screen.dart';
import '../../features/Landmarks/details/details_bab_yemen.dart';
import '../Kingdoms/details/details_maeen.dart';
import '../Kingdoms/details/details_saba.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  final List<Map<String, dynamic>> allPlaces = [
    {
      'id': 'dar_alhajar',
      'name': 'دار الحجر',
      'image': 'assets/images/dar_alhajar.jpg',
      'category': 'آثار',
      'screen': const DetailsScreen(placeId: null, title: null, image: null, description: null, images: [],),
    },
    {
      'id': 'bab_yemen',
      'name': 'باب اليمن',
      'image': 'assets/images/bab_yemen.jpg',
      'category': 'آثار',
      'screen': const DetailsBabYemen(),
    },
    {
      'id': 'saba',
      'name': 'مملكة سبأ',
      'image': 'assets/images/saba.jpg',
      'category': 'ممالك',
      'screen': const DetailsSaba(),
    },
    {
      'id': 'maeen',
      'name': 'مملكة معين',
      'image': 'assets/images/maeen.jpg',
      'category': 'ممالك',
      'screen': const DetailsMaeen(),
    }
  ];

  List<Map<String, dynamic>> get results {
    if (_query.trim().isEmpty) return allPlaces;
    final q = _query.trim().toLowerCase();
    return allPlaces.where((p) {
      return p['name'].toLowerCase().contains(q) ||
          p['category'].toLowerCase().contains(q) ||
          p['id'].toLowerCase().contains(q);
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
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'ابحث...',
            hintStyle: TextStyle(color: Colors.white70),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: results.length,
        itemBuilder: (context, i) {
          final p = results[i];
          return Card(
            child: ListTile(
              leading: Image.asset(p['image'], width: 60, fit: BoxFit.cover),
              title: Text(p['name'], textAlign: TextAlign.right),
              subtitle: Text(p['category'], textAlign: TextAlign.right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => p['screen']),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

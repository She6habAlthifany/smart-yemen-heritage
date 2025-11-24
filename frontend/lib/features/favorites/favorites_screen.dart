// lib/features/favorites/favorites_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/favorites_manager.dart';
import '../schedule/details/details_screen.dart'; // أو المسار الصحيح لصفحة التفاصيل

// بيانات تجريبية — استبدلها لاحقًا بمصدر حقيقي
final List<Map<String, String>> demoPlaces = [
  {'id': 'dar_alhajar', 'name': 'دار الحجر', 'image': 'assets/images/dar_alhajar.jpg', 'location': 'وادي ظهر'},
  {'id': 'bab_yemen', 'name': 'باب اليمن', 'image': 'assets/images/bab_yemen.jpg', 'location': 'صنعاء القديمة'},
  {'id': 'saba', 'name': 'مملكة سبأ', 'image': 'assets/images/saba.jpg', 'location': 'صنعاء'},
];

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesManager fav = FavoritesManager.instance;

  List<Map<String, String>> get _favoritePlaces {
    final ids = fav.all;
    return demoPlaces.where((p) => ids.contains(p['id'])).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: fav,
        builder: (context, _) {
          final list = _favoritePlaces;
          if (list.isEmpty) {
            return Center(child: Text('لا توجد عناصر مفضلة بعد.', style: TextStyle(color: AppColors.textDark)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final p = list[i];
              return Card(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(p['image']!, width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  title: Text(p['name']!, textAlign: TextAlign.right),
                  subtitle: Text(p['location']!, textAlign: TextAlign.right),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      fav.toggle(p['id']!); // سيقوم بإعلام الشاشة وإعادة البناء
                    },
                  ),
                  onTap: () {
                    // افتح صفحة التفاصيل مع تمرير البيانات
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsScreen(
                          placeId: p['id']!,
                          title: p['name']!,
                          image: p['image']!, description: '', images: [],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

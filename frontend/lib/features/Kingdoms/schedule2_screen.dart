import 'package:flutter/material.dart';
import 'package:frontend/features/home/home_screen.dart'; // تأكد أن المسار صحيح
import 'package:frontend/features/Kingdoms/details/details_maeen.dart';
import 'package:frontend/features/Kingdoms/details/details_saba.dart';
import 'package:frontend/features/Kingdoms/details/details_sayoon.dart';

// تعريف الألوان الحديثة المستخدمة
const Color _primaryColor = Color(0xFFCD853F); // لون ترابي دافئ
const Color _backgroundColor = Colors.white; // اللون الأبيض النظيف للخلفية
const Color _lightGrey = Color(0xFFF0F0F0); // لون رمادي فاتح للخلفية

class KingdomsScreen extends StatefulWidget {
  const KingdomsScreen({super.key});

  @override
  State<KingdomsScreen> createState() => _KingdomsScreenState();
}

class _KingdomsScreenState extends State<KingdomsScreen> {
  int _selectedIndex = 1; // لأننا في صفحة الممالك (البحث)

  final List<Map<String, dynamic>> kingdoms = [
    {
      'name': 'مملكة سبأ',
      'location': 'محافظة مأرب شرق صنعاء',
      'image': 'assets/images/saba.jpg',
      'page': const DetailsSaba(),
    },
    {
      'name': 'مملكة معين',
      'location': 'وادي الجوف شمال اليمن',
      'image': 'assets/images/maeen.jpg',
      'page': const DetailsMaeen(),
    },
    {
      'name': 'قصر سيئون',
      'location': 'وادي حضرموت شرق اليمن',
      'image': 'assets/images/sayoon.jpg',
      'page': const DetailsSayoon(),
    },
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) {
      // يجب تغيير هذا ليناسب هيكل التنقل الفعلي لتطبيقك
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen(userName: '')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightGrey, // خلفية رمادية فاتحة

      // شريط التطبيق العلوي
      appBar: AppBar(
        automaticallyImplyLeading: false, // نستخدم أيقونة مخصصة للرجوع
        backgroundColor: _backgroundColor,
        elevation: 1, // ظل خفيف للفصل بين الشريط والقائمة
        title: const Text(
          "الممالك القديمة",
          style: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: _primaryColor),
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: _primaryColor),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 قسم "الممالك" و "عرض الكل"
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "الممالك",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87, // نص أسود ثقيل
                    ),
                  ),
                  GestureDetector(
                    onTap: () { /* وظيفة عرض الكل */ },
                    child: const Text(
                      "عرض الكل",
                      style: TextStyle(
                        fontSize: 14,
                        color: _primaryColor, // نص بلون الهوية
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 قائمة الممالك
            Expanded(
              child: ListView.builder(
                itemCount: kingdoms.length,
                itemBuilder: (context, index) {
                  final item = kingdoms[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => item['page']),
                      );
                    },
                    child: _buildKingdomCard(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // 🔹 شريط التنقل السفلي بتصميم عصري
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _backgroundColor,
        currentIndex: _selectedIndex,
        selectedItemColor: _primaryColor, // أيقونة مختارة باللون الترابي
        unselectedItemColor: Colors.grey.shade400, // أيقونة غير مختارة بلون رمادي فاتح
        type: BottomNavigationBarType.fixed, // تثبيت الأيقونات
        elevation: 8,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'استكشف', // تم تغيير التسمية لتكون أكثر وضوحاً
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'ملفي',
          ),
        ],
      ),
    );
  }

  // دالة بناء بطاقة المملكة بشكل أنيق
  Widget _buildKingdomCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _backgroundColor, // لون البطاقة أبيض
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryColor.withOpacity(0.2), width: 1), // حدود بلون ترابي خفيف
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // ظل ألطف
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // صورة المعلم
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // زوايا دائرية للصورة
              child: Image.asset(
                item['image'],
                width: 85,
                height: 85,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),

            // تفاصيل المملكة
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      color: Colors.black87, // نص أسود داكن
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          item['location'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // أيقونة التوجيه
            const Icon(Icons.arrow_forward_ios,
                color: _primaryColor, size: 18), // أيقونة بلون الهوية
          ],
        ),
      ),
    );
  }
}
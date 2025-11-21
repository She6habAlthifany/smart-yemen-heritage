import 'package:flutter/material.dart';
import 'package:yemen_old_history/features/home/home_screen.dart'; // تأكد أن المسار صحيح
import 'package:yemen_old_history/features/schedule2/details/details_maeen.dart';
import 'package:yemen_old_history/features/schedule2/details/details_saba.dart';
import 'package:yemen_old_history/features/schedule2/details/details_sayoon.dart';

class Schedule2Screen extends StatefulWidget {
  const Schedule2Screen({super.key});

  @override
  State<Schedule2Screen> createState() => _Schedule2ScreenState();
}

class _Schedule2ScreenState extends State<Schedule2Screen> {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBE9D0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 الشريط العلوي
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.brown),
                  ),
                  const Icon(Icons.notifications_none, color: Colors.brown),
                ],
              ),
              const SizedBox(height: 10),

              // 🔹 العنوان
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "الممالك",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  Text(
                    "عرض الكل",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

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
                                child: Image.asset(
                                  item['image'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            color: Colors.white, size: 16),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            item['location'],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
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
                ),
              ),
            ],
          ),
        ),
      ),

      // 🔹 شريط التنقل السفلي مع التنقل الفعلي
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.brown[200],
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الصفحة الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الملف الشخصي',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/features/home/home_screen.dart';
import 'details/details_screen.dart';
import 'details/details_bab_yemen.dart';
import 'details/details_hadramout.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedIndex = 1;

  // 🏛️ قائمة المعالم
  final List<Map<String, dynamic>> landmarks = [
    {
      'placeId': '1',
      'name': 'دار الحجر',
      'location': 'وادي ظهر شمال غرب صنعاء',
      'image': 'assets/images/dar_alhajar.jpg',
      'description': 'يقع دار الحجر في وادي ظهر شمال غرب صنعاء، وهو من أهم المعالم التاريخية...',
      'images': [
        'assets/images/dar_alhajar1.jpg',
        'assets/images/dar_alhajar2.jpg',
        'assets/images/dar_alhajar3.jpg',
      ],
    },
    {
      'placeId': '2',
      'name': 'باب اليمن',
      'location': 'صنعاء القديمة - محافظة صنعاء',
      'image': 'assets/images/bab_yemen.jpg',
      'description': 'باب اليمن من أشهر معالم صنعاء القديمة...',
      'images': [
        'assets/images/bab_yemen1.jpg',
        'assets/images/bab_yemen2.jpg',
      ],
    },
    {
      'placeId': '3',
      'name': 'شبام حضرموت',
      'location': 'وادي حضرموت شرق اليمن',
      'image': 'assets/images/hadramout.jpg',
      'description': 'شبام حضرموت مدينة تاريخية تُسمى منهاتن الصحراء...',
      'images': [
        'assets/images/hadramout1.jpg',
        'assets/images/hadramout2.jpg',
      ],
    }
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen(userName: '',)),
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
                    "المعالم التاريخية",
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

              // 🔹 قائمة المعالم
              Expanded(
                child: ListView.builder(
                  itemCount: landmarks.length,
                  itemBuilder: (context, index) {
                    final item = landmarks[index];

                    return GestureDetector(
                      onTap: () {
                        // 🟢 تحديد الصفحة حسب placeId
                        if (item['placeId'] == '1') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailsScreen(
                                placeId: item['placeId'],
                                title: item['name'],
                                image: item['image'],
                                description: item['description'],
                                images: List<String>.from(item['images']),
                              ),
                            ),
                          );
                        } else if (item['placeId'] == '2') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DetailsBabYemen()),
                          );
                        } else if (item['placeId'] == '3') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DetailsHadramout()),
                          );
                        }
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
                ),
              ),
            ],
          ),
        ),
      ),

      // 🔹 شريط التنقل السفلي
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

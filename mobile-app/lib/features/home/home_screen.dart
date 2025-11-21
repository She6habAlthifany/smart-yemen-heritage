import 'package:flutter/material.dart';
import 'package:yemen_old_history/features/assistant/smart_assistant_screen.dart';
import 'package:yemen_old_history/features/schedule2/schedule2_screen.dart';
import '../../core/constants/app_colors.dart';
import '../schedule/schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<String> categories = ["الكل", "آثار", "ممالك", "معالم"];

  void _onNavItemTapped(int index) {
    setState(() => _selectedIndex = index);

    // التنقل بين الصفحات السفلية
    switch (index) {
      case 0:
      // الصفحة الرئيسية
        break;
      case 1:
      // المساعد الذكي
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SmartAssistantScreen()),
        );
        break;
      case 2:
      // المفضلة (لاحقاً)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('قريباً سيتم إضافة صفحة المفضلة ❤️')),
        );
        break;
      case 3:
      // الملف الشخصي (لاحقاً)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('قريباً سيتم إضافة صفحة الملف الشخصي 👤')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // صورة المستخدم + الاسم
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage("assets/images/user.png"),
                ),
                const SizedBox(width: 8),
                Text(
                  "Shehab",
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            // أيقونة الإشعارات
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.notifications, color: AppColors.primary),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // مربع البحث
            TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: "ابحث عن المعالم الأثرية والتاريخية",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // التصنيفات
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final selected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });

                      // عند الضغط على "معالم" أو "ممالك" يتم الانتقال
                      if (categories[index] == "معالم") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ScheduleScreen()),
                        );
                      } else if (categories[index] == "ممالك") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Schedule2Screen()),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: selected ? Colors.white : AppColors.textDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            // شبكة المعالم
            Expanded(
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // عند الضغط على أي كارت يذهب لصفحة المعالم
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ScheduleScreen()),
                      );
                    },
                    child: _placeCard(
                      image: "assets/images/place${index % 2 + 1}.jpg",
                      title: index % 2 == 0 ? "باب اليمن" : "دار الحجر",
                      location: index % 2 == 0 ? "صنعاء القديمة" : "وادي ظهر",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // شريط التنقل السفلي
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textDark.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: "المساعد الذكي"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "المفضلة"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "الملف الشخصي"),
        ],
      ),
    );
  }

  // بطاقة المعلم
  Widget _placeCard({
    required String image,
    required String title,
    required String location,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              image,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(
                    color: AppColors.textDark.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    "عرض بالواقع المعزز",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

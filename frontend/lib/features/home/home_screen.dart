import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/features/assistant/smart_assistant_screen.dart';
import 'package:frontend/features/Kingdoms/schedule2_screen.dart';
import 'package:frontend/features/landmarks/schedule_screen.dart';
import '../../core/constants/app_colors.dart';
import '../Antiquities/AntiquitiesScreen.dart';
import '../search/search_screen.dart';
import '../../models/content_model.dart';
import '../../services/content_service.dart';
import '../Landmarks/details/content_details_screen.dart'; // صفحة التفاصيل الجديدة

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  int _selectedCategoryIndex = 0;

  final List<String> categories = ["الكل", "آثار", "ممالك", "معالم"];

  // هذه القائمة تستخدم فقط للعرض، لا تعتمد عليها لبيانات التفاصيل
  List<Map<String, String>> allPlaces = [
    {"title": "باب اليمن", "location": "صنعاء القديمة", "image": "assets/images/bab_yemen1.jpg"},
    {"title": "دار الحجر", "location": "وادي ظهر", "image": "assets/images/place2.jpg"},
    {"title": "شبام حضرموت", "location": "حضرموت", "image": "assets/images/place1.jpg"}, // تم تعديل العنوان
    {"title": "جبل صبر", "location": "محافظة تعز", "image": "assets/images/place2.jpg"}, // تم تعديل العنوان
  ];


  List<Map<String, String>> filteredPlaces = [];
  final List<String> sliderImages = [
    "assets/images/place1.jpg",
    "assets/images/bab_yemen1.jpg",
    "assets/images/place2.jpg",
  ];

  int _currentPage = 0;
  static const Color _cardColor = Color(0xFFFBF8F0);

  @override
  void initState() {
    super.initState();
    filteredPlaces = List.from(allPlaces);
  }

  void _onNavItemTapped(int index) {
    if (index == 0) {
      setState(() => _selectedNavIndex = 0);
      return;
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SmartAssistantScreen()),
      );
      return;
    }

    if (index == 2) {
      Navigator.pushNamed(context, '/favorites');
      return;
    }

    if (index == 3) {
      Navigator.pushNamed(context, '/profile');
      return;
    }
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });

    final categoryName = categories[index];

    if (categoryName == "معالم") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LandmarksScreen()),
      );
    } else if (categoryName == "ممالك") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const KingdomsScreen()),
      );
    } else if (categoryName == "آثار") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AntiquitiesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '𐩱𐩡𐩣𐩬',
                style: const TextStyle(
                  fontFamily: 'OldSouthArabian',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4A017),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'الموسوعة الذكية في تاريخ اليمن القديم',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const SearchScreen(),
                    );
                  },
                ),
              ),
              const SizedBox(width: 4),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.language, color: Colors.black),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: IndexedStack(
        index: _selectedNavIndex,
        children: [
          _buildHomePageContent(),
          const Center(child: Text("المساعد الذكي")),
          const Center(child: Text("المفضلة")),
          const Center(child: Text("الملف الشخصي")),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        currentIndex: _selectedNavIndex,
        onTap: _onNavItemTapped,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: AppColors.textDark.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: "المساعد الذكي"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "المفضلة"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "الملف الشخصي"),
        ],
      ),
    );
  }

  Widget _buildHomePageContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _imageSlider(),
          const SizedBox(height: 20),

          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final selected = _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () => _onCategorySelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
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

          SizedBox(
            height: (filteredPlaces.length / 2).ceil() * 260.0,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredPlaces.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                final place = filteredPlaces[index];
                return GestureDetector(
                  onTap: () async {
                    try {
                      List<Content> allContents = await ContentService.fetchContents();
                      Content? selectedContent = allContents.firstWhere(
                            (content) => content.title == place['title'],
                        orElse: () => throw Exception("المحتوى غير موجود"),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ContentDetailsScreen(contentId: selectedContent.id),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("حدث خطأ أثناء جلب المحتوى: $e")),
                      );
                    }
                  },
                  child: _placeCard(
                    image: place['image']!,
                    title: place['title']!,
                    location: place['location']!,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // بقية وظائف السلايدر والكارد تبقى كما هي
  Widget _imageSlider() {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            itemCount: sliderImages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return _sliderImageCard(
                imagePath: sliderImages[index],
                isArtifact: index == 0,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            sliderImages.length,
                (index) => _dot(isCurrent: _currentPage == index),
          ),
        ),
      ],
    );
  }

  Widget _sliderImageCard({required String imagePath, required bool isArtifact}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              imagePath,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _dot({required bool isCurrent}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 6,
      width: isCurrent ? 25 : 6,
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.primary : Colors.grey[400],
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _placeCard({
    required String image,
    required String title,
    required String location,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
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
                Text(title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(location,
                    style: TextStyle(color: AppColors.textDark.withOpacity(0.6), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

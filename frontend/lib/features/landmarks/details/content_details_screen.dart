import 'package:flutter/material.dart';
import '../../../models/content_details_model.dart';
import '../../../services/content_details_service.dart';
import '../../ar/ar_view_screen.dart';
import '../../assistant/smart_assistant_screen.dart';

// تعريف الألوان المستخدمة لضمان التناسق
// تم تغيير الألوان لتناسب تصميم الواجهة الرئيسية (الذهبي/الأبيض)
const Color _primaryColor = Color(0xFFD4A017); // اللون الذهبي/الكهرماني (AppColors.primary)
const Color _backgroundColor = Colors.white; // لون الخلفية الأبيض

class ContentDetailsScreen extends StatefulWidget {
  final String contentId;

  const ContentDetailsScreen({super.key, required this.contentId});

  @override
  State<ContentDetailsScreen> createState() => _ContentDetailsScreenState();
}

class _ContentDetailsScreenState extends State<ContentDetailsScreen> {
  late Future<List<ContentDetails>> _detailsFuture;
  bool _isBookmarked = false;
  int _currentImageIndex = 0;

  // صور افتراضية في حال لم يوجد صور
  final List<String> defaultImages = [
    'assets/images/dar_alhajar1.jpg',
    'assets/images/dar_alhajar2.jpg',
    'assets/images/dar_alhajar3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _detailsFuture = ContentDetailsService.fetchContentDetails(widget.contentId);
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? 'تم الحفظ في المفضلة' : 'تم إزالة الحفظ من المفضلة'),
        duration: const Duration(seconds: 2),
        backgroundColor: _primaryColor,
      ),
    );
  }

  void _navigateToAR() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ARViewScreen()),
    );
  }

  void _showSmartAssistantPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.all(20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: _primaryColor, // اللون الأساسي الجديد
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'المساعد الذكي',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
                const Expanded(
                  child: SmartAssistantScreen(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: FutureBuilder<List<ContentDetails>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: _primaryColor));
          } else if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ: ${snapshot.error}", style: const TextStyle(color: _primaryColor)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("لا توجد تفاصيل لهذا المعلم", style: TextStyle(color: _primaryColor)));
          }

          final item = snapshot.data!.first;
          final List<String> images = (item.imageUrl != null && item.imageUrl!.isNotEmpty)
              ? [item.imageUrl!]
              : defaultImages;

          return Stack(
            children: [
              // 1. المحتوى القابل للتمرير (CustomScrollView)
              CustomScrollView(
                slivers: [
                  // شريط التطبيق المرن (SliverAppBar)
                  SliverAppBar(
                    expandedHeight: screenHeight * 0.55,
                    pinned: true,
                    backgroundColor: _backgroundColor,
                    leading: _buildCircleIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                    actions: [
                      _buildCircleIconButton(
                        icon: Icons.share,
                        onPressed: () { /* وظيفة المشاركة */ },
                      ),
                      _buildCircleIconButton(
                        icon: _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        onPressed: _toggleBookmark,
                        iconColor: _isBookmarked ? _primaryColor : Colors.white,
                        backgroundColor: _isBookmarked ? Colors.white : Colors.black45, // تغيير بسيط للحفظ
                      ),
                      SizedBox(width: 8),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: _buildImageGallery(images, screenHeight),
                    ),
                  ),

                  // 2. المحتوى الثابت (SliverToBoxAdapter)
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: _backgroundColor,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                          // إضافة ظل خفيف عند التمرير
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 15,
                                offset: Offset(0, -5)
                            )
                          ]
                      ),
                      padding: EdgeInsets.fromLTRB(20, 30, 20, screenHeight * 0.15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderSection(item.title, item.imageUrl ?? defaultImages[0]),
                          const SizedBox(height: 15),

                          _buildSmallImageGallery(images),
                          const SizedBox(height: 30),

                          _buildAboutSection(item.description),
                          const SizedBox(height: 30),

                          _buildInteractionButtons(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 3. الأزرار السفلية الثابتة (Sticky Bottom Actions)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: const Offset(0, -4),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        // زر الواقع المعزز (AR Button)
                        Expanded(
                          flex: 3,
                          child: ElevatedButton.icon(
                            onPressed: _navigateToAR,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                            ),
                            icon: const Icon(Icons.view_in_ar, size: 24),
                            label: const Text('المشاهدة بالواقع المعزز', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // زر المساعد الذكي (Assistant Button)
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () => _showSmartAssistantPopup(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _primaryColor,
                              side: const BorderSide(color: _primaryColor, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Icon(Icons.record_voice_over, size: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ===========================================
  // ============= WIDGET BUILDERS =============
  // ===========================================

  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color iconColor = Colors.white,
    Color backgroundColor = Colors.black45, // لون خلفية الأزرار العلوية
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: 24),
        onPressed: onPressed,
      ),
    );
  }

  // ... (باقي دوال بناء ال Widgets كما هي، مع تطبيق _primaryColor)
  Widget _buildImageGallery(List<String> images, double screenHeight) {
    return Image.network(
      images[0],
      width: double.infinity,
      height: screenHeight * 0.55,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator(color: _primaryColor));
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          defaultImages[0],
          fit: BoxFit.cover,
          width: double.infinity,
          height: screenHeight * 0.55,
        );
      },
    );
  }

  Widget _buildHeaderSection(String title, String imageUrl) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 28,
          child: ClipOval(
            child: Image.network(
              imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                defaultImages[0],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 26, color: _primaryColor, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallImageGallery(List<String> images) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          final isAsset = images[index].startsWith('assets');
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: isAsset
                  ? Image.asset(images[index], width: 70, height: 70, fit: BoxFit.cover)
                  : Image.network(
                images[index],
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  defaultImages[index % defaultImages.length],
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAboutSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.info_outline, color: _primaryColor, size: 24),
            SizedBox(width: 8),
            Text('عن المعلم', style: TextStyle(fontSize: 20, color: _primaryColor, fontWeight: FontWeight.bold)),
          ],
        ),
        const Divider(color: _primaryColor, thickness: 0.5),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildInteractionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildIconWithText(
          icon: Icons.comment_outlined,
          text: 'التعليقات (0)',
          onPressed: () {},
        ),
        _buildIconWithText(
          icon: Icons.star_border,
          text: 'أضف تقييمك',
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildIconWithText({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: _primaryColor, size: 30),
        ),
        Text(text, style: const TextStyle(color: _primaryColor, fontSize: 13)),
      ],
    );
  }
}
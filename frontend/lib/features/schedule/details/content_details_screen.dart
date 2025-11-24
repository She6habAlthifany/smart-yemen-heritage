import 'package:flutter/material.dart';
import '../../../models/content_details_model.dart';
import '../../../services/content_details_service.dart';
// import '../../models/content_details_model.dart';
// import '../../services/content_details_service.dart';
import '../../ar/ar_view_screen.dart';
import '../../assistant/smart_assistant_screen.dart';

class ContentDetailsScreen extends StatefulWidget {
  final String contentId;

  const ContentDetailsScreen({super.key, required this.contentId});

  @override
  State<ContentDetailsScreen> createState() => _ContentDetailsScreenState();
}

class _ContentDetailsScreenState extends State<ContentDetailsScreen> {
  late Future<List<ContentDetails>> _detailsFuture;

  // قائمة صور افتراضية لكل محتوى (يمكن تعديلها لاحقًا)
  final List<String> defaultImages = [
    'assets/images/dar_alhajar1.jpg',
    'assets/images/dar_alhajar2.jpg',
    'assets/images/dar_alhajar3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _detailsFuture =
        ContentDetailsService.fetchContentDetails(widget.contentId);
  }

  void _showSmartAssistantPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 500,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5E3C),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'المساعد الذكي',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
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
    return Scaffold(
      backgroundColor: const Color(0xFFFBE9D0),
      body: FutureBuilder<List<ContentDetails>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("لا توجد تفاصيل لهذا المعلم"));
          }

          final details = snapshot.data!;
          final item = details[0]; // عادة يكون عنصر واحد لكل contentId

          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      defaultImages[0], // صورة كبيرة في الأعلى (يمكن تعديلها لاحقًا)
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300,
                    ),
                    Positioned(
                      top: 40,
                      left: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),

                // محتوى الصفحة
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBE9D0),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(defaultImages[0]),
                            radius: 25,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.favorite_border, color: Colors.brown[300]),
                        ],
                      ),
                      const SizedBox(height: 10),

                      const Text('المشاهدة بالواقع المعزز',
                          style: TextStyle(color: Colors.brown, fontSize: 14)),
                      const SizedBox(height: 15),

                      SizedBox(
                        height: 70,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (var img in defaultImages)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    img,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: const [
                          Icon(Icons.info, color: Colors.brown),
                          SizedBox(width: 5),
                          Text(
                            'عن المعلم',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Text(
                        item.description,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.brown, height: 1.6),
                      ),
                      const SizedBox(height: 25),

                      // الأزرار السفليّة
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // 🧠 المساعد الذكي
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _showSmartAssistantPopup(context);
                                },
                                icon: const Icon(Icons.record_voice_over,
                                    color: Colors.brown, size: 30),
                              ),
                              const Text('المساعد الذكي',
                                  style: TextStyle(color: Colors.brown, fontSize: 13)),
                            ],
                          ),

                          // 🕶 الواقع المعزز
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const ARViewScreen()),
                                  );
                                },
                                icon: const Icon(Icons.vrpano_outlined,
                                    color: Colors.brown, size: 30),
                              ),
                              const Text('الواقع المعزز',
                                  style: TextStyle(color: Colors.brown, fontSize: 13)),
                            ],
                          ),

                          // 💬 إضافة تعليق
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    builder: (context) => Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            "إضافة تعليق",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            textAlign: TextAlign.right,
                                            decoration: const InputDecoration(
                                              hintText: "اكتب تعليقك هنا...",
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.brown,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("إرسال"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.comment,
                                    color: Colors.brown, size: 30),
                              ),
                              const Text('إضافة تعليق',
                                  style: TextStyle(color: Colors.brown, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

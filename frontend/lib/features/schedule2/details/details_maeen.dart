import 'package:flutter/material.dart';
import 'package:frontend/features/ar/ar_view_screen.dart';
import 'package:frontend/features/assistant/smart_assistant_screen.dart';

class DetailsMaeen extends StatelessWidget {
  const DetailsMaeen({super.key});
  void _showSmartAssistantPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // يمكن إغلاقه بالضغط خارج النافذة
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
                // العنوان وشريط الإغلاق
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5E3C),
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 الصورة الرئيسية مع أزرار الرجوع والمفضلة
            Stack(
              children: [
                Image.asset(
                  'assets/images/maeen.jpg',
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

            // 🔹 المحتوى الداخلي
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
                  // 🔹 العنوان والصورة الصغيرة
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/maeen.jpg'),
                        radius: 25,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'مملكة معين',
                        style: TextStyle(
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

                  // 🔹 صور إضافية
                  SizedBox(
                    height: 70,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var img in [
                          'assets/images/maeen1.jpg',
                          'assets/images/maeen2.jpg',
                          'assets/images/maeen3.jpg'
                        ])
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(img, width: 70, height: 70, fit: BoxFit.cover),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 عنوان القسم
                  Row(
                    children: const [
                      Icon(Icons.info, color: Colors.brown),
                      SizedBox(width: 5),
                      Text(
                        'عن مملكة معين',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 🔹 الوصف
                  const Text(
                    'مملكة معين كانت من أقدم الممالك اليمنية القديمة، وازدهرت بين القرنين الخامس والعاشر قبل الميلاد. '
                        'كانت عاصمتها قرناو (موقعها الحالي الجوف)، وامتازت بتطورها التجاري والإداري، '
                        'حيث كانت مركزاً للتجارة بين جنوب الجزيرة العربية وبلاد الشام. '
                        'اشتهرت بتدوين النقوش بخط المسند وتعتبر من أهم الحضارات اليمنية القديمة.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.brown, height: 1.6),
                  ),

                  const SizedBox(height: 25),

                  // 🔹 الأزرار التفاعلية السفلية
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              _showSmartAssistantPopup(context);
                            },
                            icon: const Icon(Icons.record_voice_over, color: Colors.brown, size: 30),
                          ),
                          const Text('المساعد الذكي',
                              style: TextStyle(color: Colors.brown, fontSize: 13)),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ARViewScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.vrpano_outlined, color: Colors.brown, size: 30),
                          ),
                          const Text('الواقع المعزز',
                              style: TextStyle(color: Colors.brown, fontSize: 13)),
                        ],
                      ),
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
                            icon: const Icon(Icons.comment, color: Colors.brown, size: 30),
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
      ),
    );
  }
}

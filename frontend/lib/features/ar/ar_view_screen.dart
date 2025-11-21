import 'package:flutter/material.dart';

class ARViewScreen extends StatelessWidget {
  const ARViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBE9D0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBE9D0),
        elevation: 0,
        title: const Text(
          'المشاهدة بالواقع المعزز',
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.brown),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.vrpano_outlined, size: 100, color: Colors.brown),
            const SizedBox(height: 20),
            const Text(
              'سيتم عرض المعلم في الواقع المعزز هنا 🔍',
              style: TextStyle(color: Colors.brown, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ميزة الواقع المعزز قيد التطوير ✨')),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('بدء التجربة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

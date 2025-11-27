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
















// import 'package:flutter/material.dart';
// import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
// import 'package:ar_flutter_plugin/models/ar_node.dart';
// import 'package:ar_flutter_plugin/models/ar_anchor.dart';
//
// class ARViewScreen extends StatefulWidget {
//   const ARViewScreen({super.key});
//
//   @override
//   State<ARViewScreen> createState() => _ARViewScreenState();
// }
//
// class _ARViewScreenState extends State<ARViewScreen> {
//   ARSessionManager? arSessionManager;
//   ARObjectManager? arObjectManager;
//   ARNode? modelNode;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFBE9D0),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFBE9D0),
//         elevation: 0,
//         title: const Text(
//           'المشاهدة بالواقع المعزز',
//           style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.brown),
//       ),
//       body: ARView(
//         onARViewCreated: onARViewCreated,
//         planeDetectionConfig: PlaneDetectionConfig.horizontal,
//       ),
//     );
//   }
//
//   /// يتم استدعاؤها عند إنشاء واجهة AR
//   void onARViewCreated(ARSessionManager sessionManager, ARObjectManager objectManager) {
//     arSessionManager = sessionManager;
//     arObjectManager = objectManager;
//
//     // إعداد الجلسة
//     arSessionManager!.onInitialize(
//       showFeaturePoints: false,
//       showPlanes: true,
//       showWorldOrigin: false,
//       handleTaps: true, // لتفعيل onPlaneOrPointTap
//     );
//
//     arObjectManager!.onInitialize();
//
//     // إضافة الموديل عند الضغط على سطح
//     arSessionManager!.onPlaneOrPointTap = onPlaneTapped;
//   }
//
//   /// عند الضغط على سطح في الواقع
//   Future<void> onPlaneTapped(List<ARHitTestResult> hitTestResults) async {
//     if (hitTestResults.isEmpty) return;
//
//     final hit = hitTestResults.first;
//
//     // إنشاء Anchor
//     var newAnchor = ARPlaneAnchor(
//       transformation: hit.worldTransform,
//     );
//
//     bool? didAddAnchor = await arObjectManager!.addAnchor(newAnchor);
//
//     if (didAddAnchor == true) {
//       // إنشاء Node 3D
//       var newNode = ARNode(
//         type: NodeType.localGLTF2,
//         uri: "assets/models/object.glb",
//         scale: Vector3(0.5, 0.5, 0.5),
//       );
//
//       bool? nodeAdded = await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
//
//       if (nodeAdded == true) {
//         modelNode = newNode;
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     arSessionManager?.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'مستخدم';
  String _email = 'example@mail.com';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('user_name') ?? 'مستخدم';
      _email = prefs.getString('user_email') ?? 'example@mail.com';
    });
  }

  Future<void> _save(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    _load();
  }

  void _openEdit() {
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('تعديل الملف الشخصي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(controller: nameController, textAlign: TextAlign.right, decoration: const InputDecoration(labelText: 'الاسم')),
            const SizedBox(height: 8),
            TextField(controller: emailController, textAlign: TextAlign.right, decoration: const InputDecoration(labelText: 'البريد الإلكتروني')),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () {
                  _save(nameController.text.trim(), emailController.text.trim());
                  Navigator.pop(context);
                },
                child: const Text('حفظ'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Text('الإعدادات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          SwitchListTile(
            value: true,
            title: const Text('إعلامات'),
            onChanged: (v) {
              // احفظ الإعدادات لو أردت
              Navigator.pop(context);
            },
            secondary: const Icon(Icons.notifications),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل الخروج'),
            onTap: () {
              // عملية تسجيل الخروج المؤقتة
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الخروج (محاكاة)')));
              Navigator.pop(context);
            },
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('الملف الشخصي'), backgroundColor: AppColors.primary, centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Row(children: [
            CircleAvatar(radius: 30, backgroundImage: const AssetImage('assets/images/user.png')),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(_name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text(_email, style: const TextStyle(color: Colors.grey)),
            ])
          ]),
          const SizedBox(height: 20),
          ElevatedButton.icon(onPressed: _openEdit, icon: const Icon(Icons.edit), label: const Text('تعديل الملف الشخصي')),
          const SizedBox(height: 10),
          ElevatedButton.icon(onPressed: _openSettings, icon: const Icon(Icons.settings), label: const Text('الإعدادات')),
        ]),
      ),
    );
  }
}

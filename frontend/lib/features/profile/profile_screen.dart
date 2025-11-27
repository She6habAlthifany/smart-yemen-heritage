import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../../core/providers/settings_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = "مستخدم";
  String _email = "example@mail.com";
  String _phone = "غير محدد";
  String _country = "اليمن";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("user_name") ?? "مستخدم";
      _email = prefs.getString("user_email") ?? "example@mail.com";
      _phone = prefs.getString("user_phone") ?? "غير محدد";
      _country = prefs.getString("user_country") ?? "اليمن";
    });
  }

  Future<void> _saveUserData(String name, String email, {String? phone, String? country}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_name", name);
    await prefs.setString("user_email", email);
    if (phone != null) await prefs.setString("user_phone", phone);
    if (country != null) await prefs.setString("user_country", country);
    _loadUserData();
  }

  void _editProfile() {
    final nameCtrl = TextEditingController(text: _name);
    final emailCtrl = TextEditingController(text: _email);
    final phoneCtrl = TextEditingController(text: _phone);
    final countryCtrl = TextEditingController(text: _country);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "تعديل الملف الشخصي",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameCtrl,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(labelText: "الاسم"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailCtrl,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(labelText: "البريد الإلكتروني"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneCtrl,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(labelText: "رقم الهاتف"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: countryCtrl,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(labelText: "الدولة"),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () {
                  _saveUserData(
                    nameCtrl.text.trim().isEmpty ? _name : nameCtrl.text.trim(),
                    emailCtrl.text.trim().isEmpty ? _email : emailCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    country: countryCtrl.text.trim(),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text("تم تحديث الملف الشخصي")),
                  );
                },
                child: const Text("حفظ"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: AppColors.primary),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsButton({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      trailing: Icon(icon, color: AppColors.primary),
      title: Text(title, textAlign: TextAlign.right),
      onTap: onTap,
    );
  }

  // ---------- Settings Bottom Sheet (advanced) ----------
  void _openSettingsSheet() {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.brown.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('الإعدادات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  IconButton(icon: Icon(Icons.close, color: AppColors.textDark), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 6),

              // Dark mode switch (uses SettingsProvider)
              Consumer<SettingsProvider>(
                builder: (context, provider, _) {
                  final isDark = provider.isDarkMode;
                  return SwitchListTile(
                    value: isDark,
                    onChanged: (v) async {
                      await provider.setDarkMode(v);
                    },
                    title: const Text('الوضع الليلي', textAlign: TextAlign.right),
                    secondary: const Icon(Icons.dark_mode),
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),

              // Language selector
              ListTile(
                trailing: const Icon(Icons.language),
                title: const Text('اللغة', textAlign: TextAlign.right),
                subtitle: Consumer<SettingsProvider>(
                  builder: (context, provider, _) {
                    return Text(provider.locale.languageCode == 'ar' ? 'العربية' : 'English', textAlign: TextAlign.right);
                  },
                ),
                onTap: () => _showLanguagePicker(ctx),
              ),

              // About
              ListTile(
                trailing: const Icon(Icons.info_outline),
                title: const Text('عن التطبيق', textAlign: TextAlign.right),
                onTap: () {
                  Navigator.pop(ctx);
                  _showAboutDialog();
                },
              ),

              // Privacy / placeholder
              ListTile(
                trailing: const Icon(Icons.privacy_tip_outlined),
                title: const Text('سياسة الخصوصية', textAlign: TextAlign.right),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('صفحة سياسة الخصوصية غير مفعلة')));
                },
              ),

              // Clear app data
              ListTile(
                trailing: const Icon(Icons.delete_forever, color: Colors.redAccent),
                title: const Text('محو بيانات التطبيق', textAlign: TextAlign.right, style: TextStyle(color: Colors.redAccent)),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('تأكيد'),
                      content: const Text('هل تريد مسح بيانات التطبيق؟ سيتم حذف الإعدادات وبيانات المستخدم المخزنة.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('إلغاء')),
                        TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('محو', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    // أعد تحميل الإعدادات من الـ provider
                    if (settingsProvider is SettingsProvider) {
                      await settingsProvider.loadSettings();
                    }
                    if (mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم مسح بيانات التطبيق')));
                      setState(() {
                        _name = "مستخدم";
                        _email = "example@mail.com";
                        _phone = "غير محدد";
                        _country = "اليمن";
                      });
                    }
                  }
                },
              ),

              // Logout
              ListTile(
                trailing: const Icon(Icons.logout),
                title: const Text('تسجيل الخروج', textAlign: TextAlign.right),
                onTap: () async {
                  // محاكاة تسجيل خروج: حذف توكن من SharedPreferences ثم التنقل لشاشة الدخول
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('token');
                  if (mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الخروج')));
                    // عدّل هذا المسار حسب مشروعك (مثلاً '/login')
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),

              const SizedBox(height: 18),
            ],
          ),
        );
      },
    );
  }

  // language picker dialog
  void _showLanguagePicker(BuildContext ctx) {
    final settings = Provider.of<SettingsProvider>(ctx, listen: false);
    showDialog(
      context: ctx,
      builder: (dCtx) {
        return AlertDialog(
          title: const Text('اختر اللغة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                value: 'ar',
                groupValue: settings.locale.languageCode,
                title: const Text('العربية'),
                onChanged: (v) async {
                  if (v == null) return;
                  await settings.setLocale(const Locale('ar'));
                  if (mounted) Navigator.pop(dCtx);
                },
              ),
              RadioListTile<String>(
                value: 'en',
                groupValue: settings.locale.languageCode,
                title: const Text('English'),
                onChanged: (v) async {
                  if (v == null) return;
                  await settings.setLocale(const Locale('en'));
                  if (mounted) Navigator.pop(dCtx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Yemen Heritage',
      applicationVersion: '1.0.0',
      applicationIcon: CircleAvatar(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.account_balance, color: Colors.white),
      ),
      children: const [
        SizedBox(height: 8),
        Text('تطبيق لحفظ واستعراض التراث اليمني: آثار، ممالك ومواقع تاريخية.\nيدعم المفضلة والواقع المعزز والمساعد الذكي.'),
        SizedBox(height: 8),
        Text('البريد: info@yemenheritage.example'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use provider to display theme/lang related info if desired
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("الملف الشخصي"),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'الإعدادات',
            onPressed: _openSettingsSheet,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // user header
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      border: Border.all(color: AppColors.primary, width: 3),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
                    ),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundImage: const AssetImage("assets/images/user.png"),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(_name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(_email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _editProfile,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('تعديل الملف الشخصي'),
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // info cards
            _buildCard(icon: Icons.person, title: "الاسم", subtitle: _name),
            const SizedBox(height: 12),
            _buildCard(icon: Icons.email, title: "البريد الإلكتروني", subtitle: _email),
            const SizedBox(height: 12),
            _buildCard(icon: Icons.phone, title: "رقم الهاتف", subtitle: _phone),
            const SizedBox(height: 12),
            _buildCard(icon: Icons.location_on, title: "الدولة", subtitle: _country),

            const SizedBox(height: 22),

            // settings section
            Align(
              alignment: Alignment.centerRight,
              child: Text("الإعدادات العامة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ),
            const SizedBox(height: 10),

            // quick settings tiles
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  SwitchListTile(
                    value: settings.isDarkMode,
                    onChanged: (v) async {
                      await settings.setDarkMode(v);
                    },
                    title: const Text('الوضع الليلي'),
                    secondary: const Icon(Icons.dark_mode),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  ListTile(
                    trailing: const Icon(Icons.language),
                    title: const Text('اللغة', textAlign: TextAlign.right),
                    subtitle: Text(settings.locale.languageCode == 'ar' ? 'العربية' : 'English', textAlign: TextAlign.right),
                    onTap: () => _showLanguagePicker(context),
                  ),
                  ListTile(
                    trailing: const Icon(Icons.info_outline),
                    title: const Text('عن التطبيق', textAlign: TextAlign.right),
                    onTap: _showAboutDialog,
                  ),
                  ListTile(
                    trailing: const Icon(Icons.logout),
                    title: const Text('تسجيل الخروج', textAlign: TextAlign.right),
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('token');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الخروج')));
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

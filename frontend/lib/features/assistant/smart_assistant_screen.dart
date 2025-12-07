import 'package:flutter/material.dart';
import 'package:frontend/widgets/smart_assistant_wrapper.dart';
import '../../core/constants/app_colors.dart';

class SmartAssistantScreen extends StatefulWidget {
  const SmartAssistantScreen({super.key});

  @override
  State<SmartAssistantScreen> createState() => _SmartAssistantScreenState();
}

class _SmartAssistantScreenState extends State<SmartAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.insert(0, {'sender': 'user', 'text': _controller.text.trim()});
      _messages.insert(0, {
        'sender': 'bot',
        'text': 'سأقوم بمساعدتك في هذا الأمر قريباً إن شاء الله 🤖'
      });
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartAssistantWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('المساعد الذكي'),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [

            /// ================== الرسائل ==================
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message['sender'] == 'user';

                  return Align(
                    alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 14),
                      constraints:
                      BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: isUser
                            ? AppColors.primary
                            : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          )
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(isUser ? 18 : 0),
                          bottomRight: Radius.circular(isUser ? 0 : 18),
                        ),
                      ),
                      child: Text(
                        message['text']!,
                        textAlign: isUser ? TextAlign.right : TextAlign.left,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.brown,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            /// ================== شريط الإدخال ==================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [

                  /// 🎤 ميكروفون (للمستقبل)
                  IconButton(
                    icon: Icon(Icons.mic,
                        color: AppColors.primary, size: 26),
                    onPressed: () {},
                  ),

                  /// ✍️ حقل الكتابة
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'اسأل عن معلم أو مملكة...',
                        hintStyle:
                        TextStyle(color: Colors.grey.shade600),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 6),

                  /// 📤 زر الإرسال
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      icon: const Icon(Icons.send,
                          color: Colors.white, size: 20),
                      onPressed: _sendMessage,
                    ),
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

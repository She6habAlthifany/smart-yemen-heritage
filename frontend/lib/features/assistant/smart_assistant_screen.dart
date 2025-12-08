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
      _messages.add({'sender': 'user', 'text': _controller.text.trim()});
      _messages.add({
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
      ),
      body: Column(
        children: [
          // منطقة الرسائل
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                final isUser = message['sender'] == 'user';

                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.primary.withOpacity(0.9)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 0),
                        bottomRight: Radius.circular(isUser ? 0 : 16),
                      ),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : AppColors.textDark,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // شريط الكتابة وإرسال الرسائل
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.mic, color: AppColors.primary, size: 28),
                  onPressed: () {
                    // 🔊 لاحقاً: إضافة ميزة التحدث الصوتي
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'اكتب سؤالك هنا...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: AppColors.primary),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

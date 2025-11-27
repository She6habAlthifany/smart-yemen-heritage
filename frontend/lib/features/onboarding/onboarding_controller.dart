import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_page_model.dart';


class OnboardingController {
  final PageController pageController = PageController();
  int currentIndex = 0;

  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: "مرحبا بك في الموسوعة الذكية",
      description: "استكشف تاريخ اليمن القديم بطريقة تفاعلية",
      image: "assets/onboarding/on1.png",
    ),
    OnboardingPageModel(
      title: "تعرف على الممالك القديمة",
      description: "سبأ، معين، حمير، قتبان والمزيد",
      image: "assets/onboarding/on2.png",
    ),
    OnboardingPageModel(
      title: "الواقع المعزز",
      description: "شاهد المعالم اليمنية بتقنية AR",
      image: "assets/onboarding/on3.png",
    ),
  ];

  Future<void> markOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("onboarding_seen", true);
  }
}

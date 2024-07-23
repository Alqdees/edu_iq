// ignore_for_file: file_names
import 'package:edu_iraq/Onboarding/CircularProgressIndicatorButton.dart';
import 'package:edu_iraq/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Widget> _buildPages() {
    return [
      _buildPage(
        title: 'أهمية الدراسة',
        subTitle:
            'الدراسة تفتح آفاقًا واسعة للتعلم والمعرفة، وتساهم في بناء مستقبل مشرق.',
        imageUrl: 'assets/images/ima_onboarding.webp',
        backgroundColor: Colors.blue[100]!,
      ),
      _buildPage(
        title: 'فوائد التعليم',
        subTitle:
            'التعليم يعزز التفكير النقدي، ويطور المهارات الاجتماعية، ويزيد من فرص النجاح في الحياة.',
        imageUrl: 'assets/images/ima_onboarding.webp',
        backgroundColor: Colors.green[100]!,
      ),
      _buildPage(
        title: 'استمرارية التعلم',
        subTitle:
            'التعلم المستمر يضمن البقاء على اطلاع دائم في مجال التخصص، ويساعد في تحقيق الأهداف الشخصية والمهنية.',
        imageUrl: 'assets/images/ima_onboarding.webp',
        backgroundColor: Colors.orange[100]!,
      ),
    ];
  }

  Widget _buildPage({
    required String title,
    required String subTitle,
    required String imageUrl,
    required Color backgroundColor,
  }) {
    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Image.asset(imageUrl, width: 300, height: 300),
            const SizedBox(height: 20),
            Text(title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(subTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: _buildPages(),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: List.generate(
                          _buildPages().length,
                          (int index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              height: 8,
                              width: _currentPage == index ? 24 : 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? Colors.blue
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          _pageController.jumpToPage(_buildPages().length - 1);
                        },
                        child: const Text(
                          'تخطي',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_currentPage == _buildPages().length - 1) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('seenOnboarding', true);
                        Navigator.pushReplacement(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      } else {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      }
                    },
                    child: CircularProgressIndicatorButton(
                      progress: (_currentPage + 1) / _buildPages().length,
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

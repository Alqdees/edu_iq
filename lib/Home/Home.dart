import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:edu_iraq/Home/HomeSceern/onTapHome.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _currentIndex = 0;

  late final List<Map<String, dynamic>> subjects;
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    subjects = getSubjects();

    _controllers = List<AnimationController>.generate(subjects.length, (index) {
      return AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    for (int i = 0; i < subjects.length; i++) {
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) {
        _controllers[i].forward(from: 0);
      }
    }
    if (mounted) {
      _startAnimationSequence();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget buildSubjectCard(Map<String, dynamic> subject, int index) {
    return SizedBox(
      width: 110,
      height: 110,
      child: Card(
        color: Colors.grey[900],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: subject['onTap'],
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animations[index],
                  builder: (context, child) {
                    if (subject['icon'] == FontAwesome.mosque_solid) {
                      return Transform.translate(
                        offset: Offset(0, _animations[index].value * 10 - 5),
                        child: Icon(
                          subject['icon'],
                          size: 40,
                          color: Colors.amber,
                        ),
                      );
                    } else {
                      return Transform.rotate(
                        angle: _animations[index].value * 6.28,
                        child: Icon(
                          subject['icon'],
                          size: 40,
                          color: Colors.amber,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  subject['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (subject['subtitle'].isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    subject['subtitle'],
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: CarouselSlider(
                    items: [
                      "assets/images/ima_onboarding.webp",
                      "assets/images/ima_onboarding.webp",
                    ].map((imagePath) {
                      return Container(
                        height: 500,
                        width: 500,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            topLeft: Radius.circular(130.0),
                            bottomRight: Radius.circular(130.0),
                            topRight: Radius.circular(0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              imagePath,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ).animate().fadeIn(duration: 500.ms),
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      animateToClosest: true,
                      reverse: false,
                      autoPlayAnimationDuration: const Duration(milliseconds: 1200),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      viewportFraction: 0.99,
                      height: 200,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1].map((index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index ? Colors.green : Colors.blue,
                      ),
                    );
                  }).toList(),
                ).animate().slideY(begin: 0.2, duration: 300.ms),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'المواد الدراسية',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: Color(0xffe6e0e9),
                          fontFamily: 'Amiri',
                          height: 1.4,
                          letterSpacing: 0.3,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(3, (index) {
                        return buildSubjectCard(subjects[index], index);
                      }),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(3, (index) {
                        return buildSubjectCard(subjects[index + 3], index + 3);
                      }),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSubjectCard(subjects[6], 6),
                        const SizedBox(width: 10),
                        buildSubjectCard(subjects[7], 7),
                      ],
                    ),
                  ],
                ),
              ],
          ),
        ),
      ),
    );
  }
}
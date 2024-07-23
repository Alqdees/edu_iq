import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class Hool extends StatefulWidget {
  const Hool({super.key});

  @override
  _HoolState createState() => _HoolState();
}

class _HoolState extends State<Hool> with TickerProviderStateMixin {
  late final List<Map<String, dynamic>> subjects;

  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    subjects = [
      {
        'name': 'الفزياء',
        'icon': FontAwesome.atom_solid,
        'subtitle': '',
        'onTap': () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const PhysicsPage()));
        }
      },
      {
        'name': 'الكيمياء',
        'icon': FontAwesome.flask_solid,
        'subtitle': '',
        'onTap': () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const PhysicsPage()));
        }
      },
      {
        'name': 'الاحياء',
        'icon': FontAwesome.dna_solid,
        'subtitle': '',
        'onTap': () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const PhysicsPage()));
        }
      },
      {
        'name': 'الرياضيات',
        'icon': FontAwesome.calculator_solid,
        'subtitle': '',
        'onTap': () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const PhysicsPage()));
        }
      },
      {
        'name': 'الاسلامية',
        'icon': FontAwesome.mosque_solid,
        'subtitle': '',
        'onTap': () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const PhysicsPage()));
        }
      },
      {
        'name': 'الانكليزية',
        'icon': FontAwesome.language_solid,
        'subtitle': '',
        'onTap': () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const PhysicsPage()));
        }
      },
      {
        'name': 'العربية',
        'icon': FontAwesome.book_open_solid,
        'subtitle': '',
        'onTap': () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const PhysicsPage()));
        }
      },
      {
        'name': 'الفرنسية',
        'icon': FontAwesome.flag,
        'subtitle': '',
        'onTap': () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const PhysicsPage()));
        }
      },
    ];

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
      appBar: AppBar(
        title: const Text('مواد دراسية'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
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
      ),
    );
  }
}
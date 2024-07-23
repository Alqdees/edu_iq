// import 'package:audioplayers/audioplayers.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:edu_iraq/Home/Home.dart';
import 'package:edu_iraq/Notifications/Notifications.dart';
import 'package:edu_iraq/Setting/Settings.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Navigation_Bar extends StatefulWidget {
  final String userImageUrl;
  final String username;
  final String userId;
  final String email;
  final int initialPage;

  const Navigation_Bar({
    super.key,
    required this.userImageUrl,
    required this.username,
    required this.userId,
    required this.email,
    this.initialPage = 1,
  });

  @override
  State<Navigation_Bar> createState() => _Navigation_BarState();
}

class _Navigation_BarState extends State<Navigation_Bar> {
  // final AudioPlayer player = AudioPlayer();
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  late int index;
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    // player.setSource(AssetSource('voices/sounde.m4a'));
    index = widget.initialPage;
    screens = [
      const Notifications(),
      const Home(),
      Settings1(
        userImageUrl: widget.userImageUrl,
        username: widget.username,
        email: widget.email,
      ),
    ];
  }

  @override
  void dispose() {
    // player.dispose();
    super.dispose();
  }

  Future<void> playSound() async {
    // await player.play(AssetSource('voices/sounde.m4a'));
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
       Icon(
        MdiIcons.bellOutline, // الجرس
        size: 25,
      ),
       Icon(
        MdiIcons.homeOutline, // المنزل
        size: 30,
      ),
       Icon(
        MdiIcons.cogOutline, // الإعدادات
        size: 25,
      ),
    ];
    return Scaffold(
      extendBody: true,
      drawerScrimColor: Colors.black,
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        child: CurvedNavigationBar(
          key: navigationKey,
          color: const Color(0xFF1976D2),
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: const Color(0xFF388E3C),
          height: 55,
          index: index,
          items: items,
          onTap: (index) {
            playSound();
            setState(() {
              this.index = index;
            });
          },
        ),
      ),
    );
  }
}
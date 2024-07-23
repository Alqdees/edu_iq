import 'package:edu_iraq/Login/Login.dart';
import 'package:edu_iraq/Setting/Share%20App/ShareApp.dart';
import 'package:edu_iraq/Setting/Teacher/Teacher.dart';
import 'package:edu_iraq/Setting/Theme/Theme.dart';
import 'package:edu_iraq/Setting/Theme/theme_provider.dart';
import 'package:edu_iraq/Setting/accountbox/AccauntBox.dart';
import 'package:edu_iraq/Setting/language/languageAR.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings1 extends StatefulWidget {
  final String userImageUrl;
  final String username;
  final String email;

  const Settings1({
    super.key,
    required this.userImageUrl,
    required this.username,
    required this.email,
  });

  @override
  State<Settings1> createState() => _SettingsState();
}

class _SettingsState extends State<Settings1> {
  String userImage = '';
  String displayName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userImage = prefs.getString('image') ?? widget.userImageUrl;
      displayName = prefs.getString('username') ?? widget.username;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String userImageToShow =
        userImage.isEmpty ? 'assets/images/ima_onboarding.webp' : userImage;

    final String displayNameToShow =
        displayName.isEmpty ? 'لم يحدد' : displayName;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
              CircleAvatar(
              backgroundImage: userImageToShow.startsWith('assets')
                  ? AssetImage(userImageToShow) as ImageProvider
                  : NetworkImage(userImageToShow),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('مرحبا بك', style: TextStyle(fontSize: 20)),
                Text(displayNameToShow, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: ListView(
          padding: const EdgeInsets.all(14.0),
          children: <Widget>[
            accountbox(context, Icons.account_box, 'تفاصيل الحساب', isDarkMode),
            teacherAN(context, Icons.manage_accounts_rounded, 'حساب الادمن', '', isDarkMode),
            shareApp(context, Icons.share, 'شارك التطبيق','share',isDarkMode),
            language(context,Icons.settings, 'اللغة', isDarkMode),
            buildSettingItemWithSwitch(Icons.nightlight_round, 'الوضع الليلي', context),
            buildSettingItem(Icons.support_agent, 'الدعم الفني', isDarkMode),
            buildSettingItem(Icons.info, 'معلومات عنا', isDarkMode),
            buildSettingItem(Icons.rule, 'الأحكام والشروط', isDarkMode),
            const SizedBox(height: 15),
            buildSignOutItem('تسجيل الخروج', isDarkMode),
            buildDeleteAccountItem('حذف الحساب', isDarkMode),
            const SizedBox(height: 55,),
          ],
        ),
      ),
    );
  }

  Widget buildSettingItem(IconData icon, String title, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF3B394E) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).iconTheme.color),
          const SizedBox(width: 16),
          Expanded(
              child: Text(title,
                  style: TextStyle(color: Theme.of(context).iconTheme.color))),
          Container(
            width: 25,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue),
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_forward_ios,
                size: 10,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeleteAccountItem(String title, bool isDarkMode) {
    return GestureDetector(
      onTap: () => _confirmDeleteAccount(isDarkMode),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF3B394E) : Colors.red[50],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? const Color(0xFF18162C)
                  : Colors.red.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget buildSignOutItem(String title, bool isDarkMode) {
    return GestureDetector(
      onTap: () => _confirmSignOut(isDarkMode),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF3B394E) : Colors.red[50],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? const Color(0xFF18162C)
                  : Colors.red.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(bool isDarkMode) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF3B394E) : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'تأكيد تسجيل الخروج',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                    decoration: TextDecoration.none,
                    fontFamily: 'Amiri',
                  ),
                ),
                Text(
                  'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    decoration: TextDecoration.none,
                    fontFamily: 'Amiri',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('إلغاء',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Amiri',
                          )),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _signOut();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('تسجيل الخروج',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Amiri',
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  Future<void> _confirmDeleteAccount(bool isDarkMode) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF3B394E) : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'تأكيد حذف الحساب',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                    decoration: TextDecoration.none,
                    fontFamily: 'Amiri',
                  ),
                ),
                Text(
                  'هل أنت متأكد أنك تريد حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('إلغاء',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Amiri',
                          )),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _deleteAccount();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('حذف',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Amiri',
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('فشل حذف الحساب. الرجاء المحاولة مرة أخرى.')),
      );
    }
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return GlowingOverscrollIndicator(
      axisDirection: axisDirection,
      color: Theme.of(context).hintColor,
      child: child,
    );
  }
}

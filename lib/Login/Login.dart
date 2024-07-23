// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, file_names
import 'dart:developer';

import 'package:edu_iraq/Navigation%20Bar/Navigation_Bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool isLoginFailed = false;
  bool _obscurePassword = true;
  late AnimationController _iconTranslationController;
  late Animation<double> _iconTranslationAnimation;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  // late bool isrecord;

  @override
  void initState()  {
    super.initState();
    // isrecord =  ScreenProtector.isRecording();
     ScreenProtector.preventScreenshotOn();
    _iconTranslationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _iconTranslationAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
          parent: _iconTranslationController, curve: Curves.easeInOut),
    );

    _iconTranslationController.forward();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _emailController.addListener(_handleTextChange);
    _passwordController.addListener(_handleTextChange);
  }

  @override
  void dispose()  {
     ScreenProtector.preventScreenshotOff();
    _emailController.dispose();
    _passwordController.dispose();
    _iconTranslationController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    if (_emailController.text.isNotEmpty ||
        _passwordController.text.isNotEmpty) {
      _rotationController.forward();
    } else {
      _rotationController.reverse();
    }
  }

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true;
      isLoginFailed = false;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = userCredential.user;

      if (user != null) {
        String userImageUrl =
            user.photoURL ?? ''; // Assuming photoURL is used for user image URL
        String username = user.displayName ??
            ''; // Assuming displayName is used for user name
        String userId = user.uid;
        String email = user.email ?? ''; // Get user email

        setState(() {
          isLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Navigation_Bar(
              userImageUrl: userImageUrl,
              username: username,
              userId: userId,
              email: email, initialPage: 2, // Pass the email here
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isLoginFailed = true;
      });
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        isLoginFailed = true;
      });
      return;
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      setState(() {
        isLoginFailed = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password reset email sent, check your inbox.')));
    } catch (e) {
      setState(() {
        isLoginFailed = true;
      });
    }
  }

  Widget _buildTextField(String labelText, IconData icon, bool obscureText,
      TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Icon(icon, color: Colors.tealAccent),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.tealAccent,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow),
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow),
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),
          _buildTextField('إيميل', Icons.email, false, _emailController),
          const SizedBox(height: 15),
          _buildTextField(
              'كلمة السر', Icons.lock, _obscurePassword, _passwordController,
              isPassword: true,),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text('تسجيل الدخول'),
          ),
          const SizedBox(height: 14),
          if (isLoginFailed)
            const Text('فشل تسجيل الدخول، حاول مرة أخرى.',
                style: TextStyle(color: Colors.white)),
          const SizedBox(height: 0),
          TextButton(
            onPressed: isLoading
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('إعادة تعيين كلمة السر',
                              style: TextStyle(color: Colors.yellow)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'الرجاء إدخال بريدك الإلكتروني. سنرسل لك رابط إعادة تعيين كلمة السر. إذا لم تتلق الرسالة، تحقق من مجلد البريد غير المرغوب فيه.',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              _buildTextField('إيميل', Icons.email, false,
                                  _emailController),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('إلغاء',
                                  style: TextStyle(color: Colors.yellow)),
                            ),
                            TextButton(
                              onPressed: _resetPassword,
                              child: const Text('إرسال',
                                  style: TextStyle(color: Colors.yellow)),
                            ),
                          ],
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        );
                      },
                    );
                  },
            child: const Text('نسيت كلمة السر؟',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // log('message is recorde video $isrecord');
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            ClipRect(
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 0.6,
                  child: AnimatedBuilder(
                    animation: _iconTranslationAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _iconTranslationAnimation.value),
                        child: AnimatedBuilder(
                          animation: _rotationAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationAnimation.value,
                              child: child,
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            height: 200,
                            child: const Icon(Icons.person,
                                size: 130, color: Colors.black),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.yellow)),
                SizedBox(width: 8),
                Text('قم بإدخال حسابك من فضلك',
                    style: TextStyle(color: Colors.yellow)),
                SizedBox(width: 8),
                Expanded(child: Divider(color: Colors.yellow)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _buildLoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}

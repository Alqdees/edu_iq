// ignore_for_file: library_private_types_in_public_api, empty_catches
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:edu_iraq/Login/Login.dart';
import 'package:edu_iraq/Navigation%20Bar/Navigation_Bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';


class Account extends StatefulWidget {
  const Account({super.key});

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  User? user;
  String userId = '';
  String userImage = 'assets/images/ima_onboarding.webp';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      userId = user!.uid.substring(0, 5);

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? storedUsername = prefs.getString('username');
        String? storedImage = prefs.getString('image');

        if (storedUsername != null && storedImage != null) {
          if (mounted) {
            setState(() {
              _usernameController.text = storedUsername;
              _emailController.text = user!.email!;
              userImage = storedImage;
            });
          }
        } else {
          firestore.DocumentSnapshot userData = await _firestore.collection('users').doc(user!.uid).get();

          if (userData.exists) {
            if (mounted) {
              setState(() {
                _usernameController.text = userData['username'];
                _emailController.text = user!.email!;
                userImage = userData['image'] ?? 'assets/images/ima_onboarding.webp';
              });
            }

            await prefs.setString('username', userData['username']);
            await prefs.setString('image', userData['image'] ?? 'assets/images/ima_onboarding.webp');
          } else {
            await _firestore.collection('users').doc(user!.uid).set({
              'username': user!.displayName ?? 'اسم المستخدم',
              'image': 'assets/images/ima_onboarding.webp',
            });

            if (mounted) {
              setState(() {
                _usernameController.text = user!.displayName ?? 'اسم المستخدم';
                _emailController.text = user!.email!;
                userImage = 'assets/images/ima_onboarding.webp';
              });
            }

            await prefs.setString('username', user!.displayName ?? 'اسم المستخدم');
            await prefs.setString('image', 'assets/images/ima_onboarding.webp');
          }
        }
      } catch (e) {
      }
    }
  }


Future<void> _saveUserData() async {
  if (user != null && _formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    try {
      final String imageUrl = _imageFile != null ? await _uploadImage(_imageFile!) : userImage;

      firestore.DocumentReference userDocRef = _firestore.collection('users').doc(user!.uid);

      firestore.DocumentSnapshot userData = await userDocRef.get();
      if (userData.exists) {
        await userDocRef.update({
          'username': _usernameController.text,
          'image': imageUrl,
        });
      } else {
        await userDocRef.set({
          'username': _usernameController.text,
          'image': imageUrl,
        });
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('image', imageUrl);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Navigation_Bar(
              userImageUrl: imageUrl,
              username: _usernameController.text,
              email: user!.email!,
              initialPage: 2,
              userId: userId,
            ),
          ),
        );
      }

      AnimatedSnackBar.material(
        'تم حفظ البيانات بنجاح',
        type: AnimatedSnackBarType.success,
      ).show(context);
    } catch (e) {
      AnimatedSnackBar.material(
        'حدث خطأ أثناء حفظ البيانات',
        type: AnimatedSnackBarType.error,
      ).show(context);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
  Future<String> _uploadImage(File image) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('userImages')
          .child('${user!.uid}.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      return 'assets/images/ima_onboarding.webp';
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _imageFile = File(result.files.single.path!);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('البيانات الشخصية'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : userImage.startsWith('http')
                                ? NetworkImage(userImage)
                                : AssetImage(userImage) as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 65,
                        top: 70,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 25, color: Colors.blue),
                          onPressed: _pickImage,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'الأيدي: $userId',
                    labelStyle: const TextStyle(
                      color: Colors.blue,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabled: false,
                  ),
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'اسم الطالب',
                    border: OutlineInputBorder(
                      borderRadius:  BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم الطالب';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'الإيميل: ${user?.email ?? ''}',
                    labelStyle: const TextStyle(
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabled: false,
                  ),
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'الغاء',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveUserData,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'حفظ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _confirmDeleteAccount,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "حذف الحساب",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeleteAccount() async {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF3B394E) : Colors.white,
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
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _deleteAccount1();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'حذف',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Amiri',
                        ),
                      ),
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

  Future<void> _deleteAccount1() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل حذف الحساب. الرجاء المحاولة مرة أخرى.')),
      );
    }
  }
}
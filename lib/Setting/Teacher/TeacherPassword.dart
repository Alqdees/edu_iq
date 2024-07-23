import 'package:edu_iraq/Setting/Teacher/Teacher_Abmin.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

Future<dynamic> showPasswordDialog(BuildContext context) {
  String inputCode = '';
  bool isError = false;
  final ValueNotifier<bool> isWriting = ValueNotifier(false);

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Column(
              children: [
                Text('أدخل الرمز السري'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.yellow.shade500, width: 2),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock,
                        size: 30,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              inputCode = value;
                              isError = false;
                              isWriting.value = value.isNotEmpty;
                            });
                          },
                          decoration: const InputDecoration(hintText: "الرمز السري"),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isError)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'الرمز السري غير صحيح',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('إلغاء'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('تأكيد'),
                onPressed: () {
                  if (inputCode == '12345') {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  const teacher_Abmin()),
                    );
                  } else {
                    setState(() {
                      isError = true;
                    });
                    AnimatedSnackBar.material(
                      'الرمز السري غير صحيح',
                      type: AnimatedSnackBarType.error,
                      duration: const Duration(seconds: 2),
                    ).show(context);
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}
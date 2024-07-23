import 'package:edu_iraq/Setting/accountbox/Account.dart';
import 'package:flutter/material.dart';

Widget accountbox(BuildContext context, IconData icon, String title, bool isDarkMode) {
  return GestureDetector(
    child: Container(
      padding: const EdgeInsets.all(6.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF3B394E): Colors.white, 
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
          Icon(icon),
          const SizedBox(width: 16),
          Expanded(child: Text(title)),
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
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Account()),
      );
    },
  );
}
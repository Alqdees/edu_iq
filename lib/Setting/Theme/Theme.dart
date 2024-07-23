import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

Widget buildSettingItemWithSwitch(IconData icon, String title, BuildContext context) {
  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
      return Container(
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
              child: Text(
                title,
                style: TextStyle(color: Theme.of(context).iconTheme.color),
              ),
            ),
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),
      );
    },
  );
}
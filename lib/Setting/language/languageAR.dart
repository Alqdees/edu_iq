// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edu_iraq/main.dart';

Widget language(BuildContext context, IconData icon, String title, bool isDarkMode) {
  return GestureDetector(
    child: Container(
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
      _showLanguageDialog(context);
    },
  );
}

void _showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AlertDialog(
        title: Text('اختر اللغة'),
        content: LanguageSelection(),
      );
    },
  );
}

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({super.key});

  @override
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  String _selectedLanguage = 'ar';

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'ar';
    });
  }

  Future<void> _saveLanguagePreference(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
    setState(() {
      _selectedLanguage = language;
    });
    _updateLocale(language);
  }

  void _updateLocale(String language) {
    Locale newLocale;
    if (language == 'en') {
      newLocale = const Locale('en');
    } else {
      newLocale = const Locale('ar');
    }
    MyApp.of(context)?.setLocale(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
          RadioListTile<String>(
          title: const Text('العربية'),
          value: 'ar',
          groupValue: _selectedLanguage,
          onChanged: (String? value) {
            if (value != null) {
              _saveLanguagePreference(value);
            }
          },
        ),
         RadioListTile<String>(
          title: const Text('English'),
          value: 'en',
          groupValue: _selectedLanguage,
          onChanged: (String? value) {
            if (value != null) {
              _saveLanguagePreference(value);
            }
          },
        ),
      ],
    );
  }
}
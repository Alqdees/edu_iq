// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class teacher_Abmin extends StatelessWidget {
  const teacher_Abmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const searchUserScreen()),
                );
              },
              child: const Text('اذهب إلى صفحة الحساب'),
            ),
          ],
        ),
      ),
    );
  }
}

class searchUserScreen extends StatefulWidget {
  const searchUserScreen({super.key});

  @override
  _searchUserScreenState createState() => _searchUserScreenState();
}

class _searchUserScreenState extends State<searchUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserRecord> _searchResults = [];

  void _searchUser(String partialUID) async {
    if (partialUID.isEmpty) return;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;

    List<UserRecord> matchingUsers = docs.where((doc) {
      String customId = doc['customId'];
      return customId.contains(partialUID);
    }).map((doc) => UserRecord(
      customId: doc['customId'], 
      email: doc['email'], 
      phone: doc['phone'] 
    )).toList();

    setState(() {
      _searchResults = matchingUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search User by Custom ID'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Enter part of Custom ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _searchUser(_searchController.text.trim());
              },
              child: const Text('Search'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  UserRecord user = _searchResults[index];
                  return ListTile(
                    title: Text(user.email),
                    subtitle: Text('${user.customId}\nPhone: ${user.phone}'), 
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserRecord {
  final String customId;
  final String email;
  final String phone;

  UserRecord({required this.customId, required this.email, required this.phone});
}

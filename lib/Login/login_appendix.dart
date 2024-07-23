import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Data_login extends StatelessWidget {
  const Data_login({
    super.key,
    required this.isLoading,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isLoading ? const LinearGradient(colors: [Colors.grey, Colors.grey], begin: Alignment.topLeft, end: Alignment.bottomRight) : const LinearGradient(colors: [Colors.purple, Colors.pink], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      alignment: Alignment.center,
      child: isLoading ? const SpinKitThreeBounce(color: Colors.white, size: 20.0) : const Text('سجل دخول', style: TextStyle(color: Colors.white)),
    );
  }
}



class Data_login2 extends StatelessWidget {
  const Data_login2({
    super.key,
    required this.isLoading,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isLoading ? const LinearGradient(colors: [Colors.grey, Colors.grey], begin: Alignment.topLeft, end: Alignment.bottomRight) : const LinearGradient(colors: [Colors.purple, Colors.pink], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      alignment: Alignment.center,
      child: isLoading ? const SpinKitThreeBounce(color: Colors.white, size: 20.0) : const Text('سجل', style: TextStyle(color: Colors.white)),
    );
  }
}


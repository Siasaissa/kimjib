import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: const Text(
        'Insurance App - Powered by HumTech © 2025',
        style: TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );

    //my floating button
    floatingActionButton: FloatingActionButton(
      backgroundColor: Color(0xFF171C6E), // Only one colon
      onPressed: () {
       // setState(() {
         // _currentIndex = 2;
        });
     // },
     // child: const Icon(Icons.qr_code_scanner, color: Colors.white),
    //),
  }
}

import 'package:flutter/material.dart';
import 'package:kimjib/screens/app_drawer.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My profile'),
        ),
        drawer: const AppDrawer(),
        body: const Center(
          child: Text('the profile is here',
            style: TextStyle(color: Colors.red),
          ),
        )
    );
  }
}
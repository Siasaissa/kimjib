import 'package:flutter/material.dart';

class ProfomaPage extends StatefulWidget {
  const ProfomaPage({super.key});

  @override
  State<ProfomaPage> createState() => _ProfomaPageState();
}

class _ProfomaPageState extends State<ProfomaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profoma', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text('profoma'),
      ),
    );

  }
}

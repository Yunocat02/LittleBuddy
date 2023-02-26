import 'package:flutter/material.dart';

class Helpview extends StatefulWidget {
  const Helpview({super.key});

  @override
  State<Helpview> createState() => _HelpviewState();
}

class _HelpviewState extends State<Helpview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ยินดีต้อนรับ สู่หน้า Helpview")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}

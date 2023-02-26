import 'package:flutter/material.dart';

class Mapnaja extends StatefulWidget {
  const Mapnaja({super.key});

  @override
  State<Mapnaja> createState() => _MapnajaState();
}

class _MapnajaState extends State<Mapnaja> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ยินดีต้อนรับ สู่หน้า map")),
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

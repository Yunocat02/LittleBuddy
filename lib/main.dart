import 'package:LittleBuddy/views/cam_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //? CodeWithFlexz on Instagram

//* AmirBayat0 on Github
//! Programming with Flexz on Youtube

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

import 'package:LittleBuddy/views/chatpage.dart';
import 'package:LittleBuddy/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Run the app
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  bool isGetUserRoleFinished =
      false; // เพิ่มตัวแปรสำหรับตรวจสอบการโหลด getUserRole() เสร็จสิ้นหรือยัง

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      getUserRole().whenComplete(() {
        setState(() {
          isGetUserRoleFinished = true;
        });
      });
    } else {
      isGetUserRoleFinished =
          true; // กรณีที่ user == null ให้เข้าสู่ home โดยตรง
    }
  }

  String email = 'test';
  @override
  Widget build(BuildContext context) {
    return isGetUserRoleFinished // ตรวจสอบว่า getUserRole() เสร็จสิ้นหรือยัง
        ? GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home: user != null ? Home() : Home(),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
  }
}

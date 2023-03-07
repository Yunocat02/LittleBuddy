import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../utils/styles.dart';
import 'clinic_view.dart';
import 'home.dart';
import 'login_view.dart';
import 'mypets_view.dart';

class Helpview extends StatefulWidget {
  const Helpview({super.key});

  @override
  State<Helpview> createState() => _HelpviewState();
}

List navItems = [
  {
    'text': 'Adopt',
    'icon': 'assets/nav_icons/pill_icon.svg',
    'page': const Home()
  },
  {
    'text': 'Clinic',
    'icon': 'assets/nav_icons/heart_icon.svg',
    'page': const Clinic()
  },
  {
    'text': 'Pets',
    'icon': 'assets/nav_icons/vet_icon.svg',
    'page': const Mypets()
  },
  {
    'text': 'Help',
    'icon': 'assets/nav_icons/help_icon.svg',
    'page': const Helpview()
  },
];

class _HelpviewState extends State<Helpview> {
  @override
  Widget build(BuildContext context) {
    void showAlert() {
      QuickAlert.show(
          context: context, title: "Please login", type: QuickAlertType.error);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Help"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "หากเกิดปัญหาการใช้งานโปรติดต่อ Admin",
                style: TextStyle(fontSize: 20),
              ),
              const Gap(10),
              Text(
                "เบอร์ติดต่อ: 08x-xxxxxxx",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Facebook: LittleBuddy Offical",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Line: LittleBuddy Offical",
                style: TextStyle(fontSize: 18),
              ),
              const Gap(10),
              Text(
                "แอพนี้ถูกสร้างขึ้นมาเพื่อเป็น Project วิชา Soft engineer",
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 40),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "สมาชิกกลุ่ม",
                      style: TextStyle(fontSize: 48),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "วิวรรธน์ จงสมจิตต์",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "นิรุท คุณวงค์",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "ชวัลวิทย์ แก่นคง",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "เสฏฐนันท์ โมสาลียานนท์",
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 85,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            color: Styles.bgColor),
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: navItems.map<Widget>((e) {
            return InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(e['icon'],
                      height: 20,
                      color: navItems.indexOf(e) == 3
                          ? Styles.highlightColor
                          : null),
                  Text(
                    e['text'],
                    style: TextStyle(
                        fontSize: 12,
                        color: navItems.indexOf(e) == 3
                            ? Styles.highlightColor
                            : Styles.blackColor,
                        fontWeight:
                            navItems.indexOf(e) == 3 ? FontWeight.bold : null),
                  )
                ],
              ),
              onTap: () async {
                if (navItems.indexOf(e) == 0) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => e['page']));
                }
                if (navItems.indexOf(e) == 1 || navItems.indexOf(e) == 2) {
                  if (globalRole?.role == 'A' ||
                      globalRole?.role == 'M' ||
                      globalRole?.role == 'D') {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => e['page']));
                  } else {
                    showAlert();
                  }
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

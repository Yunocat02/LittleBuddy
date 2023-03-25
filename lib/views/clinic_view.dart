// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:LittleBuddy/views/Chatbot2_view.dart';
import 'package:LittleBuddy/views/cam_view.dart';
import 'package:LittleBuddy/views/chatpage.dart';
import 'package:LittleBuddy/views/home.dart';
import 'package:LittleBuddy/views/petconnect.dart';
import 'package:LittleBuddy/views/showreportmember.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/styles.dart';
import 'datareportviewsmember.dart';
import 'help_view.dart';
import 'mypets_view.dart';

class Clinic extends StatefulWidget {
  const Clinic(
      {Key? key,
      required this.doctorid,
      required this.petid,
      required this.username})
      : super(key: key);

  final String doctorid;
  final String petid;
  final String username;
  @override
  State<Clinic> createState() => _ClinicState();
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
    'page': const petconnect()
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

class _ClinicState extends State<Clinic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 130, 219, 241),
        title: Text("Menu ในร้าน Clinic"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // add some padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: () {},
                child: Text('Webboard คลินิก', style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => chatpage(
                        doctorid: widget.doctorid,
                        petid: widget.petid,
                        email: widget.username,
                      ),
                    ),
                  );
                },
                child: Text('Chat คลินิก', style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => bot2()),
                  );
                },
                child: Text('Chatbot', style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => showdatareportmem(
                        doctorid: widget.doctorid,
                        petid: widget.petid,
                      ),
                    ),
                  );
                },
                child:
                    Text('ลายละเอียดการรักษา', style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => cam(
                        doctorid: widget.doctorid,
                        petid: widget.petid,
                      ),
                    ),
                  );
                },
                child: Text('กล้อง', style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("ยืนยันจบการทำการรักษา"),
                          content: Text("คุณยืนยันว่าได้รับสัตว์เลี้ยงของคุณคืนแล้ว แล้วต้องการจะจบการทำการรักษาใช่หรือไม่?"),
                          actions: [
                            TextButton(
                              child: Text("ยกเลิก"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text("ยืนยัน"),
                              onPressed: () {},
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('ยืนยันจบการทำการรักษา',
                      style: TextStyle(fontSize: 24)),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 255, 158, 181),
                  )),
            ),
          ],
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
                      color: navItems.indexOf(e) == 1
                          ? Styles.highlightColor
                          : null),
                  Text(
                    e['text'],
                    style: TextStyle(
                        fontSize: 12,
                        color: navItems.indexOf(e) == 1
                            ? Styles.highlightColor
                            : Styles.blackColor,
                        fontWeight:
                            navItems.indexOf(e) == 1 ? FontWeight.bold : null),
                  )
                ],
              ),
              onTap: () async {
                if (navItems.indexOf(e) == 0 ||
                    navItems.indexOf(e) == 2 ||
                    navItems.indexOf(e) == 3) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => e['page']));
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

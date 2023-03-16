// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:LittleBuddy/views/Chatbot2_view.dart';
import 'package:LittleBuddy/views/cam_view.dart';
import 'package:LittleBuddy/views/home.dart';
import 'package:LittleBuddy/views/showreportmember.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/styles.dart';
import 'datareportviewsmember.dart';
import 'help_view.dart';
import 'mypets_view.dart';

class Clinic extends StatefulWidget {
  const Clinic({
    Key? key,
    this.doctorid, required String petid,
  }) : super(key: key);
  final String? doctorid;
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
    'page': const Clinic(doctorid: '', petid: '',)
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
        title: Text("Menu ในร้าน Clinic"),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                onPressed: () {},
                child: Text('Chat คลินิก', style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
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
                    String? doctorid=widget.doctorid;
                    Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                          builder: (context) => showdatareportmem(
                                          doctorid:doctorid
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
                onPressed: () {},
                child: Text('เช็ควันนัดหมาย', style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => cam()),
                  );
                },
                child: Text('กล้อง', style: TextStyle(fontSize: 24)),
              ),
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

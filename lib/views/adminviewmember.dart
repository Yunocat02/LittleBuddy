import 'package:LittleBuddy/views/adminviewdoctor.dart';
import 'package:LittleBuddy/views/petconnect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../utils/styles.dart';
import 'clinic_view.dart';
import 'datareportviewsmember.dart';
import 'help_view.dart';
import 'home.dart';

class adminviewmember extends StatefulWidget {
  const adminviewmember({super.key});

  @override
  State<adminviewmember> createState() => _adminviewmember();
}

class _adminviewmember extends State<adminviewmember> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final firestore = FirebaseFirestore.instance;

  late FirebaseAuth _auth;
  final _user = Rxn<User>();
  late Stream<User?> _authStateChanges;

 List navItems = [
    {
      'text': 'Adopt',
      'icon': 'assets/nav_icons/pill_icon.svg',
      'page': const Home()
    },
    {
      'text': 'Clinic',
      'icon': 'assets/nav_icons/heart_icon.svg',
      'page': const adminviewmember()
    },
    {
      'text': 'Pets',
      'icon': 'assets/nav_icons/vet_icon.svg',
      'page': const adminviewdoctor()
    },
    {
      'text': 'Help',
      'icon': 'assets/nav_icons/help_icon.svg',
      'page': const Helpview()
    },
  ];

  @override
  void initState() {
    super.initState();
    initAuth();
  }

  void initAuth() async {
    _auth = FirebaseAuth.instance;
    _authStateChanges = _auth.authStateChanges();
    _authStateChanges.listen((User? user) {
      _user.value = user;
    });
  }

  User? getuser() {
    _user.value = _auth.currentUser;
    return _user.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 130, 219, 241),
        title: const Text('ลูกค้าที่ลงทะเบียนกับแอพเรา'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('userdatabase') // ชื่อตาราง
            .where('role',isEqualTo: 'M') // เอา id เก็บแบบ doc // id sub field ที่แต่ย่อยมาตอน addpet
            .snapshots(), // ตัวกลางในการ อ่าน/เขียน ข้อมูล
        builder: (context, subCollectionSnapshot) {
          if (subCollectionSnapshot.hasData) {
            return Container(
              // บอกลักษณะกล่อง
              decoration: BoxDecoration(
                  //color: Color.fromARGB(255, 167, 196, 219),
                  borderRadius: BorderRadius.circular(20)),
              height: MediaQuery.of(context).size.height *
                  1, // ตั้งค่าความสูงของ Container เป็น 40% ของความสูงของหน้าจอ
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      // จำนวนสัตว์ที่แสดง
                      itemCount: subCollectionSnapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        // ดึงข้อมูล
                        final data = subCollectionSnapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            // กรอบของแต่ละรายการ
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 192, 247,
                                    248) // เปลี่ยนสีพื้นหลังของ Container แต่ละรายการ
                                ),
                            // เนื้อใน
                            child: ListTile(
                                title: Text(
                                  "ชื่อ: " + data['username'] ?? "N/A",
                                  style: TextStyle(fontSize: 25),
                                  
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("uid :"+subCollectionSnapshot.data!.docs[index].id,
                                  style: TextStyle(fontSize: 15),)
                                  ],
                                ),
                               
                                // ในส่วนของการเลือกร้าน
                                onTap: () {}),
                          ),
                        );
                      })),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
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

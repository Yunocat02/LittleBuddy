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

class Mypets extends StatefulWidget {
  const Mypets({super.key});

  @override
  State<Mypets> createState() => _Mypets();
}

class _Mypets extends State<Mypets> {
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
        title: const Text('Mypet'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('petreport') // ชื่อตาราง
            .doc(getuser()?.uid) // เอา id เก็บแบบ doc
            .collection("0001") // id sub field ที่แต่ย่อยมาตอน addpet
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
                                // border: Border.all(
                                //   color: Color.fromARGB(255, 118, 133, 145),
                                //   width: 1.0,
                                // ),
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 192, 247,
                                    248) // เปลี่ยนสีพื้นหลังของ Container แต่ละรายการ
                                ),
                            // เนื้อใน
                            child: ListTile(
                                title: Text(
                                  "ชื่อ: " + data['name'] ?? "N/A",
                                  style: TextStyle(fontSize: 25),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("ประเภท: " + data['type'] ?? "N/A"),
                                    Text("อายุ: " +
                                            data['age(year)'] +
                                            " ปี " +
                                            data['age(month)'] +
                                            " เดือน " ??
                                        "N/A"),
                                    //Text(data['age(month)'] ?? "N/A"),
                                    Text("พันธ์: " + data['species'] ?? "N/A"),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("ยืนยันการลบ"),
                                              content: Text(
                                                  "คุณต้องการลบรายการนี้หรือไม่?"),
                                              actions: [
                                                TextButton(
                                                  child: Text("ยกเลิก"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("ยืนยัน"),
                                                  onPressed: () {
                                                    // สร้างตัวแปร ref เพื่อเข้าถึงเอกสารที่ต้องการลบ
                                                    final ref =
                                                        subCollectionSnapshot
                                                            .data!
                                                            .docs[index]
                                                            .reference;

                                                    // ลบเอกสารออกจาก Firestore
                                                    ref.delete();

                                                    // ลบรายการที่แสดงใน ListView
                                                    setState(() {
                                                      subCollectionSnapshot
                                                          .data!.docs
                                                          .removeAt(index);
                                                    });

                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                // ในส่วนของการเลือกร้าน
                                onTap: () {}),
                          ),
                        );
                      })),
            );
            // ListView.builder(
            //   itemCount: subCollectionSnapshot.data!.docs.length,
            //   itemBuilder: (context, index) {
            //     final data = subCollectionSnapshot.data!.docs[index].data()
            //         as Map<String, dynamic>;
            //     return ListTile(
            //       title: Text(data['name'] ?? "N/A"),
            //       subtitle: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(data['type'] ?? "N/A"),
            //           Text(data['age(year)'] ?? "N/A"),
            //           Text(data['age(month)'] ?? "N/A"),
            //           Text(data['species'] ?? "N/A"),
            //         ],
            //       ),
            //     );
            //   },
            // );
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
                      color: navItems.indexOf(e) == 2
                          ? Styles.highlightColor
                          : null),
                  Text(
                    e['text'],
                    style: TextStyle(
                        fontSize: 12,
                        color: navItems.indexOf(e) == 2
                            ? Styles.highlightColor
                            : Styles.blackColor,
                        fontWeight:
                            navItems.indexOf(e) == 2 ? FontWeight.bold : null),
                  )
                ],
              ),
              onTap: () async {
                if (navItems.indexOf(e) == 0 ||
                    navItems.indexOf(e) == 1 ||
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

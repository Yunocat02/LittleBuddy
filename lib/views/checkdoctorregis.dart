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

class doctorregis extends StatefulWidget {
  const doctorregis({super.key});

  @override
  State<doctorregis> createState() => _doctorregis();
}

class _doctorregis extends State<doctorregis> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final firestore = FirebaseFirestore.instance;

  late FirebaseAuth _auth;
  final _user = Rxn<User>();
  late Stream<User?> _authStateChanges;

 
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
        title: const Text('หมอที่ต้องการลงทะเบียนกับเรา'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
  stream: firestore.collection('clinicreport')
    .where('uid', isNotEqualTo: null) // กรอง document ที่มี field uid ไม่เท่ากับ null
    .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return const Center(child: Text('เกิดข้อผิดพลาด'));
    }
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
      // บอกลักษณะกล่อง
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20)),
      height: MediaQuery.of(context).size.height *
          1, // ตั้งค่าความสูงของ Container เป็น 40% ของความสูงของหน้าจอ
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              // จำนวนสัตว์ที่แสดง
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                // ดึงข้อมูล
                final data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    // กรอบของแต่ละรายการ
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromARGB(255, 192, 247, 248)),
                    // เนื้อใน
                    child: ListTile(
                        title: Text(
                          "ชื่อ: " + data['name'] ?? "N/A",
                          style: TextStyle(fontSize: 25),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("รักษาสัตว์ประเภทไหนบ้าง: " +
                                    data['description'] +
                                    "เวลาทำการ" +
                                    data['openingTime'] +
                                    "" ??
                                "N/A"),
                            Text("url: " + data['pdfUrl'] ?? "N/A"),
                          ],
                        ),
                        // ในส่วนของการเลือกร้าน
                        onTap: () {}),
                  ),
                );
              })),
    );
  },
),
      
    );
  }
}

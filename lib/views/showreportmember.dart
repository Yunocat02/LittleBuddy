// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:LittleBuddy/views/datareport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/styles.dart';
import 'PDF_view.dart';
import 'clinic_view.dart';
import 'datareportviewsmember.dart';
import 'help_view.dart';
import 'home.dart';
import 'nextpage.dart';

class showdatareportmem extends StatefulWidget {
  const showdatareportmem({
    Key? key,
    this.doctorid,this.index, required petid,
  }) : super(key: key);
  final String? doctorid;
  final String? index;
  @override
  State<showdatareportmem> createState() => _showdatareportmem();
}

class _showdatareportmem extends State<showdatareportmem> {
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
    String? doctorid=widget.doctorid.toString();
    String? petid=widget.index;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลการรักษาสัตว์ที่ลงทะเบียนกับคลินิก'),
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
        stream:  firestore
            .collection('connect')
            .doc(doctorid).collection('datareport')
            .where('userid',isEqualTo: getuser()?.uid)
             // กรอง document ที่มี field uid ไม่เท่ากับ null
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            height: MediaQuery.of(context).size.height *
                1, // ตั้งค่าความสูงของ Container เป็น 40% ของความสูงของหน้าจอ
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    // จำนวนสัตว์ที่แสดง
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      // ดึงข้อมูล
                      final data = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                       
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                            // กรอบของแต่ละรายการ
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 192, 247, 248)),
                            // เนื้อใน
                            child: ListTile(
                                title: FutureBuilder<DocumentSnapshot>(
                                future: firestore.collection('userdatabase').doc(data['userid']).get(),
  builder: (context, userSnapshot) {
    if (userSnapshot.hasData) {
      final userDataMap = userSnapshot.data!.data() as Map<String, dynamic>;
      final userName = userDataMap['username'];
      final String petid=data['petid'].replaceAll(' ', '');
      return FutureBuilder<DocumentSnapshot>(
        future: firestore.collection('petreport').doc(data['userid']).collection('0001').doc(petid). get(),
        builder: (context, petSnapshot) {
          if (petSnapshot.hasData) {
            final petDataMap = petSnapshot.data!.data() as Map<String, dynamic>;
            final petName = petDataMap['name'];
            return Column(
              children: [
                
                Text("ชื่อสัตว์เลี้ยง: $petName"),
                Text("ชื่อเจ้าของ: $userName"),
              ],
            );
          }
          return const SizedBox();
        },
      );
    }
    return const SizedBox();
  },
),

                   subtitle: Column(
  children: [ 
    
    Text("วันนัดรับสัตว์เลี้ยง: " + data['appmtime'] ?? "N/A"),
    Text("วันที่มารักษา: " + data['datetime'] ?? "N/A"),
    Text("วิธีการรักษา: " + data['remedy'] ?? "N/A"),
  ],
),

                              onTap: () {
                               
                                
                              },
                            )),
                      );
                    })),
          );
        },
      ),
    );
  }
}

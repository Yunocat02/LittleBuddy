import 'package:LittleBuddy/views/wait_doctor.dart';
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

class selectpets extends StatefulWidget {
  const selectpets({super.key});

  @override
  State<selectpets> createState() => _selectpets();
}

class _selectpets extends State<selectpets> {
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
        backgroundColor: Color.fromARGB(255, 130, 219, 241),
        title: const Text('กรุณาเลือกสัตว์ที่จะทำการรักษา'),
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
            .collection('petreport') // ชื่อตาราง
            .doc(getuser()?.uid) // เอา id เก็บแบบ doc
            .collection("0001")
            .where('status',isNotEqualTo: 'connected') // id sub field ที่แต่ย่อยมาตอน addpet
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
                                // ในส่วนของการเลือกร้าน
                                onTap: () {
                                  String useruid=getuser()!.uid.toString();
                                  print(index);
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                          builder: (context) => waitdoctor(
                                          uidpet:subCollectionSnapshot.data!.docs[index].id,
                                          useruid: useruid
                                          ),
                                        ),
                                        
                                    );
                                }),
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
      
            );
          }
        
    
  }


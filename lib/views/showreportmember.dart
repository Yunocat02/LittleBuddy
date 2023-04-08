// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';





class showdatareportmem extends StatefulWidget {
  const showdatareportmem({
    Key? key,
    this.doctorid,
    this.index,
    this.petid,
  }) : super(key: key);
  final String? doctorid;
  final String? index;
  final String? petid;
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
    print(widget.petid);
    print(widget.doctorid);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 130, 219, 241),
        title: Text('Connected Pets'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore
            .collection('connect')
            .doc(widget.doctorid)
            .collection('datareport')
            .doc(widget.petid)
            .snapshots(),
        builder: (context, snapshot) {
          //if (!snapshot.hasData) {
          //return const Center(child: CircularProgressIndicator());
          //}
          if (snapshot.data == null) {
            return const Center(child: Text('ทาง Clinic ยังไม่ได้ใส่ข้อมูล'));
          }
          else if (snapshot.data!.data() == null) {
            return const Center(child: Text('ทาง Clinic ยังไม่ได้ใส่ข้อมูล'));
          } 
          else if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(255, 192, 247, 248)),
                child: ListView(
                  children: [
                    ListTile(
                      title: FutureBuilder<DocumentSnapshot>(
                        future: firestore
                            .collection('userdatabase')
                            .doc(data['userid'])
                            .get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.hasData) {
                            final userDataMap = userSnapshot.data!.data()
                                as Map<String, dynamic>;
                            final userName = userDataMap['username'];
                            final String petid =
                                data['petid'].replaceAll(' ', '');
                            return FutureBuilder<DocumentSnapshot>(
                              future: firestore
                                  .collection('petreport')
                                  .doc(data['userid'])
                                  .collection('0001')
                                  .doc(petid)
                                  .get(),
                              builder: (context, petSnapshot) {
                                if (petSnapshot.hasData) {
                                  final petDataMap = petSnapshot.data!.data()
                                      as Map<String, dynamic>;
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
                      subtitle: FutureBuilder<DocumentSnapshot>(
  future: firestore
      .collection('clinicreport')
      .doc(widget.doctorid)
      .get(),
  builder: (context, clinicSnapshot) {
    if (clinicSnapshot.hasData) {
      final clinicDataMap = clinicSnapshot.data!.data() as Map<String, dynamic>;
      final clinicPhone = clinicDataMap['phone'];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          Text("วันนัดรับสัตว์เลี้ยง: " + data['appmtime'] ?? "N/A"),
          Text("วันที่มารักษา: " + data['datetime'] ?? "N/A"),
          Text("วิธีการรักษา: " + data['remedy'] ?? "N/A"),
          Text("เบอร์โทรติดต่อคลินิก: $clinicPhone"),
        ],
      );
    }
    return const SizedBox();
  },
),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

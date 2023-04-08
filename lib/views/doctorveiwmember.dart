import 'package:LittleBuddy/views/datareport.dart';
import 'package:LittleBuddy/views/showdatareport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../utils/styles.dart';
import 'chatpage.dart';
import 'help_view.dart';
import 'home.dart';
import 'login_view.dart';
import 'mypets_view.dart';
late String _username = "";
class doctorviewmember extends StatefulWidget {
  const doctorviewmember({Key? key});

  @override
  State<doctorviewmember> createState() => _doctorviewmember();
}

class _doctorviewmember extends State<doctorviewmember> {
  List navItems = [
      {
        'text': 'Adopt',
        'icon': 'assets/nav_icons/pill_icon.svg',
      },
      {
        'text': 'Clinic',
        'icon': 'assets/nav_icons/heart_icon.svg',
      },
      {
        'text': 'Pets',
        'icon': 'assets/nav_icons/vet_icon.svg',
      },
      {
        'text': 'Help',
        'icon': 'assets/nav_icons/help_icon.svg',
        'page': const Helpview()
      },
    ];

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  late FirebaseAuth _auth;
  final _user = Rxn<User>();
  late Stream<User?> _authStateChanges;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
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
        title: const Text('ลูกค้าที่รักษากับเราอยู่'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('connect')
            .doc(getuser()?.uid)
            .collection('userconnect')
            .where('status',
                isEqualTo:
                    'confirm') // กรอง document ที่มี field uid ไม่เท่ากับ null
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
                                future: firestore
                                    .collection('userdatabase')
                                    .doc(data['userid'])
                                    .get(),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.hasData) {
                                    final userDataMap = userSnapshot.data!
                                        .data() as Map<String, dynamic>;
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
                                          final petDataMap = petSnapshot.data!
                                              .data() as Map<String, dynamic>;
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
                                  Text("อาการ: " + data['symptom'] ?? "N/A"),
                                  Text("แพ้ยา: " + data['medic'] ?? "N/A"),
                                  Text("วันที่เกิดอาการ: " +
                                          data['datetimesym'] ??
                                      "N/A"),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.chat),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => chatpage(
                                            doctorid: getuser()!.uid,
                                            petid: data['petid'].toString(),
                                            email: _username,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => datareport(
                                            userid: data['userid'].toString(),
                                            petid: data['petid'].toString(),
                                            doctorid: getuser()?.uid)));
                              },
                            )),
                      );
                    })),
          );
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
                if (navItems.indexOf(e) == 3) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => e['page']));
                }
                if (navItems.indexOf(e) == 2) {
                  if (globalRole?.role == 'M') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Mypets()),
                    );
                  }
                  if (globalRole?.role == 'D') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => showdatareport()),
                    );
                  }
                  if (globalRole?.role == 'A') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Helpview()),
                    );
                  }
                }

                if (navItems.indexOf(e) == 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
  Future<void> _loadUserInfo() async {
    final userId = auth.currentUser?.uid;

    if (userId != null) {
      final userDoc =
          await firestore.collection('userdatabase').doc(userId).get();
      final userData = userDoc.data() as Map<String, dynamic>?;
      setState(() {
        //_appmtime = userData?['appm. time'] as Timestamp;

        _username = userData?['username'] ?? 'N/A';

        //_content = userData?['content'] ?? 'N/A';
        //_datetime = userData?['datetime'] as Timestamp;
        //_idpet = userData?['idpet'] ?? 'N/A';
        //_namepet = userData?['namepet'] ?? 'N/A';
        //_remedy = userData?['remedy'] ?? 'N/A';
        //_url = userData?['url'] ?? 'N/A';
      });
    }
  }
}

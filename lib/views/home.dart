import 'package:LittleBuddy/views/adminviewdoctor.dart';
import 'package:LittleBuddy/views/adminviewmember.dart';
import 'package:LittleBuddy/views/datareportviewsmember.dart';
import 'package:LittleBuddy/views/doctorveiwmember.dart';
import 'package:LittleBuddy/views/petconnect.dart';
import 'package:LittleBuddy/views/showdatareport.dart';
import 'package:LittleBuddy/widgets/pet_card2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/layouts.dart';
import '../utils/styles.dart';
import '../widgets/animated_title.dart';
import '../widgets/pet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'addclinic_view.dart';
import 'addpet_view.dart';
import 'help_view.dart';
import 'login_view.dart';
import 'mypets_view.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    void showAlert() {
      QuickAlert.show(
          context: context, title: "Please login", type: QuickAlertType.error);
    }

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
        'page': const Mypets()
      },
      {
        'text': 'Help',
        'icon': 'assets/nav_icons/help_icon.svg',
        'page': const Helpview()
      },
    ];
    final size = Layouts.getSize(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Color.fromARGB(255, 130, 219, 241),
        centerTitle: true,
        leading: 
        IconButton(
          onPressed: () async {
            if ( globalRole?.role == 'M') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPet()),
              );
            } else if (globalRole?.role == 'D') {
              // ตรวจสอบว่ามีข้อมูลใน Firestore หรือไม่
              try {
                final clinicReportDoc = await FirebaseFirestore.instance
                    .collection('clinicreport')
                    .doc(uid)
                    .get();

                if (!clinicReportDoc.exists) {
                  // ไม่มีข้อมูลใน Firestore
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Addclinic()),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("แก้ไขข้อมูลร้าน"),
                        content:
                            Text("คุณต้องการที่จะแก้ไขข้อมูลร้านใช่หรือไม่?"),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Addclinic()),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } catch (e) {
                print('Error: $e');
              }
            } 
            else if(globalRole?.role == 'A'){
              return;
            }
            else {
              showAlert();
            }
          },
          icon: globalRole?.role == 'M' || globalRole?.role == null
  ? Icon(Icons.pets) // กรณี role เป็น M หรือไม่มีค่า role
  : globalRole?.role == 'A'
    ? SizedBox() // กรณี role เป็น A
    : Icon(Icons.add),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (globalRole?.role == 'A' ||
                  globalRole?.role == 'M' ||
                  globalRole?.role == 'D') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => datareportviewsmember()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              }
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          const AnimatedTitle(title: 'What are you looking for?'),
          const Gap(10),
          Row(
            children: [
              PetCard(
                petPath: 'assets/svg/robot.svg',
                petName: 'ChatBot',
                height: 68,
              ),
              Gap(28),
              if (globalRole?.role == 'D' || globalRole?.role == 'A')
                PetCard2(
                  petPath: 'assets/svg/mail2.svg',
                  petName: 'Mail',
                  height: 68,
                )
              else if (globalRole?.role == 'M' || globalRole?.role == '')
                PetCard2(
                  petPath: 'assets/svg/hospital.svg',
                  petName: 'Clinic finder',
                  height: 68,
                )
              else
                PetCard2(
                  petPath: 'assets/svg/hospital.svg',
                  petName: 'Clinic finder',
                  height: 68,
                )
            ],
          ),
          const Gap(25),
          const AnimatedTitle(title: 'Community'),
          const Gap(10),
          GestureDetector(
            onTap: () => launch('https://www.facebook.com/NIRVXSH'),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, _) {
                return Stack(
                  children: [
                    Container(
                      height: 150,
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        children: [
                          Container(
                            height: 135,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Styles.bgColor,
                                borderRadius: BorderRadius.circular(27)),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(
                                right: 12,
                                left: Layouts.getSize(context).width * 0.37,
                                top: 15,
                                bottom: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Join our\ncommunity',
                                  style: TextStyle(
                                      fontSize: value * 27,
                                      fontWeight: FontWeight.bold,
                                      color: Styles.blackColor,
                                      height: 1),
                                ),
                                const Gap(12),
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 1500),
                                  opacity: value,
                                  child: Text(
                                    'Share your pet moments with other pet parents.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Styles.blackColor,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            right: value * 12,
                            top: value * 12,
                            child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Styles.bgWithOpacityColor,
                                child: SvgPicture.asset(
                                  'assets/svg/arrow_right.svg',
                                  height: value * 14,
                                  width: value * 14,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 12,
                      bottom: 0,
                      child: SvgPicture.asset(
                        'assets/svg/person.svg',
                        height: value * 150,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Gap(25),
        ],
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
                      color: navItems.indexOf(e) == 0
                          ? Styles.highlightColor
                          : null),
                  Text(
                    e['text'],
                    style: TextStyle(
                        fontSize: 12,
                        color: navItems.indexOf(e) == 0
                            ? Styles.highlightColor
                            : Styles.blackColor,
                        fontWeight:
                            navItems.indexOf(e) == 0 ? FontWeight.bold : null),
                  )
                ],
              ),
              onTap: () async {
                if (navItems.indexOf(e) == 3) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Helpview()),
                  );
                }

                if (navItems.indexOf(e) == 2) {
                  if (globalRole?.role == 'M') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Mypets()),
                    );
                  } else if (globalRole?.role == 'D') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => showdatareport()),
                    );
                  } else if (globalRole?.role == 'A') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => adminviewdoctor()),
                    );
                  } else {
                    showAlert();
                  }
                }

                if (navItems.indexOf(e) == 1) {
                  if (globalRole?.role == 'M') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => petconnect()),
                    );
                  } else if (globalRole?.role == 'D') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => doctorviewmember()),
                    );
                  } else if (globalRole?.role == 'A') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => adminviewmember()),
                    );
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

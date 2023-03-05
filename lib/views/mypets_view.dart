import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../utils/styles.dart';
import 'clinic_view.dart';
import 'datareportviewsmember.dart';
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
      'text': 'Clinix',
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
      'page': datareportviewsmember()
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
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('petreport')
            .doc(getuser()?.uid)
            .collection("0001")
            .snapshots(),
        builder: (context, subCollectionSnapshot) {
          if (subCollectionSnapshot.hasData) {
            return ListView.builder(
              itemCount: subCollectionSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = subCollectionSnapshot.data!.docs[index].data()
                    as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['name'] ?? "N/A"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['type'] ?? "N/A"),
                      Text(data['age(year)'] ?? "N/A"),
                      Text(data['age(month)'] ?? "N/A"),
                      Text(data['species'] ?? "N/A"),
                    ],
                  ),
                );
              },
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
                      color: navItems.indexOf(e) == 3
                          ? Styles.highlightColor
                          : null),
                  Text(
                    e['text'],
                    style: TextStyle(
                        fontSize: 12,
                        color: navItems.indexOf(e) == 3
                            ? Styles.highlightColor
                            : Styles.blackColor,
                        fontWeight:
                            navItems.indexOf(e) == 3 ? FontWeight.bold : null),
                  )
                ],
              ),
              onTap: () async {
                if (navItems.indexOf(e) == 0 ||
                    navItems.indexOf(e) == 1 ||
                    navItems.indexOf(e) == 2 ||
                    navItems.indexOf(e) == 3) {
                  Navigator.push(
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

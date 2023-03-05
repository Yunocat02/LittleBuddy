import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import '../utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../views/map_view.dart';

class PetCard2 extends StatefulWidget {
  final double? height;
  final String petPath;
  final String petName;
  const PetCard2(
      {Key? key, required this.petPath, required this.petName, this.height})
      : super(key: key);

  @override
  State<PetCard2> createState() => _PetCard2State();
}

class _PetCard2State extends State<PetCard2> {
  @override
  void initState() {
    super.initState();
  }

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

    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () async {
          if (user != null) {
            final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
                await _db.collection('userdatabase').doc(uid).get();
            if (userSnapshot.exists) {
              String role = userSnapshot.get('role');
              if (role == 'A' || role == 'M' || role == 'D') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Mapnaja()));
              }
            }
          } else {
            showAlert();
          }
        },
        child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(seconds: 1),
            builder: (context, value, _) {
              return Container(
                width: double.infinity,
                height: 205.0 * value,
                decoration: BoxDecoration(
                    color: Styles.bgColor,
                    borderRadius: BorderRadius.circular(27)),
                child: FittedBox(
                  child: Column(
                    children: [
                      const Gap(15),
                      SizedBox(
                          height: 95.0 * value,
                          child: SvgPicture.asset(widget.petPath,
                              height: widget.height ?? 95)),
                      const Gap(10),
                      Text(
                        widget.petName,
                        style: TextStyle(
                            color: Styles.highlightColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const Gap(5),
                      MaterialButton(
                        onPressed: () async {
                          if (user != null) {
                            final DocumentSnapshot<Map<String, dynamic>>
                                userSnapshot = await _db
                                    .collection('userdatabase')
                                    .doc(uid)
                                    .get();
                            if (userSnapshot.exists) {
                              String role = userSnapshot.get('role');
                              if (role == 'A' || role == 'M' || role == 'D') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Mapnaja()),
                                );
                              }
                            }
                          } else {
                            showAlert();
                          }
                        },
                        color: Styles.bgWithOpacityColor,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Enter',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Styles.highlightColor,
                              ),
                            ),
                            const Gap(5),
                            SvgPicture.asset(
                              'assets/svg/arrow_right.svg',
                              height: 14,
                              width: 14,
                            ),
                          ],
                        ),
                      ),
                      const Gap(5),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

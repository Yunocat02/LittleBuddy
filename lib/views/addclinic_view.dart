import 'package:LittleBuddy/views/mypets_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../widgets/back_button.dart';

class Addclinic extends StatefulWidget {
  const Addclinic({Key? key}) : super(key: key);

  @override
  State<Addclinic> createState() => _AddclinicState();
}

class _AddclinicState extends State<Addclinic> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController ageyearController = TextEditingController();
  TextEditingController agemonthController = TextEditingController();
  TextEditingController speciesController = TextEditingController();
  late String uid;
  void showAlert() {
    QuickAlert.show(
        context: context, title: "Add success", type: QuickAlertType.success);
  }

  Future<void> addPetReport() async {
    final user = auth.currentUser;
    if (user != null) {
      uid = user.uid;
      final DocumentReference userDocRef =
          firestore.collection('clinicreport').doc(uid);
      final CollectionReference petReportCollectionRef =
          userDocRef.collection('0002');

      final Map<String, dynamic> data = {
        'name': nameController.text,
        'age(year)': ageyearController.text,
        'age(month)': agemonthController.text,
        'type': typeController.text,
        'species': speciesController.text,
      };

      petReportCollectionRef.add(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ลงทะเบียนร้านของคุณ")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "ชื่อร้าน",
                    hintText: "ตัวอย่าง : LovecatClinic"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดใส่ชื่อร้าน';
                  }
                  return null;
                },
                controller: nameController,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "เวลาเปิด", hintText: "ตัวอย่าง : 9:00"),
                      controller: ageyearController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'โปรดใส่เวลาเปิด';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "เวลาปิด", hintText: "ตัวอย่าง : 22:00"),
                      controller: agemonthController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'โปรดใส่เวลาปิด';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "รับสัตว์ประเภท",
                    hintText: "ตัวอย่าง : สุนัข,แมว"),
                controller: typeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดใส่ประเภทสัตว์';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "เพิ่มเติม (Description)",
                    hintText: '''ตัวอย่าง : 
รับทำหมัน 
รับตรวจวินิจฉัยทางรังสีวิทยา'''),

                controller: speciesController,
                maxLines: 3, // กำหนดให้สามารถใส่ข้อความได้สูงสุด 3 บรรทัด
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดใส่พันธุ์';
                  }
                  return null;
                },
              ),
            ),
            Stack(
              children: [
                Positioned(
                  left: 15,
                  top: 50,
                  child: PetBackButton(),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addPetReport();
                      showAlert();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return Mypets();
                      }));
                    }
                  },
                  child: const Text('submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

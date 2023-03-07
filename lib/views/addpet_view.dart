import 'package:LittleBuddy/views/mypets_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../widgets/back_button.dart';

class AddPet extends StatefulWidget {
  const AddPet({Key? key}) : super(key: key);

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
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
      final DocumentReference userDocRef = firestore.collection('petreport').doc(uid);
      final CollectionReference petReportCollectionRef = userDocRef.collection('0001');

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
      appBar: AppBar(title: const Text("เพิ่มสัตว์เลี้ยงของคุณ")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "ชื่อสัตว์", hintText: "ตัวอย่าง : แจ้"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดใส่ชื่อสัตว์';
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
                          labelText: "อายุ (ปี)", hintText: "ตัวอย่าง : 2"),
                          controller: ageyearController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'โปรดใส่อายุ (ปี)';
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
                          labelText: "อายุ (เดือน)", hintText: "ตัวอย่าง : 3"),
                          controller: agemonthController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'โปรดอายุ (เดือน)';
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
                    labelText: "ประเภท", hintText: "ตัวอย่าง : สุนัข"),
                     controller: typeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดใส่ประเภท';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "พันธุ์", hintText: "ตัวอย่าง : Corki"),
                    controller: speciesController,
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
                      // Add your onPressed logic here
                    }
                    addPetReport();
                    showAlert();
                    Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return Mypets();
                      }));
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

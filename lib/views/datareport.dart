// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:LittleBuddy/views/showdatareport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../widgets/back_button.dart';

class datareport extends StatefulWidget {
  const datareport({
    Key? key,
    required this.userid,
    required this.petid,
    this.doctorid,
  }) : super(key: key);

  final String userid;
  final String petid;
  final String? doctorid;
  @override
  State<datareport> createState() => _datareportstate();
}

class _datareportstate extends State<datareport> {
  final _formKey = GlobalKey<FormState>();
  Future<void> showAlert() async {
    await QuickAlert.show(
        context: context, title: "Add success", type: QuickAlertType.success);
  }
  TextEditingController remedyController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController ageyearController = TextEditingController();
  TextEditingController agemonthController = TextEditingController();
  TextEditingController speciesController = TextEditingController();
  TextEditingController dateCtl1 = TextEditingController();
  TextEditingController dateCtl2 = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User? user = auth.currentUser;
  late String? uid = user!.uid;

  @override
  Widget _dateTimePicker1() {
    return TextFormField(
      controller: dateCtl1,
      decoration: InputDecoration(
        labelText: 'วันที่มารักษา',
        hintText: 'Ex. Insert your date and time',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'โปรดใส่วันที่มารักษา';
        }
        return null;
      },
      onTap: () async {
        // แสดง DatePicker และรอผู้ใช้เลือกวัน
        DateTime date = DateTime.now();
        TimeOfDay time = TimeOfDay(hour: 0, minute: 0);
        FocusScope.of(context).requestFocus(new FocusNode());

        date = (await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        ))!;

        // แสดง TimePicker และรอผู้ใช้เลือกเวลา
        time = (await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: 0, minute: 0),
        ))!;

        // อัพเดตค่าใน controller
        dateCtl1.text =
            '${DateFormat('yyyy-MM-dd').format(date)} ${time.format(context)}';
      },
    );
  }

  Widget _dateTimePicker2() {
    return TextFormField(
      controller: dateCtl2,
      decoration: InputDecoration(
        labelText: 'วันนัดรับสัตว์เลี้ยง',
        hintText: 'Ex. Insert your date and time',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'โปรดเลือกวันนัดรับสัตว์เลี้ยง';
        }
        return null;
      },
      onTap: () async {
// แสดง DatePicker และรอผู้ใช้เลือกวัน
        DateTime date = DateTime.now();
        TimeOfDay time = TimeOfDay(hour: 0, minute: 0);
        FocusScope.of(context).requestFocus(new FocusNode());

        date = (await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        ))!;

        // แสดง TimePicker และรอผู้ใช้เลือกเวลา
        time = (await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: 0, minute: 0),
        ))!;

        // อัพเดตค่าใน controller
        dateCtl2.text =
            '${DateFormat('yyyy-MM-dd').format(date)} ${time.format(context)}';
      },
    );
  }

  Widget build(BuildContext context) {
    String userId = widget.userid;
    String petid = widget.petid;

    Future<void> adddatareport() async {
      if (user != null) {
        final DocumentReference<Map<String, dynamic>> userDocRef = firestore
            .collection('connect')
            .doc(uid)
            .collection('datareport')
            .doc(petid.toString());
        /*final CollectionReference petReportCollectionRef =
          userDocRef.collection('0001');*/

        final Map<String, dynamic> data = {
          'remedy': remedyController.text.trim(),
          'datetime': dateCtl1.text,
          'appmtime': dateCtl2.text,
          'url': urlController.text,
          'userid': userId.toString(),
          'petid': petid.toString()
        };
        await userDocRef.set(data);
      }
    }

    String Docter = '';

    return Scaffold(
      appBar: AppBar(title: const Text("บันทึกการรักษา")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _dateTimePicker1(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "วิธีการรักษา",
                    hintText: "ตัวอย่าง : ฉีดยาแก้ปวด"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดกรอกวิธีการรักษา';
                  }
                  return null;
                },
                controller: remedyController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _dateTimePicker2(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: "URL", hintText: ""),
                validator: (value) {
                  return null;
                },
                controller: urlController,
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Add your onPressed logic here
                      adddatareport();
                      await showAlert();
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => showdatareport()),
                    );
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

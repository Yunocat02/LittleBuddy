import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../widgets/back_button.dart';

class datareport extends StatefulWidget {
  const datareport({Key? key}) : super(key: key);

  @override
  State<datareport> createState() => _datareportstate();
}

class _datareportstate extends State<datareport> {
  
  final _formKey = GlobalKey<FormState>();
  
 
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController ageyearController = TextEditingController();
  TextEditingController agemonthController = TextEditingController();
  TextEditingController speciesController = TextEditingController();
  TextEditingController dateCtl = TextEditingController();

  
  @override
  Widget _dateTimePicker1() {
  return TextFormField(
    controller: dateCtl,
    decoration: InputDecoration(
      labelText: 'วันที่มารักษา',
      hintText: 'Ex. Insert your date and time',
    ),
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
      dateCtl.text =
          '${DateFormat('yyyy-MM-dd').format(date)} ${time.format(context)}';
    },
  );
}
Widget _dateTimePicker2() {
  return TextFormField(
    controller: dateCtl,
    decoration: InputDecoration(
      labelText: 'วันนัดรับสัตว์เลี้ยง',
      hintText: 'Ex. Insert your date and time',
    ),
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
      dateCtl.text =
          '${DateFormat('yyyy-MM-dd').format(date)} ${time.format(context)}';
    },
  );
}
  
  Widget build(BuildContext context) { 
    
  String Docter='';
  
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
                    labelText: "วิธีการรักษา", hintText: "ตัวอย่าง : ฉีดยาแก้ปวด"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดกรอกวิธีการรักษา';
                  }
                  return null;
                },
                controller: nameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _dateTimePicker2(),
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

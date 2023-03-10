import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../widgets/back_button.dart';

class waitdoctor extends StatefulWidget {
  const waitdoctor({Key? key}) : super(key: key);

  @override
  State<waitdoctor> createState() => _waitdoctorstate();
}

class _waitdoctorstate extends State<waitdoctor> {
  
  final _formKey = GlobalKey<FormState>();
 

  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController ageyearController = TextEditingController();
  TextEditingController agemonthController = TextEditingController();
  TextEditingController speciesController = TextEditingController();
  TextEditingController dateCtl = TextEditingController();

  
  @override
  Widget _dateTimePicker() {
  return TextFormField(
    controller: dateCtl,
    decoration: InputDecoration(
      labelText: 'Date and Time',
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
      appBar: AppBar(title: const Text("ลงทะเบียนกับคลินิก")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "กรอกอาการป่วยของสัตว์เลี้ยง", hintText: "ตัวอย่าง : ไอ ไข้สูง"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดกรอกอาการ';
                  }
                  return null;
                },
                controller: nameController,
              ),
            ),          
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _dateTimePicker(),
            ),Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "ยาที่แพ้", hintText: "ตัวอย่าง : พาราเซตตามอล"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดกรอกยาที่แพ้';
                  }
                  return null;
                },
                controller: nameController,
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

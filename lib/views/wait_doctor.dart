// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:LittleBuddy/views/map_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../widgets/back_button.dart';

class waitdoctor extends StatefulWidget {
  final String uidpet;
  final String useruid;

  

  const waitdoctor({
    Key? key, required this.uidpet, required this.useruid, }) : super(key: key);
    

  @override
  State<waitdoctor> createState() => _waitdoctorstate();
}

class _waitdoctorstate extends State<waitdoctor> {
  
  final _formKey = GlobalKey<FormState>();
 

  TextEditingController symptomController = TextEditingController();
  TextEditingController medicController = TextEditingController();
  TextEditingController datetimeController = TextEditingController();
  TextEditingController agemonthController = TextEditingController();
  TextEditingController speciesController = TextEditingController();
  TextEditingController dateCtl = TextEditingController();
  
  
  @override
  Widget _dateTimePicker() {
  return TextFormField(
    controller: dateCtl,
    decoration: InputDecoration(
      labelText: 'กรอกเวลาที่เริ่มสังเกตุอาการ',
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
print("uidpet = ${widget.uidpet}");
  print("useruid = ${widget.useruid}");
    String uidpet=widget.uidpet;
  String Docter='';
    return Scaffold(
      appBar: AppBar(title: const Text("ลงทะเบียนกับคลินิก"),backgroundColor: Color.fromARGB(255, 130, 219, 241),),
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
                controller: symptomController,
              ),
            ),          
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _dateTimePicker()
              
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
                controller: medicController,
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
                     
                    
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                          builder: (context) => Mapnaja(
                                          uidpet:widget.uidpet,
                                          useruid: widget.useruid,
                                          symptom:symptomController.text,
                                          date: dateCtl.text,
                                          medic: medicController.text,

                                          ),
                                        ),
                                        
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

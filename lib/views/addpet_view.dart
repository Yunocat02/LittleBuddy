import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../widgets/back_button.dart';
import 'package:LittleBuddy/model/petmodel.dart';

class AddPet extends StatefulWidget {
  const AddPet({Key? key}) : super(key: key);

  @override
  State<AddPet> createState() => _AddPetState();
}



class _AddPetState extends State<AddPet> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController ageyearController = TextEditingController();
  TextEditingController agemonthController = TextEditingController();
  TextEditingController speciesController = TextEditingController();
  

  late String uid;

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
      appBar: AppBar(title: const Text("ยินดีต้อนรับ สู่หน้า addpet")),
      body: Form(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "ชื่อสัตว์"),
                
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: ageyearController,
                decoration: InputDecoration(labelText: "อายุปี"),
              
              ),
            ),Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: agemonthController,
                decoration: InputDecoration(labelText: "อายุเดือน"),
               
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: typeController,
                decoration: InputDecoration(labelText: "ประเภท"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: speciesController,
                decoration: InputDecoration(labelText: "พันธุ์"),
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
                    // Add your onPressed logic here
                    addPetReport();
                  },
                  child: const Text('เพิ่ม'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  
}

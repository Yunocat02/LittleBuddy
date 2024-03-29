import 'package:LittleBuddy/views/home.dart';
import 'package:LittleBuddy/views/mypets_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:path/path.dart' as path;
import 'dart:io';
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
  late User? user = auth.currentUser;
  late String? uid = user!.uid;

  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController timecloseController = TextEditingController();
  TextEditingController timeopenController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController urlwebController = TextEditingController();
  TextEditingController urlcamController = TextEditingController();
  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  File? _pdf;
  String? _pdfUrl;
  bool isSubmit = false;
  late Reference? _storageRef;
  late File _file;

  // Function for selecting a PDF file
  Future<void> _selectPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;
    setState(() {
      _pdf = File(result.files.single.path!);
    });
  }

  // Function for uploading the selected PDF file to Firebase Storage
  Future<void> _uploadPdf() async {
    if (_pdf == null) return;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('pdfs/${_pdf!.path.split('/').last}');
    final task = storageRef.putFile(_pdf!);
    await task.whenComplete(() => print('PDF uploaded'));
    final pdfUrl = await storageRef.getDownloadURL();
    setState(() {
      _pdfUrl = pdfUrl;
    });
  }

  Future<void> addClinicreport() async {
    if (user != null) {
      final DocumentReference<Map<String, dynamic>> userDocRef =
          firestore.collection('clinicreport').doc(uid);
      /*final CollectionReference petReportCollectionRef =
          userDocRef.collection('0001');*/

      final Map<String, dynamic> data = {
        'name': nameController.text.trim(),
        'openingTime':
            '${timeopenController.text.trim()}-${timecloseController.text.trim()}',
        'petTypes': typeController.text.trim().split(','),
        'description': descriptionController.text.trim(),
        'phone':phoneController.text.trim(),
        'urlweb': urlwebController.text.trim(),
        'urlcam': urlcamController.text.trim(),
        'pdfUrl': _pdfUrl!,
        'status': 'waiting',
        'Location': GeoPoint(double.parse(_latitudeController.text),
            double.parse(_longitudeController.text))
      };
      await userDocRef.set(data);
    }
  }
  // Function for adding a new clinic to Firestore

  // Function for showing a success dialog after the clinic is added
  void _showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ลงทะเบียนสำเร็จ'),
          content: const Text('ขอบคุณสำหรับการลงทะเบียนร้านของคุณ'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  // ตัวแปรเก็บพิกัด user
  Position? _position;

  // หาพิกัด latitude, longitude
  void _getCurrentLocation() async {
    Position position = await _determinePosition(); // ขออนุญาตหาตำแหน่ง
    setState(() {
      _position = position;
    });
  }

  // ฟังก์ชั่น ขออนุญาตหาตำแหน่ง
  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    nameController.dispose();
    timeopenController.dispose();
    timecloseController.dispose();
    typeController.dispose();
    descriptionController.dispose();
    urlwebController.dispose();
    urlcamController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_position != null) {
      _latitudeController.text = _position!.latitude.toString();
      _longitudeController.text = _position!.longitude.toString();
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("ลงทะเบียนร้านของคุณ"),
          backgroundColor: Color.fromARGB(255, 130, 219, 241),
        ),
        body: SingleChildScrollView(
          child: Form(
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
                            labelText: "เวลาเปิด",
                            hintText: "ตัวอย่าง : 9:00",
                            icon: Icon(Icons.schedule),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          controller: timeopenController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'โปรดใส่เวลาเปิด';
                            }
                            return null;
                          },
                          onTap: () async {
                            // Show time picker dialog
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            // Update text field value
                            if (time != null) {
                              String hour =
                                  time.hour.toString().padLeft(2, '0');
                              String minute =
                                  time.minute.toString().padLeft(2, '0');
                              timeopenController.text = '$hour:$minute';
                            }
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
                            labelText: "เวลาปิด",
                            hintText: "ตัวอย่าง : 22:00",
                            icon: Icon(Icons.schedule),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          controller: timecloseController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'โปรดใส่เวลาปิด';
                            }
                            return null;
                          },
                          onTap: () async {
                            // Show time picker dialog
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            // Update text field value
                            if (time != null) {
                              String hour =
                                  time.hour.toString().padLeft(2, '0');
                              String minute =
                                  time.minute.toString().padLeft(2, '0');
                              timecloseController.text = '$hour:$minute';
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _latitudeController,
                          decoration: InputDecoration(labelText: 'Latitude'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _longitudeController,
                          decoration: InputDecoration(labelText: 'Longitude'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(Icons.gps_fixed),
                          onPressed: () {
                            setState(() {
                              _getCurrentLocation();
                            });
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
                        inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r"\d")), // กำหนดให้รับเฉพาะ A-Z, a-z, ก-๙, เ, แ
    ],
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

                    controller: descriptionController,
                    maxLines: 3, // กำหนดให้สามารถใส่ข้อความได้สูงสุด 3 บรรทัด
                        inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r"\d")), // กำหนดให้รับเฉพาะ A-Z, a-z, ก-๙, เ, แ
    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'โปรดใส่พันธุ์';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "เบอร์โทรร้าน",
                        hintText: "ตัวอย่าง :02-xxxx-xxxx"),
                    controller: phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'โปรดใส่เบอร์โทรร้าน';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "URL Webboard",
                        hintText: 'https://www.facebook.com/'),
                    controller: urlwebController,
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "URL กล้อง IP Cam",
                        hintText: 'http://yunocat.thddns.net//videostream.cgi'),
                    controller: urlcamController,
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    icon: Icon(Icons.attach_file),
                    label: Text('เลือกไฟล์ PDF'),
                    onPressed: () async {
                      // ใช้ package file_picker เพื่อเปิดหน้าจอเลือกไฟล์ PDF
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );

                      // ตรวจสอบว่า user เลือกไฟล์หรือไม่
                      if (result != null) {
                        File file = File(result.files.single.path!);
                        String fileName = path.basename(file.path);
                        _file = file;
                        // อัพโหลดไฟล์ PDF ไปยัง Firestore
                        try {
                          // สร้าง reference ของไฟล์ใน Firestore
                          Reference storageReference = FirebaseStorage.instance
                              .ref('doctor/certificate')
                              .child('$uid/${fileName}');

                          _storageRef = storageReference;
                          // อัพโหลดไฟล์ PDF ไปยัง Firestore
                          //await storageReference.putFile(file);

                          // ดึง URL ของไฟล์ PDF จาก Firestore
                          //_pdfUrl = await storageReference.getDownloadURL();

                          // บันทึก URL ของไฟล์ PDF ใน Firestore database

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('อัพโหลดไฟล์ PDF เรียบร้อย'),
                            ),
                          );
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('เกิดข้อผิดพลาดขณะอัพโหลดไฟล์ PDF'),
                            ),
                          );
                          print(error);
                        }
                        isSubmit = false;
                      }
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
                      onPressed: () async {
                        if (_file == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('โปรดเลือกไฟล์ PDF'),
                            ),
                          );
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          await _storageRef?.putFile(_file);
                          _pdfUrl = await _storageRef!.getDownloadURL();
                          addClinicreport();

                          isSubmit = true;
                          //showAlert();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return Home();
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
        ));
  }
}

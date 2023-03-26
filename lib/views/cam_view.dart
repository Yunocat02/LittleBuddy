import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class cam extends StatefulWidget {
  const cam({Key? key, required this.doctorid, required this.petid}) : super(key: key);

  final String doctorid;
  final String petid;

  @override
  State<cam> createState() => _camState();
}
class _camState extends State<cam> {
  late String initialUrl;
  late String doctorid;

  @override
  void initState() {
    super.initState();
    doctorid = widget.doctorid;
    getCamUrl();
  }

  Future<void> getCamUrl() async {
    final clinicReportDoc = await FirebaseFirestore.instance
        .collection('clinicreport')
        .doc(doctorid)
        .get();
    final camUrl = clinicReportDoc.get('camurl') as String;
    setState(() {
      initialUrl = camUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera ของทางร้าน"),
        backgroundColor: Color.fromARGB(255, 130, 219, 241),
      ),
      body: initialUrl == null
          ? Center(child: CircularProgressIndicator())
          : WebView(initialUrl: initialUrl),
    );
  }
}

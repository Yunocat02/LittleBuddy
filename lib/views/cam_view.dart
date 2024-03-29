import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool isLoading = true;

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
    var camUrl = clinicReportDoc.get('urlcam') as String;
    setState(() {
      if (camUrl == "") {
  isLoading = false;
  initialUrl = "";
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text("ไม่พบกล้อง"),
      content: Text("ร้านไม่ได้เพิ่มกล้องมาในระบบ"),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
} else if (!camUrl.startsWith("http://") && !camUrl.startsWith("https://")) {
  camUrl = "http://" + camUrl;
}
initialUrl = camUrl;
isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera ของทางร้าน"),
        backgroundColor: Color.fromARGB(255, 130, 219, 241),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : WebView(initialUrl: initialUrl),
    );
  }
}


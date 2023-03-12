import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class clinicmail extends StatefulWidget {
  const clinicmail({Key? key}) : super(key: key);

  @override
  State<clinicmail> createState() => _clinicmailState();
}

class _clinicmailState extends State<clinicmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("กล่องลูกค้า")),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class cam extends StatefulWidget {
  const cam({Key? key, required String doctorid, required String petid}) : super(key: key);

  @override
  State<cam> createState() => _camState();
}

class _camState extends State<cam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Camera ของทางร้าน"),backgroundColor: Color.fromARGB(255, 130, 219, 241),),
        body: WebView(
          initialUrl:
              '',
        ));
  }
}

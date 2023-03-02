import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class cam extends StatefulWidget {
  const cam({Key? key}) : super(key: key);

  @override
  State<cam> createState() => _camState();
}

class _camState extends State<cam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("ยินดีต้อนรับ สู่หน้า Cam")),
        body: WebView(
          initialUrl:
              'http://58.136.57.127/videostream.cgi?user=admin&pwd=1231232077&resolution=32&rate=0',
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDF extends StatefulWidget {
  const PDF({Key? key, required this.pdfUrl}) : super(key: key);

  final String pdfUrl;

  @override
  State<PDF> createState() => _PDFState();
}

class _PDFState extends State<PDF> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: <Widget>[],
      ),
      body: SfPdfViewer.network(
        widget.pdfUrl,
        key: _pdfViewerKey,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NextPage extends StatelessWidget {
  const NextPage({Key? key, required this.ref}) : super(key: key);

  final DocumentReference ref;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _latitudeController = TextEditingController();
    final TextEditingController _longitudeController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Coordinates')),
      backgroundColor: Color.fromARGB(255, 130, 219, 241),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
            ),
            TextField(
              controller: _longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
            ),
            ElevatedButton(
              onPressed: () {
                final double latitude = double.parse(_latitudeController.text);
                final double longitude = double.parse(_longitudeController.text);
                final geoPoint = GeoPoint(latitude, longitude);
                ref.update({'status': 'confirm', 'Location': geoPoint});
                // TODO: ทำการบันทึกค่า latitude และ longitude เป็น geopoint ใน database
              },
              child: const Text('Save Coordinates'),
            ),
          ],
        ),
      ),
    );
  }
}
    // ใช้ ref ได้ในส่วนนี้


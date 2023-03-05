import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapnaja extends StatefulWidget {
  const Mapnaja({super.key});

  @override
  State<Mapnaja> createState() => _MapnajaState();
}

class _MapnajaState extends State<Mapnaja> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ค้นหา Clinic")),
      body: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // สร้างตัวแปรไว้กำหนดค่าเริ่มต้น
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(
      13.824148,
      100.5146787,
    ),
    zoom: 15,
  );

  // สร้างตัวไว้กลับมาตั้งหลัก
  late GoogleMapController _googleMapController;

  // สร้าง Marker ของร้านครินิคไว้
  late Marker _Shop1;
  late Marker _Shop2;
  late Marker _Shop3;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // สร้างรายการ Marker ของร้านครินิคไว้
    List<Widget> DataMarker = [];
    DataMarker.add(Text("ร้านที่ 1"));
    DataMarker.add(Text("ร้านที่ 2"));
    return Scaffold(
      // หน้าต่างสำเร็จรูป จัดแอพ
      body: Column(
        // แบ่งส่วนเป็น 2 ส่วนด้วย Column
        children: [
          // สร้างกล่องมา ส่วนของ map
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              // บอกลักษณะกล่อง
              decoration: BoxDecoration(color: Colors.green),
              height: 350,
              child: GoogleMap(
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (controller) => _googleMapController = controller,
                markers: {Marker(markerId: const MarkerId('shop1'))},
                //onLongPress: _addMarker,
              ),
            ),
          ),
          // สร้างกล่องมา ส่วนของ เมนู
          Container(
            // บอกลักษณะกล่อง
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 167, 196, 219),
                borderRadius: BorderRadius.circular(20)),
            height: 250,
            child: ListView(), // ทำเป็นรายการ
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition))),
    );
  }
}

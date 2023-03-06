import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(
        title: Text("ค้นหา Clinic"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.home),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person),
          ),
        ],
      ),
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
    // List<Widget> DataMarker = [];
    // // DataMarker.add(Text("ร้านที่ 1"));
    // // DataMarker.add(Text("ร้านที่ 2"));
    // // วนลูปสร้าง Marker
    // for (var i = 0; i < 5; i++) {
    //   DataMarker.add(Text(
    //     "ร้านที่ ${i + 1}",
    //   ));
    // }

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
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: 5, // จำนวนร้านที่แสดง
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          // กรอบของแต่ละรายการ
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromARGB(255, 118, 133, 145),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // เนื้อใน
                          child: ListTile(
                              title: Text(
                                "ร้านที่ ${index + 1}",
                                style: TextStyle(fontSize: 25),
                              ),
                              subtitle: Text("ร้านนี้ดีนะ"),
                              // ในส่วนของการเลือกร้าน
                              onTap: () {
                                print("คุณเลือกร้านที่ ${index + 1}");
                              }),
                        ),
                      );
                    })),
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

// เตรียมข้อมูล list
List<Widget> getData(int count) {
  List<Widget> DataMarker = [];
  for (var i = 0; i < count; i++) {
    // ตัวแปร txt ไว้เพิ่มเข้าไปใน list
    var txt = Text(
      "ร้านที่ ${i + 1}",
      style: TextStyle(fontSize: 25),
    );
    // ตัวแปร txt2 ไว้เพิ่มเข้าไปใน list แบบ listtile
    var txt2 = ListTile(
      title: Text(
        "ร้านที่ ${i + 1}",
        style: TextStyle(fontSize: 25),
      ),
      subtitle: Text("ร้านนี้ดีนะ"),
    );
    // เพิ่มเข้าไปใน list
    DataMarker.add(txt2);
  }
  return DataMarker;
}

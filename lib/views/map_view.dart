import 'package:LittleBuddy/views/home.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:google_directions_api/google_directions_api.dart';

// GPS
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

// ตัวแปร หลัก
late GoogleMapController _googleMapController;
Location location = Location();
//PermissionStatus permission = await Permission.location.request();

class Mapnaja extends StatefulWidget {
  const Mapnaja({super.key});

  @override
  State<Mapnaja> createState() => _MapnajaState();
}

class _MapnajaState extends State<Mapnaja> {
  // กล่องแจ้งเตือน
  void showAlert() {
    QuickAlert.show(
        context: context,
        title: "ไปหน้าต่อไป แต่ยังบ่ทำ😅",
        type: QuickAlertType.error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ค้นหา Clinic"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
          icon: Icon(Icons.home),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showAlert();
            },
            icon: Icon(Icons.check),
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

  // สร้างตัวแปร location เพื่อเข้าถึงข้อมูลตำแหน่งปัจจุบัน
  final Location location = Location();

  // สร้าง GoogleMapController เพื่อควบคุมแผนที่
  GoogleMapController? _googleMapController;

  // สร้าง Marker ของร้านครินิคไว้
  late Marker _Shop1; // 13.8242694,100.5182896
  late Marker _Shop2; // 13.8255741,100.5012048
  late Marker _Shop3; // 13.8107984,100.5048029

  // @override
  // void dispose() {
  //   _googleMapController.dispose();
  //   super.dispose();
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   // ขออนุญาติใช้งานตำแหน่งปัจจุบัน
  //   _requestPermission();
  // }

  // // ฟังก์ชันขออนุญาติใช้งานตำแหน่งปัจจุบัน
  // Future<void> _requestPermission() async {
  //   final PermissionStatus permission = await Permission.location.request();
  //   if (permission == PermissionStatus.granted) {
  //     // กรณีได้รับอนุญาติใช้งานตำแหน่งปัจจุบัน
  //     _getCurrentLocation();
  //   }
  // }

  // ฟังก์ชันหาตำแหน่งปัจจุบัน
  Future<void> _getCurrentLocation() async {
    try {
      final LocationData locationData = await location.getLocation();
      final LatLng currentLocation = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      // ใช้ currentLocation เพื่อกำหนดตำแหน่งปัจจุบันใน GoogleMap
    } catch (e) {
      // กรณีเกิดข้อผิดพลาดในการหาตำแหน่งปัจจุบัน
      print('Error: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    location.getLocation().then((currentLocation) {
      _googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          ),
          zoom: 15,
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    // เรียก API
    // DirectionsService.init('AIzaSyBaL-2GQAFyjw2g60r43mTSjywMzbesJxQ');

    // final directionsService = DirectionsService();

    // final request = DirectionsRequest(
    //   origin: GoogleMapController,
    //   destination: LatLng(
    //     13.8242694,
    //     100.5182896,
    //   ),
    //   travelMode: TravelMode.driving,
    // );

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
              height: MediaQuery.of(context).size.height *
                  0.4, // ตั้งค่าความสูงของ Container เป็น 40% ของความสูงของหน้าจอ
              child: GoogleMap(
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (controller) => _googleMapController = controller,
                markers: {Marker(markerId: const MarkerId('shop1'))},

               // initialCameraPosition: _initialCameraPosition,
                //onMapCreated: _onMapCreated,
              ),
            ),
          ),
          // สร้างกล่องมา ส่วนของ เมนู
          Container(
            // บอกลักษณะกล่อง
            decoration: BoxDecoration(
                //color: Color.fromARGB(255, 167, 196, 219),
                borderRadius: BorderRadius.circular(20)),
            height: MediaQuery.of(context).size.height *
                0.42, // ตั้งค่าความสูงของ Container เป็น 42% ของความสูงของหน้าจอ
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: 15, // จำนวนร้านที่แสดง
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          // กรอบของแต่ละรายการ
                          decoration: BoxDecoration(
                              // border: Border.all(
                              //   color: Color.fromARGB(255, 118, 133, 145),
                              //   width: 1.0,
                              // ),
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(255, 192, 247,
                                  248) // เปลี่ยนสีพื้นหลังของ Container แต่ละรายการ
                              ),
                          // เนื้อใน
                          child: ListTile(

                              // ข้อความ หลัก
                              title: Text(
                                "ร้านที่ ${index + 1}",
                                style: TextStyle(fontSize: 25),
                              ),
                              // ข้อความ รอง
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

      // ส่วนของปุ่มลอย ขวาล่าง กดแล้วกลับไปตำแหน่งตัวเอง
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _googleMapController!.animateCamera(
            CameraUpdate.newCameraPosition(_initialCameraPosition)),
        //child: Icon(Icons.explore), // สัญลักษณ์ Icon ลอยขวาล่าง

        // onPressed: () async {
        //   // ขอ Permission เพื่อใช้ Location Service
        //   if (await Permission.location.request().isGranted) {
        //     // ดึงตำแหน่งปัจจุบัน
        //     final locationData = await Location().getLocation();
        //     final latLng =
        //         LatLng(locationData.latitude!, locationData.longitude!);

        //     // เคลื่อนไหวกล้องไปยังตำแหน่งปัจจุบัน
        //     final googleMapController = await _googleMapController.future;
        //     googleMapController
        //         .animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
        //   }
        // },
        tooltip: 'My Location',
        child: Icon(Icons.location_searching),
      ),
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

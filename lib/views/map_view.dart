import 'package:LittleBuddy/views/directions_repository.dart';
import 'package:LittleBuddy/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:google_directions_api/google_directions_api.dart';

// GPS
import 'package:geolocator/geolocator.dart';

import 'direction_model.dart';

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
          icon: Icon(Icons.arrow_back),
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
  // ตำแหน่งเริ่มต้น
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(13.8243766, 100.5160947), zoom: 15);

  // ตัวแปรไว้ควบคุมหน้า goolemap
  late GoogleMapController _googleMapController;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  // ตัวแปรเก็บ Marker
  Set<Marker> _markers = {};
  var shopdata = [
    [13.8232031, 100.506575],
    [13.8242144, 100.515139],
    [13.8031571, 100.5395366]
  ];

  late LatLng MainLocation;

  // สร้าง mark ทั้งหมดบนแผนที่
  void addMark() {
    setState(() {
      // เพิ่ม Marker ใน _markers
      for (var i = 0; i < shopdata.length; i++) {
        _markers.add(Marker(
          markerId: MarkerId("marker ${i}"),
          position: LatLng(shopdata[i][0], shopdata[i][1]),
          infoWindow: InfoWindow(
            title: "ร้านที่ ${i + 1}",
            snippet: "ร้านนี้ดีนะ",
          ),
        ));
      }
    });
  }

  // ตัวแปรเก็บพิกัด user
  Position? _position;

  // ตัวแปร เกี่ยวกับเส้นทาง
  Directions? _info;
  Marker? _origin;
  Marker? _destination;

  // สถานะ route
  bool st = false;

  // หาพิกัด latitude, longitude
  void _getCurrentLocation() async {
    Position position = await _determinePosition(); // ขออนุญาตหาตำแหน่ง
    setState(() {
      _position = position;
    });
  }

  // ย้ายตำแหน่งไปยัง mark นั้นๆ
  CameraPosition _getShopLocation(index) {
    // ตั้งค่าตัวแปร _destination (ปลายทาง)
    setState(() {
      _origin = Marker(
        markerId: MarkerId("You"),
        position: MainLocation,
      );
      for (var marker in _markers) {
        if (marker.markerId == MarkerId("marker ${index}")) {
          _destination = marker;
          break;
        }
      }
    });

    return CameraPosition(
        target: LatLng(shopdata[index][0], shopdata[index][1]), zoom: 15);
  }

  void _route() async {
    final diarections = await DirectionsRepositoey().getDirections(
        origin: _origin!.position, destination: _destination!.position);
    setState(() => _info = diarections);
    st = !st;
  }

  // ฟังก์ชั่น ขออนุญาตหาตำแหน่ง
  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    if (_position == null) {
      _getCurrentLocation();
      addMark();
    } else {
      MainLocation = LatLng(_position!.latitude, _position!.longitude);
    }
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
              child: _position != null
                  ?
                  // Text("CurrentLocation : "+ _position.toString())
                  Stack(
                      alignment: Alignment.center,
                      children: [
                        GoogleMap(
                          initialCameraPosition: _initialCameraPosition,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          onMapCreated: (controller) =>
                              _googleMapController = controller,
                          markers: _markers, // markers
                         polylines: {
                          if (_info != null)
                            Polyline(
                              polylineId: const PolylineId('overview_polyline'),
                              color: Colors.blue,
                              width: 5,
                              points: _info!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                            )
                         },
                        ),
                        if (_info != null)
                          Positioned(
                            top: 20,
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 12.0),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(0, 2),
                                        blurRadius: 6.0,
                                      )
                                    ]),
                                child: Text(
                                  "${_info!.totalDistance},${_info!.totalDuration}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                )),
                          )
                      ],
                    )
                  : Text(
                      "                                                Loading                                                "),
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
                    itemCount: shopdata.length, // จำนวนร้านที่แสดง
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          // กรอบของแต่ละรายการ
                          decoration: BoxDecoration(
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
                                _googleMapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        _getShopLocation(index)));
                                _route();
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
        onPressed: () {
          _googleMapController.animateCamera(_info != null
              ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.00)
              : CameraUpdate.newCameraPosition(_initialCameraPosition));
        },
        tooltip: 'My Location',
        child: Icon(Icons.filter_center_focus),
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

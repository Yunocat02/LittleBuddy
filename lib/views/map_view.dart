import 'package:LittleBuddy/views/directions_repository.dart';
import 'package:LittleBuddy/views/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:google_directions_api/google_directions_api.dart';

// GPS
import 'package:geolocator/geolocator.dart';

import 'direction_model.dart';

Future<List<GeoPoint>> getConfirmedGeoPoints() async {
  List<GeoPoint> geoPoints = [];

  // สร้าง Query โดยเลือก Document ที่มี field status เท่ากับ "confirm"
  Query query = FirebaseFirestore.instance
      .collection('clinicreport')
      .where("status", isEqualTo: "confirm");

  // ดึงข้อมูลจาก Firebase Cloud Firestore
  QuerySnapshot querySnapshot = await query.get();

  // วน loop เพื่อดึงค่าของ GeoPoint ออกมาจาก DocumentSnapshot
  for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
    // อ่านค่าของ GeoPoint จาก DocumentSnapshot
    GeoPoint geoPoint = documentSnapshot.get('Location');
    geoPoints.add(geoPoint);
  }

  return geoPoints;
}

Future<List<String>> getConfirmedNames() async {
  List<String> confirmedNames = [];

  // สร้าง Query โดยเลือก Document ที่มี field status เท่ากับ "confirm" และเลือกเฉพาะ field name
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('clinicreport')
      .where('status', isEqualTo: 'confirm')
      .get();

  // วน loop เพื่อดึงค่าของ name ออกมาจาก DocumentSnapshot
  for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
    // อ่านค่าของ name จาก DocumentSnapshot
    String name = documentSnapshot.get('name');
    confirmedNames.add(name);
  }

  return confirmedNames;
}

Future<List<String>> getConfirmeddescription() async {
  List<String> confirmeddescription = [];

  // สร้าง Query โดยเลือก Document ที่มี field status เท่ากับ "confirm" และเลือกเฉพาะ field name
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('clinicreport')
      .where('status', isEqualTo: 'confirm')
      .get();

  // วน loop เพื่อดึงค่าของ name ออกมาจาก DocumentSnapshot
  for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
    // อ่านค่าของ name จาก DocumentSnapshot
    String description = documentSnapshot.get('description');
    confirmeddescription.add(description);
  }

  return confirmeddescription;
}

Future<List<String>> getConfirmedDocumentIDs() async {
  List<String> confirmedDocumentIDs = [];

  // สร้าง Query โดยเลือก Document ที่มี field status เท่ากับ "confirm"
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('clinicreport')
      .where('status', isEqualTo: 'confirm')
      .get();

  // วน loop เพื่อดึง document ID ออกมาจาก QueryDocumentSnapshot
  for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
    // อ่านค่าของ document ID จาก QueryDocumentSnapshot
    String documentID = documentSnapshot.id;
    confirmedDocumentIDs.add(documentID);
  }

  return confirmedDocumentIDs;
}
// เก็บ id ร้านที่ user เลือก
  late String u_ok = "";
// เก็บ name ร้านที่ user เลือก
  late String uName_ok = "";
class Mapnaja extends StatefulWidget {
  // ตัวแปรที่รับมา
  final String uidpet;
  final String useruid;
  final String symptom;
  final String date;
  final String medic;

  const Mapnaja({super.key, required this.uidpet, required this.useruid, required this.symptom, required  this.date, required  this.medic});

  @override
  State<Mapnaja> createState() => _MapnajaState();
}

class _MapnajaState extends State<Mapnaja> {
  // กล่องแจ้งเตือน
  Future<void> showAlert()  async {
    await QuickAlert.show(
        context: context,
        title: "ทำการลงทะเบียนกับ ${uName_ok} เรียบร้อย",
        type: QuickAlertType.success);
    
  }

  @override
  Widget build(BuildContext context) {
    print("uidpet = ${widget.uidpet}");
    print("useruid = ${widget.useruid}");
    print("symptom = ${widget.symptom}");
    print("date = ${widget.date}");
    print("medic = ${widget.medic}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 130, 219, 241),
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
            onPressed: () async {
              await showAlert();

              final refconnect = FirebaseFirestore.instance
                                  .collection('connect')
                                  .doc(u_ok)
                                  .collection('userconnect')
                                  .doc(widget.uidpet);
              final defaultchat = FirebaseFirestore.instance
                                  .collection('connect')
                                  .doc(u_ok)
                                  .collection('userconnect')
                                  .doc(widget.uidpet)
                                  .collection('message')
                                  .doc('firsttext');
            refconnect.set({
              'status':'waiting',
              'datetimesym': widget.date,
              'medic': widget.medic,
              'petid': widget.uidpet,
              'symptom': widget.symptom,
              'userid': widget.useruid,
            });

            DateTime now = DateTime.now();
            Timestamp timestamp = Timestamp.fromDate(now);
            defaultchat.set({
              'email':'Aminbot',
              'message': 'นี่คือแชทที่คุณติดต่อกับหมอได้',
              'time': timestamp,
              'uid': 'dGQWWcCwcyMlnCv12WXjOereXlr2',  // ID admin
            });
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
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final firestore = FirebaseFirestore.instance;

  // ตำแหน่งเริ่มต้น
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(13.8243766, 100.5160947), zoom: 15);

  // ตัวแปรไว้ควบคุมหน้า goolemap
  late GoogleMapController _googleMapController;

  //ตัวแปรเริ่มต้นดึงมาจาก DB
  List<String> ShopNames = [];
  List<String> ShopDescription = [];
  List<GeoPoint> ShopLocation =[];
  List<String> ShopID = [];

  // ดึงข้อมูล จาก firebase
  void getData() async{
    List<GeoPoint> geoPoints = await getConfirmedGeoPoints();
    List<String> confirmeNames = await getConfirmedNames();
    List<String> confirmeDescription = await getConfirmeddescription();
    List<String> confirmeShopIDs = await getConfirmedDocumentIDs();
    setState(() {
      ShopNames = confirmeNames;
      ShopDescription = confirmeDescription;
      ShopLocation = geoPoints;
      ShopID = confirmeShopIDs;
    });
    addMark();
  }


  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  // ตัวแปรเก็บ Marker
  Set<Marker> _markers = {};
  var shopdata = [];

  late LatLng MainLocation =LatLng(13.8243766, 100.5160947);
  List<GeoPoint>? _geoPoints;

  // สร้าง mark ทั้งหมดบนแผนที่
  void addMark() async {
    //List<GeoPoint> geoPoints = await getConfirmedGeoPoints();
    //List<String> confirmedNames = await getConfirmedNames();
    setState(() {
      // เพิ่ม Marker ใน _markers
      //_geoPoints = geoPoints;
      //var i = 0;
      for (var i=0;i<ShopLocation.length;i++) {
        _markers.add(Marker(
          markerId: MarkerId(ShopLocation[i].latitude.toString()),
          position: LatLng(ShopLocation[i].latitude, ShopLocation[i].longitude),
          infoWindow: InfoWindow(
            title: "ร้าน ${ShopNames[i]}",
            snippet: "${ShopDescription[i]}",
          ),
        ));
        if (shopdata.length < ShopLocation.length) {
          shopdata.add([ShopLocation[i].latitude,ShopLocation[i].longitude]);
        }
      }
    });
  }
List<String>? namemark ;
void testmark() async{
  List<String> confirmedNames = await getConfirmedNames();
  setState(() {
      namemark = confirmedNames;
    });
}
  // หา mark
  void getgeoPoints() async{
    List<GeoPoint> geoPoints = await getConfirmedGeoPoints();
    setState(() {
      _geoPoints = geoPoints;
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
        if (marker.markerId == MarkerId(ShopLocation[index].latitude.toString())) {
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
    if (_position == null || ShopNames == null || ShopDescription == null || ShopLocation == null) {
      _getCurrentLocation();
      //getgeoPoints();
      getData();
      //addMark();
      //testmark();
      
    } else if (_position != null) {
      MainLocation = LatLng(_position!.latitude, _position!.longitude);
    }
    return Scaffold(
      // หน้าต่างสำเร็จรูป จัดแอพ
      body:
      
       Column(
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
                          initialCameraPosition:
                              CameraPosition(target: MainLocation, zoom: 15),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          onMapCreated: (controller) =>
                              _googleMapController = controller,
                          markers: _markers, // markers
                          polylines: {
                            if (_info != null)
                              Polyline(
                                polylineId:
                                    const PolylineId('overview_polyline'),
                                color: Colors.blue,
                                width: 5,
                                points: _info!.polylinePoints
                                    .map((e) => LatLng(e.latitude, e.longitude))
                                    .toList(),
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
              child:  ListView.builder(
                    itemCount: ShopLocation.length, // จำนวนร้านที่แสดง
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
                                      "ร้าน: " + ShopNames[index],
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    // ข้อความ รอง
                                    subtitle: Text(ShopDescription[index]),
                                    // ในส่วนของการเลือกร้าน
                                    onTap: () {
                                      _googleMapController.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                              _getShopLocation(index)));
                                      _route();
                                      print("คุณเลือกร้านที่ ${index + 1}");
                                      u_ok = ShopID[index].toString();
                                      uName_ok = ShopNames[index].toString();
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
          // testmark();
          print("ShopLocation คือ ${ShopLocation}");
          print("ShopNames คือ ${ShopNames}");
          print("ShopDescription คือ ${ShopDescription}");
          print("ShopID คือ ${ShopID}"); 
          print("คุณเลือก ${u_ok}");
          //print(shopdata); ShopID
          
          for (var i=0;i<ShopLocation.length;i++){
            print("ID ${i}");
            print("ตำแหน่ง ${ShopLocation[i].latitude} ${ShopLocation[i].longitude}");
          }
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


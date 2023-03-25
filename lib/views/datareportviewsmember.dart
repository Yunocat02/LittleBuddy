import 'package:LittleBuddy/views/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class datareportviewsmember extends StatefulWidget {
  @override
  _datareportviewsmember createState() => _datareportviewsmember();
}

class _datareportviewsmember extends State<datareportviewsmember> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  late String _content = "";
  late Timestamp _appmtime = Timestamp.now();
  late Timestamp _datetime = Timestamp.now();
  late String _idpet = "";
  late String _namepet = "";
  late String _remedy = "";
  late String _url = "";
  late String _role = "";
  late String _username = "";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"),backgroundColor: Color.fromARGB(255, 130, 219, 241),),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<User?>(
                  future: _getCurrentUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Column(
                        children: [
                          //Text(
                          //    'appmtime: ${_appmtime?.toDate().toString() ?? "N/A"}'),
                          //SizedBox(height: 5),
                          //Text('content: $_content'),
                          //SizedBox(height: 5),
                          //Text(
                          //    'Timestamp: ${_datetime?.toDate().toString() ?? "N/A"}'),
                          //SizedBox(height: 5),
                          //Text('idpet: $_idpet'),
                          //SizedBox(height: 5),
                          //Text('namepet: $_namepet'),
                          //SizedBox(height: 5),
                          //Text('remedy: $_remedy'),
                          //SizedBox(height: 5),
                          //Text('url: ${_url}'),
                          SizedBox(height: 5),
                          Text('username: $_username'),
                          SizedBox(height: 5),
                          Text('role: $_role'),
                        ],
                      );
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    globalRole?.role = ''; // กำหนดค่า globalRole เป็น null
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    ); // กลับไปที่หน้า Home
                  },
                  child: Text('Logout'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<User?> _getCurrentUser() async {
    User? user = auth.currentUser;
    if (user != null) {
      await user.reload();
      user = auth.currentUser;
      return user;
    } else {
      return null;
    }
  }

  Future<void> _loadUserInfo() async {
    final userId = auth.currentUser?.uid;

    if (userId != null) {
      final userDoc =
          await firestore.collection('userdatabase').doc(userId).get();
      final userData = userDoc.data() as Map<String, dynamic>?;
      setState(() {
        //_appmtime = userData?['appm. time'] as Timestamp;

        _username = userData?['username'] ?? 'N/A';
        _role = userData?['role'] ?? 'N/A';

        //_content = userData?['content'] ?? 'N/A';
        //_datetime = userData?['datetime'] as Timestamp;
        //_idpet = userData?['idpet'] ?? 'N/A';
        //_namepet = userData?['namepet'] ?? 'N/A';
        //_remedy = userData?['remedy'] ?? 'N/A';
        //_url = userData?['url'] ?? 'N/A';
      });
    }
  }
}

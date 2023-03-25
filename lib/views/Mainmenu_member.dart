import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:LittleBuddy/views/login_view.dart';

class MainMenuMember extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<MainMenuMember> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  late String _username = "";
  late String _role = "";
  late String _userId = "";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 130, 219, 241),
        title: Text("Littlebuddy"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                print("Hi profile");
              },
              icon: Icon(Icons.person))
        ],
      ),
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
                          Text(snapshot.data?.email ?? ''),
                          SizedBox(height: 20),
                          Text('Username: $_username'),
                          SizedBox(height: 10),
                          Text('Role: $_role'),
                          SizedBox(height: 5),
                          Text('UserID: $_userId'),
                        ],
                      );
                    }
                  },
                ),
                ElevatedButton(
                  child: Text("ออกจากระบบ"),
                  onPressed: () {
                    auth.signOut().then((value) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginView();
                      }));
                    });
                  },
                ),
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
        _username = userData?['username'] ?? 'N/A';
        _role = userData?['role'] ?? 'N/A';
        _userId = userId.toString();
      });
    }
  }
}

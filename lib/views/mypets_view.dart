import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Mypets extends StatefulWidget {
  const Mypets({super.key});

  @override
  State<Mypets> createState() => _Mypets();
}
class _Mypets extends State<Mypets> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final firestore = FirebaseFirestore.instance;

  late FirebaseAuth _auth;
  final _user = Rxn<User>();
  late Stream<User?> _authStateChanges;

  @override
  void initState() {
    super.initState();
    initAuth();
  }

  void initAuth() async {
    _auth = FirebaseAuth.instance;
    _authStateChanges = _auth.authStateChanges();
    _authStateChanges.listen((User? user) {
      _user.value = user;
    });
  }

  User? getuser() {
    _user.value = _auth.currentUser;
    return _user.value;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mypet'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('petreport')
            .doc(getuser()?.uid)
            .collection("0001")
            .snapshots(),
        builder: (context, subCollectionSnapshot) {
          if (subCollectionSnapshot.hasData) {
            return ListView.builder(
              itemCount: subCollectionSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = subCollectionSnapshot.data!.docs[index].data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['name'] ?? "N/A"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['type'] ?? "N/A"),
                      Text(data['age(year)'] ?? "N/A"),   
                      Text(data['age(month)'] ?? "N/A"),
                      Text(data['species'] ?? "N/A"),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
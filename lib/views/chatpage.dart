import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'message.dart';

class chatpage extends StatefulWidget {
  String email;
  chatpage({required this.email});
  @override
  _chatpageState createState() => _chatpageState(email: email);
}

class _chatpageState extends State<chatpage> {
  String email;
  _chatpageState({required this.email});

  final fs = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController message = new TextEditingController();
  late String _username = "";
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    final Future<FirebaseApp> firebase = Firebase.initializeApp();
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    late String _username = "";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'data',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.79,
              child: messages(
                email: email,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: message,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.purple[100],
                      hintText: 'message',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.purple),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.purple),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {},
                    onSaved: (value) {
                      message.text = value!;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (message.text.isNotEmpty) {
                      fs
                          .collection('connect')
                          .doc(uid)
                          .collection('message')
                          .doc()
                          .set({
                        'message': message.text.trim(),
                        'time': DateTime.now(),
                        'email': email,
                        'uid': uid,
                      });

                      message.clear();
                    }
                  },
                  icon: Icon(Icons.send_sharp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

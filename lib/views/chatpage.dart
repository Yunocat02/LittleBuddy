import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'message.dart';

class chatpage extends StatefulWidget {
  final String email;
  final String petid;
  final String doctorid;


  chatpage({
    required this.email, required this.petid, required this.doctorid,

  });
  @override
  _chatpageState createState() => _chatpageState(email: email);
}

class _chatpageState extends State<chatpage> {
  String email;


  _chatpageState({required this.email}) {
  }

  final fs = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController message = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    String petid = widget.petid;
    String doctorid = widget.doctorid;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    final FirebaseFirestore _db = FirebaseFirestore.instance;
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
                email: email, doctorid: doctorid, petid: petid,
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
                          .doc(doctorid)
                          .collection('userconnect')
                          .doc(petid)
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
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class messages extends StatefulWidget {
  String email;
  String petid;
  String doctorid;
  messages({required this.email,required this.petid,required this.doctorid});
  @override
  _messagesState createState() => _messagesState(email: email,petid: petid,doctorid: doctorid);
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;
final uid = user?.uid;
final FirebaseFirestore _db = FirebaseFirestore.instance;

class _messagesState extends State<messages> {
  String email;
  String petid;
  String doctorid;
  _messagesState({required this.email,required this.petid,required this.doctorid});
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
      .collection('connect')
      .doc(widget.doctorid)
      .collection('userconnect')
      .doc(widget.petid)
      .collection('message')
      .orderBy('time', descending: true)
      .snapshots();
    return StreamBuilder(
      stream: _messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("something is wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemCount: snapshot.data!.docs.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, index) {
            QueryDocumentSnapshot qs = snapshot.data!.docs[index];
            Timestamp t = qs['time'];
            DateTime d = t.toDate();
            print(d.toString());
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: email == qs['email']
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.purple,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        qs['email'],
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              qs['message'],
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(
                            d.hour.toString() + ":" + d.minute.toString(),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

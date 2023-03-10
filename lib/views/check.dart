import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:LittleBuddy/views/login_view.dart';

class checkcustomer extends StatefulWidget {
  @override
  _checkcustomerState createState() => _checkcustomerState();
}

class _checkcustomerState extends State<checkcustomer> {
 

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ลูกค้าที่ขอลงทะเบียนกับร้าน"),
        
      ),
     
      
    );
  }

}
import 'package:LittleBuddy/views/cam_view.dart';
import 'package:flutter/material.dart';

class Clinic extends StatefulWidget {
  const Clinic({Key? key}) : super(key: key);

  @override
  State<Clinic> createState() => _ClinicState();
}

class _ClinicState extends State<Clinic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ยินดีต้อนรับ สู่หน้า clinic")),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // add some padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: () {},
                child: Text('Weboard คลินิก', style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Chat คลินิก', style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Chatbot', style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child:
                    Text('ลายละเอียดการรักษา', style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('เช็ควันนัดหมาย', style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => cam()),
                  );
                },
                child: Text('กล้อง', style: TextStyle(fontSize: 24)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

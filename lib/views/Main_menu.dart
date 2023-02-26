import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_login_ui/views/Chatbot_view.dart';
import 'package:responsive_login_ui/views/login_view.dart';
import 'package:responsive_login_ui/views/signUp_view.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final List<String> items = [
    'Chatbot',
    'Other menu',
    
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        centerTitle: true,
        actions: [
            IconButton(
                onPressed: () {
                  // การเอาหน้าอื่นมาทับ context คือ ?? | route คือ ตำแหน่งหน้าที่จะทับ
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoginView();
                  }));
                },
                icon: Icon(Icons.person))
          ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(items[index]),
            onTap: () {
              // Handle item tap here
              print("คุณกด $index");
              if(index == 1){
                Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (ctx) => const LoginView()));
              }
              else if(index == 0){
                Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (ctx) => const Chatbot()));
              }       
            },
          );
        },
      ),
    );
  }
}



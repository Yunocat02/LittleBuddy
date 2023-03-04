import 'dart:ui';

import 'package:LittleBuddy/views/home.dart';
import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

import 'Messages.dart';
class Chatbot extends StatelessWidget {
  const Chatbot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'CHATBOT',
      theme:ThemeData(
        brightness: Brightness.light
      ) ,
      debugShowCheckedModeBanner: false,
      home: Bot(),
    );
  }
}

class Bot extends StatefulWidget {
  const Bot({Key? key}) : super(key: key);

  @override
  State<Bot> createState() => _BotState();
}

class _BotState extends State<Bot> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  List<Map<String,dynamic>> messages=[];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter=instance);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Somchai'),
        centerTitle: true,
        leading: IconButton(
        onPressed: () {
           Navigator.push(context,MaterialPageRoute(builder: (context) => Home()),);
        },
        icon: Icon(Icons.arrow_back),),
        backgroundColor: Color.fromARGB(255, 225, 189, 255),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14,vertical: 8),
              color: Color.fromARGB(255, 225, 189, 255),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),

                        ),

                      )
                  ),
                  IconButton(
                      onPressed: (){
                        sendMessage(_controller.text);
                        _controller.clear();
                      },
                      icon: Icon(Icons.send),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  sendMessage(String text) async{
    if(text.isEmpty)
      {
        print('message is empty');
      }
    else
      {
          setState(() {
            addMessage(Message(text: DialogText(text: [text])),true);
          }
          );

          DetectIntentResponse response= await dialogFlowtter.detectIntent(queryInput: QueryInput(text:TextInput(text: text)));

          if(response.message==null)  return ;

          setState((){
            addMessage(response.message!);
          });
      }
  }
  addMessage(Message message,[bool isUserMessage = false ])
  {
        messages.add({
          'message': message,
          'isUserMessage': isUserMessage
        }
        );
  }
}


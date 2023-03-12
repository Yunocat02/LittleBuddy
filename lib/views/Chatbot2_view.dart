import 'package:bubble/bubble.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:flutter/material.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'home.dart';
import 'package:intl/intl.dart';
class bot2 extends StatefulWidget {
  @override
  _bot2State createState() => _bot2State();
}

class _bot2State extends State<bot2> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
      ),
      home: ChatBotScreen(),
    );
  }
}

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final messageInsert = TextEditingController();
  List<Map> messsages = [];
  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/dialog_flow_auth.json").build();
    DialogFlow dialogflow = DialogFlow(authGoogle: authGoogle, language: "th");
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    for (var message in aiResponse.getListMessage()!) {
      setState(() {
        messsages.insert(
            0, {"data": 0, "message": message["text"]["text"][0].toString()});
      });
    }
  }
  @override
  void initState() {
    super.initState();
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message":
            "สวัสดีครับมีอะไรให้รับใช้ครับ       1.หาคลินิคใกล้ฉัน                            2.อาการทั่วไปของสัตว์                 3.ข้อมูลของคลินิคที่ลงทะเบียน               4.แอพนี้คือไรหรอ                                                  พิมพ์หมายเลขมาได้เลยครับ"
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LITTLE BUDDY',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 119, 114, 114),
            )),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 119, 114, 114),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 192, 247, 248),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Text("Today, ${DateFormat("Hm").format(DateTime.now())}", style: TextStyle(
                fontSize: 20
              ),),
            ),
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messsages.length,
                    itemBuilder: (context, index) => chat(
                        messsages[index]["message"].toString(),
                        messsages[index]["data"]))),
            SizedBox(
              height: 20,
            ),

            Divider(
              height: 5.0,
              color: Colors.greenAccent,
            ),
            Container(
              child: ListTile(
                  // ignore: prefer_const_constructors
                  leading: IconButton(
                    icon: Icon(Icons.camera_alt, color: Color.fromARGB(255, 192, 247, 248), size: 35,), onPressed: () {    },
                  ),
                  title: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(
                          15)),
                      color: Color.fromRGBO(220, 220, 220, 1),
                    ),
                    padding: EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: messageInsert,
                      decoration: InputDecoration(
                        hintText: "Enter a Message...",
                        hintStyle: TextStyle(
                            color: Colors.black26
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),

                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                      ),
                      onChanged: (value) {

                      },
                    ),
                  ),

                  trailing: IconButton(

                      icon: Icon(

                        Icons.send,
                        size: 30.0,
                        color: Color.fromARGB(255, 192, 247, 248),
                      ),
                      onPressed: () {

                        if (messageInsert.text.isEmpty) {
                          print("empty message");
                        } else {
                          setState(() {
                            messsages.insert(0,
                                {"data": 1, "message": messageInsert.text});
                          });
                          response(messageInsert.text);
                          messageInsert.clear();
                        }
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      }),

              ),

            ),

            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

  Widget chat(String message, int data) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),

      child: Row(
          mainAxisAlignment: data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [

            data == 0 ? Container(
              height: 60,
              width: 60,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/robot.jpg"),
              ),
            ) : Container(),

        Padding(
        padding: EdgeInsets.all(10.0),
        child: Bubble(
            radius: Radius.circular(15.0),
            color: data == 0 ? Color.fromRGBO(3, 179, 155, 1) : Colors.orangeAccent,
            elevation: 0.0,

            child: Padding(
              padding: EdgeInsets.all(2.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  SizedBox(
                    width: 10.0,
                  ),
                  Flexible(
                      child: Container(
                        constraints: BoxConstraints( maxWidth: 200),
                        child: Text(
                          message,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ))
                ],
              ),
            )),
            ),
            data == 1? Container(
              height: 60,
              width: 60,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/default.jpg"),
              ),
            ) : Container(),

          ],
        ),
    );
  }
}
import 'package:bubble/bubble.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:flutter/material.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'home.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../views/map_view.dart';

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
    if (query == "หาคลินิคใกล้ฉัน") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Mapnaja()));
    } else {
      // ส่วนที่เหลือของโค้ดภายในฟังก์ชัน response()
    }
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/dialog_flow_auth.json").build();
    DialogFlow dialogflow = DialogFlow(authGoogle: authGoogle, language: "th");
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    for (var message in aiResponse.getListMessage()!) {
      if (message.containsKey("payload")) {
        var payload = message["payload"]["richContent"][0];
        for (var content in payload) {
          if (content["type"] == "cards") {
            setState(() {
              messsages.insert(0, {
                "data": 0,
                "message": "",
                "cards": content["options"],
              });
            });
          } else if (content["type"] == "chips") {
            setState(() {
              messsages.insert(
                  0, {"data": 0, "message": "", "chips": content["options"]});
            });
          }
        }
      } else {
        setState(() {
          messsages.insert(
              0, {"data": 0, "message": message["text"]["text"][0].toString()});
        });
      }
    }
  }

  @override
  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showInitialChips() {
    final List<dynamic> initialChips = [
      {"text": "หาคลินิคใกล้ฉัน"},
      {"text": "สัตว์เลี้ยงมีอาการผิดปกติ"},
      {"text": "ข้อมูลของคลินิคที่ลงทะเบียน"},
      {"text": "แอพนี้คือไรหรอ"}
    ];

    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": "สวัสดี",
        "chips": initialChips,
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      messsages.insert(
          0, {"data": 0, "message": "สวัสดีครับต้องการใช้บริการอะไรครับ"});
    });
    showInitialChips();
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
              child: Text(
                "Today, ${DateFormat("Hm").format(DateTime.now())}",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Flexible(
              child: ListView.builder(
                  reverse: true,
                  itemCount: messsages.length,
                  itemBuilder: (context, index) => chat(
                      messsages[index]["message"].toString(),
                      messsages[index]["data"],
                      messsages[index]["chips"],
                      messsages[index]["cards"])),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: ListTile(
                tileColor: Color.fromARGB(255, 192, 247, 248),
                // ignore: prefer_const_constructors
                leading: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: Color.fromARGB(255, 18, 97, 99),
                    size: 35,
                  ),
                  onPressed: () {},
                ),
                title: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  padding: EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: messageInsert,
                    decoration: InputDecoration(
                      hintText: "Enter a Message...",
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    onChanged: (value) {},
                  ),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 30.0,
                      color: Color.fromARGB(255, 18, 97, 99),
                    ),
                    onPressed: () {
                      if (messageInsert.text.isEmpty) {
                        print("empty message");
                      } else {
                        setState(() {
                          messsages.insert(
                              0, {"data": 1, "message": messageInsert.text});
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
          ],
        ),
      ),
    );
  }

  Widget chat(
      String message, int data, List<dynamic>? chips, List<dynamic>? cards) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment:
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
              ? Container(
                  height: 40,
                  width: 40,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/robot.jpg"),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: cards != null
                ? Wrap(
                    direction: Axis.vertical,
                    runSpacing: 4.0,
                    spacing: 8.0,
                    children: cards
                        .map(
                          (card) => InkWell(
                            onTap: () {
                              // Do nothing or remove this onTap function if you don't want any action to be taken.
                            },
                            child: Column(
                              children: [
                                Image.network(
                                  card['image'],
                                  height: 100,
                                  width: 100,
                                ),
                                SizedBox(height: 5),
                                Text(card['title']),
                                SizedBox(height: 5),
                                Text(
                                  card['subtitle'],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  )
                : chips != null
                    ? Wrap(
                        direction: Axis.vertical, // ตั้งค่าเป็นแนวตั้ง
                        runSpacing: 4.0, // ตั้งค่าระยะห่างระหว่างบรรทัด
                        spacing: 8.0,
                        children: chips
                            .map(
                              (chip) => ActionChip(
                                backgroundColor: Color.fromRGBO(4, 173, 55, 1),
                                label: Text(chip['text'],
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  // Check if 'link' is present in the chip payload.
                                  // If it exists, launch the URL; otherwise, send the text as a message.
                                  if (chip.containsKey('link')) {
                                    launch(chip['link']);
                                  } else {
                                    setState(() {
                                      messsages.insert(0,
                                          {"data": 1, "message": chip['text']});
                                    });
                                    response(chip['text']);
                                  }
                                },
                              ),
                            )
                            .toList(),
                      )
                    : Bubble(
                        radius: Radius.circular(15.0),
                        color: data == 0
                            ? Color.fromRGBO(3, 179, 155, 1)
                            : Colors.orangeAccent,
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
                                constraints: BoxConstraints(maxWidth: 200),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
          ),
          data == 1
              ? Container(
                  height: 40,
                  width: 40,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/default.jpg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

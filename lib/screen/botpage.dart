import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_parsed_text/flutter_parsed_text.dart';

class ChatPage extends StatefulWidget {
  final String email;
  const ChatPage({Key? key, required this.email}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatUser myself = ChatUser(id: '1', firstName: '');
  ChatUser bot = ChatUser(id: '2', firstName: 'Aviren',profileImage: 'assets/avirenlogo.png');

  List<ChatUser> typing = [];
  List<ChatMessage> allMessages = [];
  final url = 'https://aviren.pythonanywhere.com/generate';
  bool showLogoAndText = true;

  getdata(ChatMessage m) async {
    typing.add(bot);
    allMessages.insert(0, m);
    setState(() {
      showLogoAndText = false; 
    });
    var body = jsonEncode({"email": widget.email, "question": m.text});
    await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    ).then((value) {
      if (value.statusCode == 200) {
        var result = value.body;
        print(result);

        ChatMessage m1 =
        ChatMessage(text: result, user: bot, createdAt: DateTime.now());
        allMessages.insert(0, m1);
      } else {
        print('error occurred');
      }
    }).catchError((e) {});
    typing.remove(bot);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 194, 199, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Aviren',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: 'CustomFont',
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromRGBO(255, 194, 199, 1),
        child: Column(
          children: [
            if (showLogoAndText)
              Column(
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/avirenlogo.png', 
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'How can I help you today?',
                    style: TextStyle(fontSize: 35, fontFamily: 'CustomFont',color: Colors.black,),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            Expanded(
              child: DashChat(
                typingUsers: typing,
                currentUser: myself,
                onSend: (ChatMessage m) {
                  getdata(m);
                },
                messages: allMessages,

              ),
            ),
          ],
        ),
      ),
    );
  }
}

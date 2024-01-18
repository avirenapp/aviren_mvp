import 'package:flutter/material.dart';
import 'package:flutter1/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter1/screen/registration_page_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter1/screen/login_page.dart';
import 'package:flutter1/screen/home_screen.dart';

class MailReply extends StatefulWidget {
  final String email;

  const MailReply({Key? key, required this.email,}) : super(key: key);

  @override
  State<MailReply> createState() => _MailReplyState();
}

class _MailReplyState extends State<MailReply> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> userData;
  final TextEditingController responseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userData = getUserData();
    print('Before audio player initialization');
    MyApp.audioPlayer.play(AssetSource('avirensong.mp3'));
    print('After audio player initialization');
    MyApp.audioPlayer.setReleaseMode(ReleaseMode.loop);
    print(widget.email);
  }

  @override
  void dispose() {
    super.dispose();
    responseController.dispose();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.email)
          .get();
    } catch (e) {
      print('Error fetching user data: $e');
      throw e;
    }
  }
  Future<void> sendResponse() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.email)
          .update({
        'responseLetter': responseController.text,
        'respondLetter': true,
      });

      
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => HomeScreen(email: widget.email,)),
      );
    } catch (e) {
      print('Error sending response: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = 760.0;

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: userData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          
          return Text('Error: ${snapshot.error}');
        } else {
          
          Map<String, dynamic> userData = snapshot.data?.data() ?? {};

          return Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                "assets/letterscreen.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: screenHeight,
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.red),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                body: Stack(
                  children: [
                    Positioned(
                      top: 200,
                      left: 110,
                      child: Text(
                        userData['responseLetter_title'] ?? '',
                        style: TextStyle(fontSize: 30,fontFamily:'CustomFont'),
                      ),
                    ),
                    Positioned(
                      top: 250,
                      bottom: 250,
                      left: 110,
                      width: 260,
                      child: TextFormField(
                        controller: responseController,
                        maxLines: null,
                        maxLength: 250,
                        onChanged: (text) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Write your response...',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 20, fontFamily: 'CustomFont'),
                      ),
                    ),
                    Positioned(
                      bottom: 200,
                      left: 110,
                      child: Text(
                        userData['responseLetter_end'] ?? '',
                        style: TextStyle(fontSize: 30,fontFamily:'CustomFont'),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 60.0),
                        child: Container(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: responseController.text.isNotEmpty
                                ? () {
                              
                              sendResponse();
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                            child: Text('Send', style: TextStyle(fontSize: 30, fontFamily: 'CustomFont', color: Colors.black)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

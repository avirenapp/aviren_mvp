import 'package:flutter/material.dart';
import 'package:flutter1/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter1/screen/registration_page_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter1/screen/mail_reply.dart';

class MailScreen extends StatefulWidget {
  final String email;
  final VoidCallback onBack;

  const MailScreen({Key? key, required this.email,required this.onBack}) : super(key: key);

  @override
  State<MailScreen> createState() => _MailScreenState();
}

class _MailScreenState extends State<MailScreen> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> userData;
  bool openedLetter = false;

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
          bool respondLetter = userData['respondLetter'] ?? false;

          return WillPopScope(
            onWillPop: () async {
              
              widget.onBack();
              return true;
            },
            child : Stack(
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
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.red),
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onBack();
                      },
                    ),
                  ),
                  body: Stack(
                    children: [
                      Positioned(
                        top: 200,
                        left: 110,
                        child: Text(
                          userData['generatedLetter_title'] ?? '',
                          style: TextStyle(fontSize: 30,fontFamily:'CustomFont'),
                        ),
                      ),
                      Positioned(
                        top: 250,
                        left: 110,
                        width: 250,
                        child: Text(
                          userData['generatedLetter_header1'] ?? '',
                          style: TextStyle(fontSize: 20,fontFamily:'CustomFont'),
                        ),
                      ),
                      Positioned(
                        bottom: 240,
                        left: 110,
                        width: 250,
                        child: Text(
                          userData['generatedLetter_header2'] ?? '',
                          style: TextStyle(fontSize: 20,fontFamily:'CustomFont'),
                        ),
                      ),
                      Positioned(
                        bottom: 180,
                        left: 110,
                        child: Text(
                          userData['generatedLetter_end'] ?? '',
                          style: TextStyle(fontSize: 30,fontFamily:'CustomFont'),
                        ),
                      ),
                      if (!respondLetter) 
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 60.0), 
                            child: Container(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => MailReply(email: widget.email)),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                ),
                                child: Text(
                                  'Reply',
                                  style: TextStyle(fontSize: 30, fontFamily: 'CustomFont', color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

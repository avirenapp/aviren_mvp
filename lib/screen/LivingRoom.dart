import 'package:flutter/material.dart';
import 'package:flutter1/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter1/screen/mail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter1/screen/login_page.dart';
import 'package:flutter1/screen/botpage.dart';

class LivingRoom extends StatefulWidget {
  final String email;

  const LivingRoom({Key? key, required this.email}) : super(key: key);

  @override
  State<LivingRoom> createState() => _LivingRoomState();
}

class _LivingRoomState extends State<LivingRoom> {
  @override
  void initState() {
    super.initState();
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
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = 700.0;
    double screenWidth = 380.0;
          return Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                "assets/living_pet.png",
                fit: BoxFit.cover,
                width: screenWidth,
                height: screenHeight,
              ),
              Positioned(
                top: 64,
                left: 15,
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: false,
                body: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top:65,left: 8),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 190, right: 0),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ChatPage(email: widget.email)),
                              );
                            },
                            child: Container(
                              width: 130,
                              height: 110,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 65,right: 8), // Add your desired padding values
                          child: GestureDetector(
                            onTap: () {
                              // Show the options dialog when the options button is pressed
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      width: 200.0,
                                      height: 200.0,
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.arrow_back),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              Text('Options'),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Are you sure you want to logout?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(); // Cancel button
                                                        },
                                                        child: Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.of(context).pop(); // Close the confirmation dialog
                                                          await _logout(); // Logout the user
                                                        },
                                                        child: Text('Logout'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(Icons.logout,color: Colors.white,),
                                            label: Text('Logout',style: TextStyle(color: Colors.white),),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      )],
                  ),
                ),
              )
            ],
          );
        }}
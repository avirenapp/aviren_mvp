import 'package:flutter/material.dart';
import 'package:flutter1/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter1/screen/mail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter1/screen/LivingRoom.dart';
import 'package:flutter1/screen/login_page.dart';

class HomeScreen extends StatefulWidget {
  final String email;

  const HomeScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  Future<void> updateOpenedLetter(bool newValue) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.email).update({
        'openedLetter': newValue,
      });
    } catch (e) {
      print('Error updating openedLetter: $e');
    }
  }
  Future<void> updateUnixTimestamp() async {
    // Retrieve the current user data
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('users').doc(widget.email).get();
      // Save DateTime and unixTimestamp only if openedLetter is false
      DateTime now = DateTime.now();
      int unixTimestamp = now.toUtc().millisecondsSinceEpoch ~/ 1000;

      await FirebaseFirestore.instance.collection('users').doc(widget.email).update({
        'unix': unixTimestamp,
      });
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

    return WillPopScope(
      onWillPop: () async {
        // Show the options dialog when the back button is pressed
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
                        primary: Colors.black, // Red color
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        // Return false to prevent the default back button behavior
        return false;
      },
      child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('users').doc(widget.email).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            bool openedLetter = snapshot.data?.data()?['openedLetter'] ?? false;
            if (!openedLetter){
              updateUnixTimestamp();
            }


            return Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  openedLetter ? "assets/Front Door1.png" : "assets/Alert Door.png",
                  fit: BoxFit.cover,
                  width: screenWidth,
                  height: screenHeight,
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  resizeToAvoidBottomInset: false,
                  body: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0.0, right: 13.0, top: 0.0, bottom: 9.0),
                            child: GestureDetector(
                              onTap: () async {
                                await updateOpenedLetter(true);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MailScreen(
                                      email: widget.email,
                                      onBack: () {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 60,
                                height: 65,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 250, right: 90),
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => LivingRoom(email: widget.email)),
                                );
                              },
                              child: Container(
                                width: 200,
                                height: 390,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only( top: 80,right: 5), // Add your desired padding values
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
                                              primary: Colors.black, // Red color
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
          }
        },
      ),
    );
  }
}

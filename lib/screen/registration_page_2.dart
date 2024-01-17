import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter1/screen/login_page.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter1/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter1/screen/lettercontent.dart';

class RegistrationPage2 extends StatefulWidget {
  final String email;
  final String password;
  final DateTime? selectedDate;
  final Function signUpCallback;

  RegistrationPage2({
    required this.email,
    required this.password,
    required this.selectedDate,
    required this.signUpCallback,
  });

  @override
  State<RegistrationPage2> createState() => _RegistrationPage2State();
}

class UserData {
  static final UserData _instance = UserData._internal();

  factory UserData() {
    return _instance;
  }

  UserData._internal();

  String firstName = '';

}


class _RegistrationPage2State extends State<RegistrationPage2> {
  final _formkey = GlobalKey<FormState>();
  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    MyApp.audioPlayer.play(AssetSource('avirensong.mp3'));
    MyApp.audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    super.dispose();
  }


  void showError(String message) {
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your First Name';
        } else if (int.tryParse(value) != null) {
          return 'First Name must be a string';
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!.toLowerCase();
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "First Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final secondNameField = TextFormField(
      autofocus: false,
      controller: secondNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value != null && int.tryParse(value) != null) {
          return 'Second Name must be a string';
        }
        return null;
      },
      onSaved: (value) {
        secondNameEditingController.text = value?.toLowerCase() ?? '';
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Second Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        onPressed: () async {
          if (_formkey.currentState!.validate()) {
            saveDataToFirebase();
            widget.signUpCallback();

            Fluttertoast.showToast(msg: 'Signup Successful');

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        },
        child: Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Stack(
        children: [
          
          Image.asset(
            "assets/LOGIN9.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
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
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(child: Text("What's your Name?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)))
                            ],
                          ),
                          SizedBox(height: 35),
                          firstNameField,
                          SizedBox(height: 20),
                          secondNameField,
                          SizedBox(height: 20),
                          signUpButton,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ]
    );
  }

  String sha256Hash(String input) {
    var bytes = utf8.encode(input); 
    var digest = sha256.convert(bytes); 
    return digest.toString(); 
  }

  void saveDataToFirebase() {
    
    String generatedLetter1 = "It's Mom! Hope you're settling well in the new neighborhood! Let me know what's happening in your world. I could lend you an ear or two just for you!";
    String generatedLetter2 = "P.S. drop me a reply to let me know you've arrived, I have a lil' surprise for you inside the house.";

    UserData().firstName = firstNameEditingController.text;

    _firestore.collection('users').doc(widget.email).set({
      'email': widget.email,
      'password': sha256Hash(widget.password),
      'firstName': firstNameEditingController.text,
      'secondName': secondNameEditingController.text,
      'generatedLetter_title': "Hey " + firstNameEditingController.text,
      'generatedLetter_header1': generatedLetter1,
      'generatedLetter_header2': generatedLetter2,
      'generatedLetter_end': "Love, Mom",
      'responseLetter_title': "Hi Mom!",
      'responseLetter': "Empty",
      'responseLetter_end': "With warmth, " + firstNameEditingController.text,
      'readTime': -1,
      'openedLetter': false,
      'respondLetter': false,
      'userHistory': '',
      'botHistory': '',
      'unix': 0,
    });
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'registration_page_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter1/screen/login_page.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter1/main.dart';
import 'package:audioplayers/audioplayers.dart';

class Registrationscreen extends StatefulWidget {
  const Registrationscreen({Key? key}) : super(key: key);


  @override
  State<Registrationscreen> createState() => _RegistrationscreenState();
}

class _RegistrationscreenState extends State<Registrationscreen> {
  bool _isValidBetaKey = false;
  DateTime? selectedDate;
  String? _ageValidationError;
  String? _selectedDateError;
  final _formkey = GlobalKey<FormState>();
  final emailNameEditingController = TextEditingController();
  final passwordNameEditingController = TextEditingController();
  final accessKeyEditingController = TextEditingController();
  final emailErrorTextController = TextEditingController();
  final accessKeyErrorTextController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String sha256Hash(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
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

  Future<void> signUp() async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: emailNameEditingController.text,
        password: sha256Hash(passwordNameEditingController.text),
      );
      if (userCredential.user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
      }
    } catch (e) {
      print('Error during registration: $e');
    }
  }

  Future<bool> checkEmailExistence(String email) async {
    DocumentSnapshot snapshot =
    await _firestore.collection('users').doc(email).get();
    return snapshot.exists;
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;

    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  void navigateToRegistrationPage2() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationPage2(
          email: emailNameEditingController.text,
          password: passwordNameEditingController.text,
          selectedDate: selectedDate,
          signUpCallback: signUp,
        ),
      ),
    );
  }

  void clearErrorMessages() {
    setState(() {
      emailErrorTextController.text = '';
      _ageValidationError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pickupDateField = InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.calendar_today),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Birth Date",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                  : 'Birth Date',
            ),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );

    final emailNameField = TextFormField(
      autofocus: false,
      controller: emailNameEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return "Please Enter a valid email";
        }
        return null;
      },
      onSaved: (value) {
        emailNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Enter Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final passwordNameField = TextFormField(
      autofocus: false,
      controller: passwordNameEditingController,
      obscureText: true,
      onSaved: (value) {
        passwordNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Enter Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );


    final nextButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          clearErrorMessages();

          if (_formkey.currentState!.validate()) {
            bool isEmailExist =
            await checkEmailExistence(emailNameEditingController.text);

            if (isEmailExist) {
              setState(() {
                emailErrorTextController.text = 'Email has already been used';
              });
              return;
            }

            if (selectedDate == null) {
              setState(() {
                _selectedDateError = 'Please select your birth date';
              });
              return;
            }

            int age = calculateAge(selectedDate!);
            if (age < 13) {
              setState(() {
                _ageValidationError =
                'User must be at least 13 years old to sign up.';
              });
              return;
            }

            navigateToRegistrationPage2();
          }
        },
        child: Text(
          "Next",
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
          // Background Image
          Image.asset(
            "assets/LOGIN9.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,resizeToAvoidBottomInset: false,
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
                              Expanded(child: Text('Create your Account',textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold)))
                            ],
                          ),
                          SizedBox(height: 20),
                          emailNameField,
                          if (emailErrorTextController.text.isNotEmpty &&
                              (_ageValidationError == null ))
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 7.0,
                                right: 140.0,
                              ),
                              child: Text(
                                emailErrorTextController.text,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          SizedBox(height: 20),
                          passwordNameField,
                          SizedBox(height: 20),
                          pickupDateField,
                          Column(
                            children: [
                              if (_ageValidationError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    _ageValidationError!,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 20),
                          nextButton,
                          SizedBox(height: 200),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )]
    );
  }
}
import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/screen/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'registration_page.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter1/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter1/screen/privacy.dart';
import 'package:flutter1/screen/terms.dart';
import 'package:flutter/services.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final _auth = FirebaseAuth.instance;


  @override
  void initState() {
    super.initState();
    print('Before audio player initialization');
    MyApp.audioPlayer.play(AssetSource('avirensong.mp3'));
    print('After audio player initialization');
    MyApp.audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //email.field
    final emailField = TextFormField(

      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Please Enter Valid Password (Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(5),
      color: Color.fromRGBO(128, 70, 27, 10),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          minWidth: MediaQuery
              .of(context)
              .size
              .width,

          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: Text("Login", textAlign: TextAlign.center, style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );


    return WillPopScope(
        onWillPop: () async {
      // Handle back button press
      SystemNavigator.pop(); // Close the app
      return false; // Return true to allow back button press, false to block it
    },
      child : Stack(
        children: [
          // Background Image
          Image.asset(
            "assets/LOGIN8.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Scaffold(
            backgroundColor: Colors.transparent, resizeToAvoidBottomInset: false,
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
                          SizedBox(height: 150),
                          emailField,
                          SizedBox(height: 25),
                          passwordField,
                          SizedBox(height: 35),
                          loginButton,
                          SizedBox(height: 15),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text('or',textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Registrationscreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(text: "By continuing, you agree to our "),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(
                                    color: Colors.brown,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => privacy(), // Replace with your Privacy Policy screen
                                        ),
                                      );
                                    },
                                ),
                                TextSpan(text: " and ",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: "Terms & Conditions",
                                  style: TextStyle(
                                      color: Colors.brown,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => terms(), // Replace with your Privacy Policy screen
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ]
    ));
  }

  String sha256Hash(String input) {
    var bytes = utf8.encode(input); // Encode the input string as UTF-8
    var digest = sha256.convert(bytes); // Calculate the hash
    return digest.toString(); // Return the hash as a string
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: sha256Hash(password));

        // If login is successful, navigate to HomeScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen(email: emailController.text)),
        );
        Fluttertoast.showToast(msg: "Login Successful");
      } on FirebaseAuthException catch (e) {
        // Handle specific Firebase authentication exceptions
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(msg: 'User not found. Please sign up.');
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(msg: 'Incorrect password. Please try again.');
        } else {
          Fluttertoast.showToast(msg: 'Error: "Authentication failed. Please check your email and password".');
        }
      } catch (e) {
        // Handle other unexpected errors
        Fluttertoast.showToast(msg: 'Unexpected error: $e');
      }
    }
  }
}

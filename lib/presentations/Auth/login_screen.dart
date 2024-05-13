// import 'dart:math';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_friend/presentations/home_screens.dart';

import '../../Api/apis.dart';
import '../../main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../utils/dialogs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  _handleGoogleBtnClick() {
    // for showing progress Bar
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      // circular indicator finishes or hiding circular indicator
      Navigator.pop(context);

      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeScreen()));
          });
        }
      }
      ;
    });

    // return _signInWithGoogle();
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n__signInWithGoogle: $e');
      Dialogs.showSnackbar(
          context, 'Something went Wrong with (Check Internet!)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'TalkLink',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
              top: mq.height * .10,
              width: mq.width * .5,
              left: mq.width * .25,
              child: Image.asset('images/chat.png')),
          Positioned(
              bottom: mq.height * .15,
              width: mq.width * .9,
              left: mq.width * .05,
              height: mq.height * .07,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    shape: StadiumBorder(),
                    elevation: 10),
                onPressed: () {
                  _handleGoogleBtnClick().then((user) {
                    print('\nUser: ${user.user}');
                    print('\nUserAdditionalInfo:${user.additionalUserInfo} ');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => HomeScreen()));
                  }).catchError((error) {
                    // Handle error if any
                    print("Error: $error");
                  });
                },
                icon: Image.asset('images/google.png', height: mq.height * .05),
                label: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 19),
                        children: [
                      TextSpan(text: 'Sign In with'),
                      WidgetSpan(
                        child: SizedBox(
                            width: 5), // Adjust the width for desired space
                      ),
                      TextSpan(
                          text: 'Google',
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ])),
              ))
        ],
      ),
    );
  }
}

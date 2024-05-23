import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:your_friend/presentations/Auth/login_screen.dart';
import 'package:your_friend/presentations/home_screens.dart';

import '../Api/apis.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {
      // exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(systemNavigationBarColor: Colors.white24));

      if (APIs.auth.currentUser != null) {
        log('\nUser: ${APIs.auth.currentUser}');
        // Navigate to loginscreen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        // Navigate to loginscreen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Positioned(
            top: mq.height * .15,
            width: mq.width * .5,
            left: mq.width * .25,
            child: Image.asset('images/chat.png')),
        Positioned(
          bottom: mq.height * .20,
          width: mq.width * .8,
          left: mq.width * .15,
          child: Text('True Friend made with love❤️',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, color: Colors.black)),
        ),
      ]),
    );
  }
}

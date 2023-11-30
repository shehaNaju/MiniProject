import 'dart:async';

import 'package:blood_bank/Mobilennew/mobileneter.dart';
import 'package:blood_bank/Screens/LoginPage.dart';
import 'package:blood_bank/Screens/MainPage.dart';
import 'package:blood_bank/Screens/otppage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late bool newuser = true;

  @override
  void initState() {
    super.initState();

    check_if_already_login();
    Timer(Duration(seconds: 5), () {
      if (newuser == false) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen(selectedIndex: 0,)));
      } 
      else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => mobileverification()
            ));
      }
    });
  }
  

  void check_if_already_login() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    newuser = (pref.getBool('login') ?? true);
    // print("newwwww----" + newuser.toString());

    setState(() {
      newuser = (pref.getBool('login') ?? true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:
        Stack(
          children: [
            Image.asset(
              'assets/images/splash1.webp',
            ),
              
          ],
        ),
      ),
    );
  }
}

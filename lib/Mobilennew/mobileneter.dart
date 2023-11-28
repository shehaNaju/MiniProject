import 'dart:convert';
import 'dart:developer';
import 'package:blood_bank/Screens/AdminPage.dart';
import 'package:blood_bank/Screens/MainPage.dart';
import 'package:blood_bank/URL/url.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/support/code_country.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class mobileverification extends StatefulWidget {
  @override
  mobileverificationState createState() => mobileverificationState();
}

class mobileverificationState extends State<mobileverification> {
  // String? token;
  CountryCode? countryCode;

  var otp;
  var size, height, width;
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  TextEditingController phoneController = TextEditingController();
  final otpController = TextEditingController();
  var formkey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;
  late SharedPreferences registerData;
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        checkloginsystem(phoneController.text);
        log("success");
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      print("message======" + e.message.toString());
      // _scaffoldKey.currentState!
      //     .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> checkloginsystem(String mobileno) async {
    // setState(() {
    //   isloading = true;
    // });
    Map data = {
      'mobileno': mobileno,
    };
    print(data.toString());
    final response = await http.post(
      Uri.parse(mainurl().url + "login.jsp"),
      body: data,
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

      if (resposne['msg'].toString().contains("success")) {
        String type = resposne['type'].toString();
        SharedPreferences logindata = await SharedPreferences.getInstance();
        logindata.setString("mobileno", mobileno);
        logindata.setString("type", type);
        logindata.setBool("login", false);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen(selectedIndex: 0,)));

        print("Login Successfully Completed !!!!!!!!!!!!!!!!");
      } else if (resposne['msg'].toString().contains("failed")) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => AdminPage(mobileno:mobileno)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.green,
        ));
      }
    } else {
      print("Please try again!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
  }

  getMobileFormWidget(context) {
  
    return Form(
      key: formkey,
  
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            //  Spacer(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                  'assets/images/loginpage.webp'),
            ),
           SizedBox(height: 38,),
            // Spacer(),
            Text(
              'OTP VERIFICATION ',
              textAlign: TextAlign.center,
              style:TextStyle(fontWeight:FontWeight.bold,fontSize: 25 )
                
            ),
            // SizedBox(
            //   height: 15,
            // ),
            // Text(
            //   'We will send you an one time otp on  this mobile number',
            //   textAlign: TextAlign.center,
            //    style:TextStyle(fontWeight:FontWeight.normal,fontSize: 15 )
            //   // style: FontStyle(),
            // ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                //   height: 85,
                child: TextFormField(
                  validator: (value) {
                    if (value!.length < 10) {
                      return 'Please enter a valid mobile number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: phoneController,
                  maxLength: 10,
                  style: GoogleFonts.robotoMono(
                      fontSize: 17, fontWeight: FontWeight.w800),
                  decoration: InputDecoration(
                  hintText: "Enter your number",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(70),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(70),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    prefix: CountryListPick(
                        appBar: CupertinoNavigationBar(
                          middle: Text('Select country'),
                        ),
                        theme: CountryTheme(
                          isShowFlag: true,
                          isShowTitle: false,
                          isShowCode: true,
                          isDownIcon: true,
                          showEnglishName: false,
                        ),
                        // Set default value
                        initialSelection: '+91',
                        // or
                        // initialSelection: 'US'
                        onChanged: (CountryCode? code) {
                          print(code!.dialCode);
                          countryCode = code;
                        },
                        // Whether to allow the widget to set a custom UI overlay
                        useUiOverlay: true,
                        // Whether the country list should be wrapped in a SafeArea
                        useSafeArea: false),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                log(countryCode.toString());
      
                if (phoneController.text.length == 10) {
                  setState(() {
                    showLoading = true;
                  });
                  await _auth.verifyPhoneNumber(
                    phoneNumber: countryCode == null
                        ? "+91" + phoneController.text
                        : countryCode.toString() + phoneController.text,
                    verificationCompleted: (phoneAuthCredential) async {
                      setState(() {
                        showLoading = false;
                      });
                    },
                    verificationFailed: (verificationFailed) async {
                      setState(() {
                        showLoading = false;
                      });
                      print("verificationFailed message" +
                          verificationFailed.message.toString());
                    },
                    codeSent: (verificationId, resendingToken) async {
                      setState(() {
                        showLoading = false;
                        currentState =
                            MobileVerificationState.SHOW_OTP_FORM_STATE;
                        this.verificationId = verificationId;
                      });
                    },
                    codeAutoRetrievalTimeout: (verificationId) async {},
                  );
                }
                // if (countryCode != null) {
                //   log(countryCode!.dialCode.toString() + phoneController.text);
      
                // }
              },
              child: Text(
                "REQUEST OTP",
                style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
              ),
             style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        getloginotpwidget(context),
        Spacer(),
        Text(
          'ENTER OTP',
          style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Pinput(
            length: 6,
            onChanged: (val) {
              if (val.length == 6) {
                log(val);
                otp = val;
                log('assigned otp' + otp.toString());
              }
            },
          ),
        ),
        SizedBox(
          height: 16,
        ),
        ElevatedButton(
            onPressed: () async {
              log("inside onpress" + otp.toString());
              PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId, smsCode: otp.toString());

              signInWithPhoneAuthCredential(phoneAuthCredential);

              //    Navigator.pushReplacement(
              // context, MaterialPageRoute(builder: (context) => dashboard()));
            },
            child: Text(
              "VERIFY",
              style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
            ),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.black38,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side:
                            BorderSide(color: Color.fromARGB(255, 0, 0, 0)))))),
        Spacer(
          flex: 2,
        ),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          width: double.infinity,
          color: Colors.white,
          // decoration: BoxDecoration(
          //     gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          //   Color.fromARGB(255, 192, 222, 227),
          //   Color.fromARGB(255, 235, 230, 230),
          //   Color.fromARGB(255, 242, 241, 239)
          // ])),
          child: showLoading
              ? Center(
                  child: const SpinKitSquareCircle(
                  color: Color.fromARGB(255, 22, 22, 20),
                  size: 30.0,
                ))
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }

  getlogiphonnwidget(context) {
    return Container(
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //          SizedBox(height: 80,),
      //       Padding(
      //         padding: EdgeInsets.all(20),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: <Widget>[
      //           //  FadeAnimation(1,
      //              Text("Login", style: TextStyle(color: Colors.white, fontSize: 40),),
      //            //  ),
      //             SizedBox(height: 10,),
      //           //  FadeAnimation(1.3,
      //              Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)
      //           //   ),
      //           ],
      //         ),
      //       ),
      //     // Icon(
      //     //   size: 100,
      //     //   Icons.person_pin,
      //     // )
      //   ],
      // ),
      height: height / 10,
      //color: Color.fromARGB(255, 184, 9, 9),
    );
  }

  getloginotpwidget(context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //   children: [Icon(size: 100, Icons.lock_person_sharp)],
      ),
      height: height / 10,
      //color: Color.fromARGB(255, 184, 9, 9),
    );
  }
}

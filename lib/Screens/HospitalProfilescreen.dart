import 'dart:convert';


import 'package:blood_bank/Model/HospitalProfileModel.dart';
import 'package:blood_bank/Screens/BlooadUpdatePage.dart';
import 'package:blood_bank/Screens/EditUserprofile.dart';
import 'package:blood_bank/Screens/LoginPage.dart';
import 'package:blood_bank/URL/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class hospitalProfileScreen extends StatefulWidget {
  const hospitalProfileScreen({super.key});

  @override
  State<hospitalProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<hospitalProfileScreen> {
  List<String> options = ['A+', 'B+', 'O+'];

  String _value = 'First Item';
  bool isloading = false;
  late HospitalProfileModel mainmodel;
  List<BloodstockHospital> blstock = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Fecthdatails();
  }

  Future<void> Fecthdatails() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    String mobileno = logindata.getString("mobileno")!;

    setState(() {
      isloading = true;
    });
    Map data = {
      'mobileno': mobileno,
    };
    print(data.toString());
    final response = await http.post(
      Uri.parse(mainurl().url + "gethospitalprofiledetails.jsp"),
      body: data,
    );

    print("sssssssssssssss----" + response.body);
    setState(() {
      isloading = false;
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      var userData = responseData;
      HospitalProfileModel ws = HospitalProfileModel.fromJson(userData);
      mainmodel = ws;
      blstock = ws.bloodstocks;
    } else {
      print("Please try again!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("insideeeeee");
    return SafeArea(
        child: Scaffold(
            body: Container(
      padding: EdgeInsets.only(left: 15, top: 30, right: 15, bottom: 50),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: isloading == true
            ? Center(child: CircularProgressIndicator())
            : blstock.isEmpty
                ? CircularProgressIndicator()
                : ListView(children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 250,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 4, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1))
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      mainurl().imageurl + mainmodel.image,
                                    ))),
                          ),
                          // Positioned(
                          //   bottom: 0,
                          //   right: 0,
                          //   child: Container(
                          //     height: 40,
                          //     width: 40,
                          //     decoration: BoxDecoration(
                          //       shape: BoxShape.circle,
                          //       border: Border.all(
                          //         width: 4,
                          //         color: Colors.white,

                          //       ),
                          //       color: Colors.blue,
                          //     ),
                          //     child: Icon(
                          //       Icons.edit,
                          //       color: Colors.white,
                          //     ),
                          //   ))
                        ],
                      ),
                    ),
                    // SizedBox(height: 30,),
                    Column(
                      children: [
                        Text(
                          "Hospital Name: " + mainmodel.hospitalname,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Address: " + mainmodel.address,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "City: " + mainmodel.place,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            child: Column(children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Blood Available Details ",
                                      textScaleFactor: 1.5,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    bloodupdatepage(
                                                        id: mainmodel.id)));
                                      },
                                      icon: Icon(Icons.edit))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Table(
                                  // textDirection: TextDirection.rtl,
                                  // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                                  // border:TableBorder.all(width: 2.0,color: Colors.red),
                                  children: [
                                    TableRow(children: [
                                      Text(
                                        "Blood Group",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 18),
                                      ),
                                      Text(
                                        "Units",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 18),
                                      ),
                                      // Text("Branch",textScaleFactor: 1.5),
                                    ]),
                                    TableRow(children: [
                                      ListView.builder(
                                          itemCount: blstock.length,
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return (Text(
                                              blstock[index].bllodgroupname,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 15),
                                            ));
                                          }),
                                      ListView.builder(
                                          itemCount: blstock.length,
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return (Text(
                                              blstock[index].bloodunitcount,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 15),
                                            ));
                                          }),
                                    ]),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () async {
                            showAlertDialog(context);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.lock,
                                size: 24,
                              ),
                              Text(
                                "Logout",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditUserProfileScreen(
                                        name: mainmodel.hospitalname,
                                        address: mainmodel.address,
                                        city: mainmodel.place,
                                        image: mainmodel.image,
                                        type: "1")));
                          },
                          child: Text("Edit",
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2,
                                  color: Colors.black)),
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {},
                        //   child: Text(
                        //     "SAVE",
                        //     style: TextStyle(
                        //         fontSize: 15,
                        //         letterSpacing: 2,
                        //         color: Colors.white),
                        //   ),
                        //   style: OutlinedButton.styleFrom(
                        //       padding: EdgeInsets.symmetric(horizontal: 50),
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(20))),
                        // ),
                      ],
                    )
                  ]),
      ),
    )));
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        SharedPreferences logindata = await SharedPreferences.getInstance();
        logindata.setString("mobileno", "");
        logindata.setString("type", "");
        logindata.setBool("login", true);

// chnages here to otp page


        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are you sure want to logout"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

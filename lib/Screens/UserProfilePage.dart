import 'dart:convert';


import 'package:blood_bank/Mobilennew/mobileneter.dart';
import 'package:blood_bank/Screens/AddNewBloodGroup.dart';
import 'package:blood_bank/Screens/DonarsPage.dart';
import 'package:blood_bank/Screens/EditUserprofile.dart';
import 'package:blood_bank/Screens/LoginPage.dart';
import 'package:blood_bank/URL/url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<UserProfileScreen> {
  List<String> options = ['A+', 'B+', 'O+'];

  String _value = 'First Item';
  bool isloading = false;
  String blood = "",
      name = "",
      address = "",
      place = "",
      district = "",
      image = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Fecthdatails();
  }

  Future<void> Fecthdatails() async {
    print("object");
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
      Uri.parse(mainurl().url + "getprofiledetails.jsp"),
      body: data,
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

      if (resposne['msg'].toString().contains("success")) {
        //print("Login Successfully Completed !!!!!!!!!!!!!!!!");

        setState(() {
          blood = resposne['blood'].toString();
          name = resposne['name'].toString();
          address = resposne['address'].toString();
          place = resposne['place'].toString();
          district = resposne['district'].toString();
          image = resposne['image'].toString();

          isloading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Somethng went wrong .........'),
          backgroundColor: Colors.green,
        ));
      }
    } else {
      print("Please try again!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
  }

  @override
  Widget build(BuildContext context) {
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
            : ListView(children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 250,
                        decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.white),
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
                                  mainurl().imageurl + image,
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
                   TextFormField(
                        decoration: InputDecoration(
                      hintText: "Name : " + name,
                  
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.white.withOpacity(0.9),
                            filled: true,
                            prefixIcon: const Icon(Icons.person,color: Colors.red,)),
                    ),
                    //      Text(
                    //   "Name: " + name,
                    //   style: TextStyle(
                    //       color: Colors.black, fontWeight: FontWeight.bold),
                    // ),


    //                 
    
               
                    const SizedBox(height: 20),

               TextFormField(
                        decoration: InputDecoration(
                    hintText:  "Address  : " +  address,
                       border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.white.withOpacity(0.9),
                            filled: true,
                             prefixIcon: const Icon(Icons.person,color: Colors.red,)),

                    
                    ),

                     const SizedBox(height: 20),
                    TextFormField(
                       decoration: InputDecoration(
                    hintText:  "City : " + place,
                     border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.white.withOpacity(0.9),
                            filled: true,
                             prefixIcon: const Icon(Icons.person,color: Colors.red,)),

                    
                    ),
                    SizedBox(height: 20),
                    // DropdownButton(
                    //   value: _value,
                    //   items: options
                    //       .map((e) => DropdownMenuItem(
                    //             child: Text(e.toString()),
                    //             value: e.toString(),
                    //           ))
                    //       .toList(),
                    //   onChanged: (newValue) {
                    //     setState(() {
                    //       _value = newValue.toString();
                    //     });
                    //   },
                    // ),

                         TextFormField(
                          
                       decoration: InputDecoration(
                     hintText: "Blood Group: " + blood,
                      border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.white.withOpacity(0.9),
                            filled: true,
                             prefixIcon: const Icon(Icons.person,color: Colors.red,)),

                    
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
                                      name: name,
                                      address: address,
                                      city: place,
                                      image: image,
                                      type: "0",
                                    )));
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
            context, MaterialPageRoute(builder: (context) => mobileverification()));
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

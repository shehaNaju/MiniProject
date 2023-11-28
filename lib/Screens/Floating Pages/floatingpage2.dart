import 'dart:convert';


import 'package:blood_bank/Model/ViewBlood.dart';
import 'package:blood_bank/Model/ViewHSModel.dart';
import 'package:blood_bank/Model/ViewPlace.dart';
import 'package:blood_bank/Screens/MainPage.dart';
import 'package:blood_bank/URL/url.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FloattingScreen2 extends StatefulWidget {
  const FloattingScreen2({super.key});

  @override
  State<FloattingScreen2> createState() => _FloattingScreenState();
}

class _FloattingScreenState extends State<FloattingScreen2> {
  final formKey = GlobalKey<FormState>();

  DateTime dateTime = DateTime.now();
  TextEditingController _textControllerdate1 = new TextEditingController();

  TextEditingController ctrdonarname = new TextEditingController();
  TextEditingController ctrdonarmbno = new TextEditingController();
  TextEditingController ctrdonarwhno = new TextEditingController();
  TextEditingController ctrdonaraddress = new TextEditingController();
  TextEditingController ctrdonarmessage = new TextEditingController();
  String choosedoptionblood = "select blood group";
  String choosedoptionplace = "select your place";
  bool isloading = false;

  late dynamic dropdownValue = null;
  late dynamic dropdownValue2 = null;
  late dynamic dropdownValue3 = null;
  String Bloodid = "", Placeid = "", Hsid = "";
  List<ViewBloodModel> bloodgrouplist = [];
  List<ViewPlaceModel> placegrouplist = [];
  List<ViewHSModel> hslist = [];

  _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1850),
        lastDate: DateTime(2101));
    if (picked != null) {
      dateTime = picked;
      //assign the chosen date to the controller
      _textControllerdate1.text = DateFormat.yMd().format(dateTime);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBloodGroups();
    getPlaceGroups();
  }

  getBloodGroups() async {
    bloodgrouplist = await getbloodgrouplistListGET();
    setState(() {});
  }

  getPlaceGroups() async {
    placegrouplist = await getplacegroupListGET();
    setState(() {});
  }

  getHs(String placeid) async {
    hslist = await getHslist(placeid);
    setState(() {});
  }

  Future<List<ViewBloodModel>> getbloodgrouplistListGET() async {
    try {
      final response = await http.get(
        Uri.parse(mainurl().url + "getbloodgroup.jsp"),
      );
      if (response.statusCode == 200) {
        List res = jsonDecode(response.body);
        return res.map((e) => ViewBloodModel.fromJson(e)).toList();
      }
    } catch (e) {}
    return bloodgrouplist;
  }

  Future<List<ViewPlaceModel>> getplacegroupListGET() async {
    try {
      final response = await http.get(
        Uri.parse(mainurl().url + "getnearestplace.jsp"),
      );
      if (response.statusCode == 200) {
        List res = jsonDecode(response.body);
        return res.map((e) => ViewPlaceModel.fromJson(e)).toList();
      }
    } catch (e) {}
    return placegrouplist;
  }

  Future<List<ViewHSModel>> getHslist(String placeid) async {
    try {
      final response = await http.post(
        Uri.parse(mainurl().url + "gethospit.jsp"),
        body: {"placeid": placeid},
      );
      if (response.statusCode == 200) {
        List res = jsonDecode(response.body);
        return res.map((e) => ViewHSModel.fromJson(e)).toList();
      }
    } catch (e) {}
    return hslist;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dropdownValue = null;
        dropdownValue2 = null;
        dropdownValue3 = null;
        return Navigator.canPop(context);
      },
      child: SafeArea(
          child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 15, top: 30, right: 15, bottom: 50),
          child: ListView(children: [
            Center(
                child: Text(
              "Request for the doners",
              style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )
                //  Stack(
                //   children: [
                // Container(
                //   width: 130,
                //   height: 250,
                //   decoration: BoxDecoration(
                //     border: Border.all(width: 4,color: Colors.white),
                //     boxShadow: [
                //       BoxShadow(
                //         spreadRadius: 2,
                //         blurRadius: 10,
                //         color: Colors.black.withOpacity(0.1)
                //       )
                //     ],
                //     shape: BoxShape.circle,
                //     image: DecorationImage(
                //       fit:  BoxFit.cover,
                //       image: AssetImage('assets/images/personal.png',))
                //   ),
                // ),

                // ],),
                ),
            SizedBox(
              height: 50,
            ),
            Container(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: ctrdonarname,
                      decoration: InputDecoration(
                          hintText: "Enter the Acceptor Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.white.withOpacity(0.9),
                          filled: true,
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.red,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: ctrdonarmbno,
                      decoration: InputDecoration(
                        hintText: " Enter the Mobile Number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Colors.white.withOpacity(0.9),
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.red,
                        ),
                      ),
                      // obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: ctrdonarwhno,
                      decoration: InputDecoration(
                        hintText: "Enter the whatsapp Number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Colors.white.withOpacity(0.9),
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.chat,
                          color: Colors.red,
                        ),
                      ),
                      // obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),

                    TextFormField(
                      controller: ctrdonaraddress,
                      decoration: InputDecoration(
                          hintText: " Enter the Address",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.white.withOpacity(0.9),
                          filled: true,
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.red,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    InkWell(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.white.withOpacity(0.9),
                          filled: true,
                          hintText: 'Enter the date',
                          prefixIcon: const Icon(
                            Icons.calendar_month,
                            color: Colors.red,
                          ),
                        ),
                        readOnly: true, //this is important
                        onTap: _selectDate, //the method for opening data picker
                        controller: _textControllerdate1,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black), //the controller
                      ),
                    ),

                    const SizedBox(height: 20),

                    //Flexible(fit: FlexFit.tight, child: SizedBox()),
                    bloodgrouplist.isEmpty
                        ? const CircularProgressIndicator()
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    18), // <= No more error here :)
                                color: Colors.white),
                            width: 400,
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Icon(Icons.bloodtype),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: DropdownButton<ViewBloodModel>(
                                      hint: const Text("Select Blood group"),
                                      underline: SizedBox(),
                                      value: dropdownValue,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      borderRadius: BorderRadius.zero,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 18),
                                      // underline: Container(
                                      //  height: 2,
                                      //  color: Colors.deepPurpleAccent,
                                      // ),
                                      onChanged: (ViewBloodModel? data) {
                                        setState(() {
                                          dropdownValue = data!;

                                          Bloodid = data.id;

                                          //                              Dis = data.name;
                                          //                           d_id=   int.parse(data.id);

                                          // print(dropdownValue.name +
                                          //     " " +
                                          //     dropdownValue.id.toString());
                                          // log("id : ${dropdownValue.id}");
                                          // FplaceValue = null;
                                          // TplaceValue = null;

                                          // getPlaces();
                                        });
                                      },
                                      items: bloodgrouplist.map<
                                              DropdownMenuItem<ViewBloodModel>>(
                                          (ViewBloodModel value) {
                                        return DropdownMenuItem<ViewBloodModel>(
                                          value: value,
                                          child: Text(value.name),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),

                    placegrouplist.isEmpty
                        ? const CircularProgressIndicator()
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  18), // <= No more error here :)
                              color: Colors.white,
                            ),
                            width: 400,
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Icon(Icons.place),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: DropdownButton<ViewPlaceModel>(
                                      hint: const Text(
                                          "Select your nearest place"),
                                      underline: SizedBox(),
                                      value: dropdownValue2,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      borderRadius: BorderRadius.zero,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 18),
                                      // underline: Container(
                                      //  height: 2,
                                      //  color: Colors.deepPurpleAccent,
                                      // ),
                                      onChanged: (ViewPlaceModel? data) {
                                        setState(() {
                                          dropdownValue2 = data!;

                                          Placeid = data.id;

                                          //                              Dis = data.name;
                                          //                           d_id=   int.parse(data.id);

                                          // print(dropdownValue.name +
                                          //     " " +
                                          //     dropdownValue.id.toString());
                                          // log("id : ${dropdownValue.id}");
                                          // FplaceValue = null;
                                          // TplaceValue = null;

                                          // getPlaces();
                                        });
                                        getHs(Placeid);
                                        // getHslist(Placeid);
                                      },
                                      items: placegrouplist.map<
                                              DropdownMenuItem<ViewPlaceModel>>(
                                          (ViewPlaceModel value) {
                                        return DropdownMenuItem<ViewPlaceModel>(
                                          value: value,
                                          child: Text(value.place),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    hslist.isEmpty
                        ? const CircularProgressIndicator()
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    18), // <= No more error here :)
                                color: Colors.white),
                            width: 400,
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Icon(Icons.local_hospital),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: DropdownButton<ViewHSModel>(
                                      hint: const Text(
                                          "Select your nearest hospital"),
                                      underline: SizedBox(),
                                      value: dropdownValue3,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      borderRadius: BorderRadius.zero,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 18),
                                      // underline: Container(
                                      //  height: 2,
                                      //  color: Colors.deepPurpleAccent,
                                      // ),
                                      onChanged: (ViewHSModel? data) {
                                        setState(() {
                                          dropdownValue3 = data!;

                                          Hsid = data.id;

                                          //                              Dis = data.name;
                                          //                           d_id=   int.parse(data.id);

                                          // print(dropdownValue.name +
                                          //     " " +
                                          //     dropdownValue.id.toString());
                                          // log("id : ${dropdownValue.id}");
                                          // FplaceValue = null;
                                          // TplaceValue = null;

                                          // getPlaces();
                                        });
                                      },
                                      items: hslist
                                          .map<DropdownMenuItem<ViewHSModel>>(
                                              (ViewHSModel value) {
                                        return DropdownMenuItem<ViewHSModel>(
                                          value: value,
                                          child: Text(value.hsname),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white.withOpacity(0.5),
                        ),
                        height: 200,
                        width: 350,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Type a message request "),
                          ),
                        )),

                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _submit(
                              ctrdonarname.text,
                              ctrdonarmbno.text,
                              ctrdonarwhno.text,
                              ctrdonaraddress.text,
                              _textControllerdate1.text,
                              Bloodid,
                              Placeid,
                              Hsid);

                          //check if form data are valid,
                          // your process task ahed if all data are valid
                        }
                      },
                      child: isloading == true
                          ? CircularProgressIndicator()
                          : Text(
                              "ACCEPTER",
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2,
                                  color: Colors.white),
                            ),
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ]),
        ),
      )),
    );
  }

  Future<void> _submit(String name, String mbno, String whatsno, String address,
      String date, String blood, String place, String hspital) async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    String mainno = logindata.getString("mobileno")!;

    if (Placeid.toString() != "" &&
        Bloodid.toString() != "".toString() &&
        Hsid != "") {
      setState(() {
        isloading = true;
      });
      Map data = {
        'name': name,
        'mobileno': mainno,
        'mbnoblood': mbno,
        'whatsno': whatsno,
        'address': address,
        'date': date,
        'bloodid': blood,
        'placeid': place,
        'hsid': hspital,
        'type': "1", // accepter ===1
      };
      print(data.toString());
      final response = await http.post(
        Uri.parse(mainurl().url + "bloodreqest.jsp"),
        body: data,
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);

        if (resposne['msg'].toString().contains("success")) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(selectedIndex: 2,)));

          print("Login Successfully Completed !!!!!!!!!!!!!!!!");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Login failed.........'),
            backgroundColor: Colors.green,
          ));
        }
      } else {
        print("Please try again!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please choose a value from drop down'),
      ));
    }
  }
}

import 'dart:convert';
// import 'dart:developer';

import 'package:blood_bank/Model/ViewBlood.dart';
import 'package:blood_bank/Model/ViewPlace.dart';
import 'package:blood_bank/Screens/HosptialBloodAdd.dart';
import 'package:blood_bank/Screens/MainPage.dart';
import 'package:blood_bank/URL/url.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreenHospital extends StatefulWidget {
  String mobileno;
  RegisterScreenHospital({super.key, required this.mobileno});

  @override
  State<RegisterScreenHospital> createState() => _RegisterScreenState();
}

String choosedoptionblood = "select blood group";
String choosedoptionplace = "select your place";
bool isloading = false;

late dynamic dropdownValue = null;
late dynamic dropdownValue2 = null;
String Bloodid = "", Placeid = "";
List<ViewBloodModel> bloodgrouplist = [];
List<ViewPlaceModel> placegrouplist = [];
final _scaffoldKey = GlobalKey<ScaffoldState>();
TextEditingController hospitalnamecontroller = new TextEditingController();
TextEditingController hospitaladdresscontroller = new TextEditingController();
TextEditingController hospitaldistrictcontroller = new TextEditingController();

class _RegisterScreenState extends State<RegisterScreenHospital> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /////// getBloodGroups();
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

  String? slectedvalue;
  bool submit = false;

  @override
  Widget build(BuildContext context) {
    var _formKey = GlobalKey<FormState>();

    Future<void> _submit(String name, String address, String district) async {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      _formKey.currentState!.save();
      if (Placeid.toString() != "" && Bloodid.toString() != "") {
        setState(() {
          isloading = true;
        });
        Map data = {
          'mobileno': widget.mobileno,
          'bloodid': Bloodid.toString(),
          'placeid': Placeid.toString(),
          'name': name,
          'address': address,
          'district': district,
        };
        print(data.toString());
        final response = await http.post(
          Uri.parse(mainurl().url + "userregister.jsp"),
          body: data,
        );

        print(response.statusCode);
        if (response.statusCode == 200) {
          Map<String, dynamic> resposne = jsonDecode(response.body);

          if (resposne['msg'].toString().contains("success")) {
            SharedPreferences logindata = await SharedPreferences.getInstance();
            logindata.setString("mobileno", widget.mobileno);
            logindata.setString("type", "1");
            logindata.setBool("login", false);

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainScreen(selectedIndex: 0,)));

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

    return WillPopScope(
      onWillPop: () async {
        dropdownValue = null;
        dropdownValue2 = null;
        return Navigator.canPop(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xfff7f6fb),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              // height: MediaQuery.of(context).size.height - 50,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 60.0),
                      const Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "AND BECOME A ROLE MODEL",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30,),
                  Column(
                    children: <Widget>[
                      TextFormField(
                        controller: hospitalnamecontroller,
                        decoration: InputDecoration(
                            hintText: "Enter your Hospital Name ",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.red.withOpacity(0.9),
                            filled: true,
                            prefixIcon: const Icon(Icons.person)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your hospital name!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      placegrouplist.isEmpty
                          ? const CircularProgressIndicator()
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    18), // <= No more error here :)
                                color: Colors.red.withOpacity(0.9),
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
                                        },
                                        items: placegrouplist.map<
                                                DropdownMenuItem<
                                                    ViewPlaceModel>>(
                                            (ViewPlaceModel value) {
                                          return DropdownMenuItem<
                                              ViewPlaceModel>(
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
                      TextFormField(
                        controller: hospitaladdresscontroller,
                        decoration: InputDecoration(
                          hintText: "Enter the address",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.red.withOpacity(0.9),
                          filled: true,
                          prefixIcon: const Icon(Icons.location_city_rounded),
                        ),
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your address!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: hospitaldistrictcontroller,
                        decoration: InputDecoration(
                          hintText: "Enter the district",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.red.withOpacity(0.9),
                          filled: true,
                          prefixIcon: const Icon(Icons.dashboard_outlined),
                        ),
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your district!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                  // const SizedBox(height: 20),

                  Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      child: ElevatedButton(
                        onPressed: () {
                          print("placeid===" + Placeid);
                          String hsname = hospitalnamecontroller.text;
                          String hsnadddress = hospitaladdresscontroller.text;
                          String hsdistrict = hospitaldistrictcontroller.text;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => hospitalbloodadd(
                                      hsname: hsname,
                                      hsaddress: hsnadddress,
                                      hsdistrict: hsdistrict,
                                      placeid: Placeid,
                                      mobileno: widget.mobileno)));
                          // _submit(namecontroller.text, addresscontroller.text,
                          //     districtcontroller.text);
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.red[900],
                        ),
                      )),

                  
                ],
              ),
            ),
          ),
        ),

       
      ),
    );
  }
}

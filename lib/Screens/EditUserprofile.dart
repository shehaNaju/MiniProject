import 'dart:convert';
import 'dart:io';

import 'package:blood_bank/Model/ViewPlace.dart';
import 'package:blood_bank/Screens/MainPage.dart';
import 'package:blood_bank/Screens/UserProfilePage.dart';
import 'package:blood_bank/URL/url.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUserProfileScreen extends StatefulWidget {
  String name, address, city, image, type;
  EditUserProfileScreen(
      {super.key,
      required this.name,
      required this.address,
      required this.city,
      required this.image,
      required this.type});

  @override
  State<EditUserProfileScreen> createState() => _ProfileScreenState();
}

List<ViewPlaceModel> placegrouplist = [];

class _ProfileScreenState extends State<EditUserProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? imageURI;
  //final _formKey = GlobalKey<FormState>();
  String uploadStatus = "";
  bool isloading = false;
  late dynamic dropdownValue2 = null;
  String placeid = "";
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController addresscontroller = new TextEditingController();
  TextEditingController distrcitcontroller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlaceGroups();
    //  Fecth
    //
    // datails();
  }

  getPlaceGroups() async {
    placegrouplist = await getplacegroupListGET();
    setState(() {
      namecontroller.text = widget.name;
      addresscontroller.text = widget.address;
      namecontroller.text = widget.name;
    });
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dropdownValue2 = null;
        return Navigator.canPop(context);
      },
      child: SafeArea(
          child: Scaffold(
              body: Container(
        padding: EdgeInsets.only(left: 15, top: 30, right: 15, bottom: 50),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(children: [
            Center(
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  child: CircleAvatar(
                    radius: 70.0,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  // <-- SEE HERE
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                builder: (context) {
                                  return SizedBox(
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Choose your choice ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    takePhoto(
                                                        ImageSource.camera);
                                                  },
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.camera_alt,
                                                          size: 40,
                                                          color: Colors.purple,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text("Camera")
                                                        // GradientText(
                                                        //   "Camera",
                                                        //   gradient:
                                                        //       LinearGradient(
                                                        //     colors: [
                                                        //       Colors.purple
                                                        //           .shade700,
                                                        //       Colors.purple
                                                        //           .shade600,
                                                        //       Colors.pink.shade700
                                                        //     ],
                                                        //   ),
                                                        //)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    takePhoto(
                                                        ImageSource.gallery);
                                                  },
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.image,
                                                          size: 40,
                                                          color: Colors.purple,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text("Gallery")
                                                        // GradientText(
                                                        //   "Gallery",
                                                        //   gradient:
                                                        //       LinearGradient(
                                                        //     colors: [
                                                        //       Colors.purple
                                                        //           .shade700,
                                                        //       Colors.purple
                                                        //           .shade600,
                                                        //       Colors.pink.shade700
                                                        //     ],
                                                        //   ),
                                                        //  )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ));
                                });
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade100,
                            radius: 20.0,
                            child: Icon(
                              Icons.camera_alt,
                              size: 20.0,
                              color: Color(0xFF404040),
                            ),
                          ),
                        ),
                      ),
                      radius: 70.0,
                      backgroundImage: imageURI == null
                          ? NetworkImage(mainurl().imageurl + widget.image)
                          : FileImage(imageURI!) as ImageProvider,
                      //AssetImage('assets/images/course3.jpg'),
                    ),
                  ),
                ),
              ),
            ),
            // SizedBox(height: 30,),
            Column(
              children: [
                TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                      hintText: namecontroller.text,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Colors.white.withOpacity(0.9),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.red,
                      )),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: addresscontroller,
                  decoration: InputDecoration(
                      hintText: addresscontroller.text,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Colors.white.withOpacity(0.9),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.place,
                        color: Colors.red,
                      )),
                ),
                const SizedBox(height: 20),
                // TextField(
                //   decoration: InputDecoration(
                //     hintText: "City",
                //     border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(18),
                //         borderSide: BorderSide.none),
                //     fillColor: Colors.white.withOpacity(0.9),
                //     filled: true,
                //     prefixIcon: const Icon(
                //       Icons.location_on,
                //       color: Colors.red,
                //     ),
                //   ),
                //   obscureText: true,
                // ),
                //  SizedBox(height: 20),
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
                                  hint: const Text("Select your nearest place"),
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

                                      placeid = data.id;
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
                                  items: placegrouplist
                                      .map<DropdownMenuItem<ViewPlaceModel>>(
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
              ],
            ),

            SizedBox(
              height: 30,
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return UserProfileScreen();
                }));
              },
              child: Text("CANCEL",
                  style: TextStyle(
                      fontSize: 15, letterSpacing: 2, color: Colors.black)),
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            ElevatedButton(
              onPressed: () {
                if (placeid == "") {
                  snack("choose your place");
                } else if (imageURI == null) {
                  print("without");
                  _submit(namecontroller.text, addresscontroller.text,
                      distrcitcontroller.text, placeid, widget.type);
                } else {
                  updateProfile(namecontroller.text, addresscontroller.text,
                      distrcitcontroller.text, placeid, imageURI!, widget.type);
                }
              },
              child: isloading == true
                  ? CircularProgressIndicator()
                  : Text(
                      "Update",
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 2, color: Colors.black),
                    ),
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            )
          ]),
        ),
      ))),
    );
  }

  Future takePhoto(ImageSource source) async {
    var image = await ImagePicker().pickImage(source: source);
    //  (source: ImageSource.camera);
    final imageTemporary = File(image!.path);
    setState(() {
      imageURI = imageTemporary;
    });
    Navigator.pop(context);
  }

  Future<Map<String, dynamic>> updateProfile(String name, String address,
      String district, String placeid, File imagefile, String type) async {
    setState(() {
      isloading = true;
    });
    var result;
    SharedPreferences logindata = await SharedPreferences.getInstance();
    String mobile = logindata.getString("mobileno")!;

    var request =
        MultipartRequest("POST", Uri.parse(mainurl().url + "/updateprofile"));
    var pic = await MultipartFile.fromPath("images", imagefile.path);
    request.files.add(pic);
    request.fields['mobileno'] = mobile;
    request.fields['name'] = name;
    request.fields['address'] = address;
    request.fields['district'] = district;
    request.fields['placeid'] = placeid;
    request.fields['type'] = type;

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("aks" + responseString.toString());
    // Map<String, dynamic> result;
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (responseString.contains("success")) {
        setState(() {
          dropdownValue2 = null;
          isloading = false;
          uploadStatus = "File Uploaded Succesfully";
          result = "success";
          snack("updated");
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return MainScreen(selectedIndex: 4,);
        }));
      } else {
        setState(() {
          uploadStatus = "Failed...........";
          snack("Something went wrong, please try again");
        });
      }
    }
    return result;
  }

  void snack(String msg) {
    final snackBar = SnackBar(
      elevation: 0,
      backgroundColor: Color.fromARGB(55, 74, 20, 140),
      content: Text(
        msg,
        style: TextStyle(color: Colors.black),
      ),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _submit(String name, String address, String district,
      String placeid, String type) async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    String mobile = logindata.getString("mobileno")!;

    setState(() {
      isloading = true;
    });
    Map data = {
      'mobileno': mobile,
      'placeid': placeid,
      'name': name,
      'address': address,
      'district': district,
      'type': type,
    };
    print(data.toString());
    final response = await http.post(
      Uri.parse(mainurl().url + "updateuserprofilewoimage.jsp"),
      body: data,
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

      if (resposne['msg'].toString().contains("success")) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen(selectedIndex: 4,)));

        print("Login Successfully Completed !!!!!!!!!!!!!!!!");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Something went wrong.'),
          backgroundColor: Colors.green,
        ));
      }
    } else {
      print("Please try again!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
  }
}

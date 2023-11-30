import 'dart:convert';
import 'package:blood_bank/Model/ViewBloodHospitalModel.dart';
import 'package:blood_bank/Screens/MainPage.dart';
import 'package:blood_bank/URL/url.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class hospitalbloodadd extends StatefulWidget {
  String hsname, hsaddress, hsdistrict, placeid, mobileno;
  hospitalbloodadd(
      {super.key,
      required this.hsname,
      required this.hsaddress,
      required this.hsdistrict,
      required this.placeid,
      required this.mobileno});

  @override
  State<hospitalbloodadd> createState() => _hospitalbloodaddState();
}

List<ViewBloodHospitalModel> bloodgrouplist = [];
bool isloading = false;

class _hospitalbloodaddState extends State<hospitalbloodadd> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBloodGroups();
  }

  getBloodGroups() async {
    bloodgrouplist = await getbloodgrouplistListGET();

    /// _isChecked = List<bool>.filled(bloodgrouplist.length, false);

    setState(() {});
  }

  Future<List<ViewBloodHospitalModel>> getbloodgrouplistListGET() async {
    try {
      final response = await http.get(
        Uri.parse(mainurl().url + "getbloodgroup.jsp"),
      );
      if (response.statusCode == 200) {
        List res = jsonDecode(response.body);
        return res.map((e) => ViewBloodHospitalModel.fromJson(e)).toList();
      }
    } catch (e) {}
    return bloodgrouplist;
  }

  List<ViewBloodHospitalModel> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(child: Text("Add your blood groups and units",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red[900]),)),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
      
                //Flexible(fit: FlexFit.tight, child: SizedBox()),
                bloodgrouplist.isEmpty
                    ? const CircularProgressIndicator()
                    : Container(
                        height: 500,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ListView.builder(
                                itemCount: bloodgrouplist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Checkbox(
                                            value:
                                                bloodgrouplist[index].isChecked,
                                            onChanged: (value) {
                                              setState(() {
                                                bloodgrouplist[index].isChecked =
                                                    value!;
      
                                                if (value) {
                                                  selectedItems
                                                      .add(bloodgrouplist[index]);
                                                } else {
                                                  selectedItems.remove(
                                                      bloodgrouplist[index]);
                                                }
                                              });
                                            },
                                          ),
                                          SizedBox(width: 8.0),
                                          Text(bloodgrouplist[index].name),
                                          SizedBox(width: 8.0),
                                          Expanded(
                                            child: TextField(
                                              onChanged: (text) {
                                                bloodgrouplist[index]
                                                    .textFieldData = text;
                                                ////////// itemList[index].textFieldData = text;
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'Enter Unit count',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                Container(
                    width: 300,
                    padding: const EdgeInsets.only(top: 20, left: 3),
                    child: ElevatedButton(
                      onPressed: () {
                        _submit(selectedItems, widget.hsname, widget.hsaddress,
                            widget.hsdistrict, widget.placeid, widget.mobileno);
                      },
                      child: isloading == true
                          ? CircularProgressIndicator()
                          : Text(
                              "Save",
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
  
    );
  }

  Future<void> _submit(
      List<ViewBloodHospitalModel> selectedItems,
      String hsname,
      String hsaddress,
      String hsdistrict,
      String placeid,
      String mobileno) async {
    setState(() {
      isloading = true;
    });
    String jsondata = jsonEncode(selectedItems);
    print('jsondata =${jsondata}');

    Map data = {
      'mobileno': mobileno,
      'blooddetails': jsondata,
      'placeid': placeid,
      'hsname': hsname,
      'hsaddress': hsaddress,
      'hsdistrict': hsdistrict,
    };
    print(data.toString());
    final response = await http.post(
      Uri.parse(mainurl().url + "hospitalregister.jsp"),
      body: data,
    );

    print(response.statusCode);
    setState(() {
      isloading = false;
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

      if (resposne['msg'].toString().contains("success")) {
        SharedPreferences logindata = await SharedPreferences.getInstance();
        logindata.setString("mobileno", mobileno);
        logindata.setString("type", "1");
        logindata.setBool("login", false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen(selectedIndex: 0,)));

        print("Login Successfully Completed !!!!!!!!!!!!!!!!");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registration failed.........'),
          backgroundColor: Colors.green,
        ));
      }
    } else {
      print("Please try again!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
  }
}

class SelectedItemsPage extends StatelessWidget {
  final List<ViewBloodHospitalModel> selectedItems;

  SelectedItemsPage({required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Items'),
      ),
      body: ListView.builder(
        itemCount: selectedItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Name: ${selectedItems[index].name}'),
            subtitle:
                Text('TextField Data: ${selectedItems[index].textFieldData}'),
          );
        },
      ),
    );
  }
}

import 'dart:convert';

import 'package:blood_bank/Model/UpdateBloodModel.dart';
import 'package:blood_bank/Screens/AddNewBloodGroup.dart';
import 'package:blood_bank/URL/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';

class bloodupdatepage extends StatefulWidget {
  String id;

  bloodupdatepage({super.key, required this.id});

  @override
  State<bloodupdatepage> createState() => _bloodupdatepageState();
}

List<UpdateBloodModel> bloodgrouplist = [];
bool isloading = false;

class _bloodupdatepageState extends State<bloodupdatepage> {
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

  Future<List<UpdateBloodModel>> getbloodgrouplistListGET() async {
    try {
      final response = await http.post(
        Uri.parse(mainurl().url + "getblooddetails.jsp"),
        body: {"id": widget.id},
      );
      if (response.statusCode == 200) {
        List res = jsonDecode(response.body);
        return res.map((e) => UpdateBloodModel.fromJson(e)).toList();
      }
    } catch (e) {}
    return bloodgrouplist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text("Update blood list"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //  Text("Update blood list"),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            //Flexible(fit: FlexFit.tight, child: SizedBox()),
            bloodgrouplist.isEmpty
                ? const CircularProgressIndicator()
                : Container(
                    height: 400,
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
                                      Text(bloodgrouplist[index].name),
                                      SizedBox(width: 8.0),
                                      Expanded(
                                        child: TextField(
                                          onChanged: (text) {
                                            bloodgrouplist[index]
                                                .textFieldData = text;
                                          },
                                          decoration: InputDecoration(
                                            hintText: bloodgrouplist[index]
                                                .textFieldData,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.0),
                                      IconButton(
                                        color: Colors.green,
                                          onPressed: () {
                                            String count = bloodgrouplist[index]
                                                .textFieldData;
                                            String id =
                                                bloodgrouplist[index].id;
                                            print("count===" +
                                                count +
                                                "  sdssdd===" +
                                                id);

                                            showAlertDialog(context, id, count,
                                                "1", "edit");
                                          },
                                          icon: Icon(isloading == true
                                              ? Icons.local_dining
                                              : Icons.check_circle)),
                                      IconButton(
                                        color: Colors.red,
                                          onPressed: () {
                                            String id =
                                                bloodgrouplist[index].id;
                                            showAlertDialog(context, id,
                                                "count", "0", "delete");
                                            // delete(id, "count", "0");
                                          },
                                          icon: Icon(isloading == true
                                              ? Icons.local_dining
                                              : Icons.delete)),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
            // Container(
            //     width: 300,
            //     padding: const EdgeInsets.only(top: 3, left: 3),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         // _submit(selectedItems, widget.hsname, widget.hsaddress,
            //         //     widget.hsdistrict, widget.placeid, widget.mobileno);
            //       },
            //       child: isloading == true
            //           ? CircularProgressIndicator()
            //           : Text(
            //               "Save",
            //               style: TextStyle(fontSize: 20),
            //             ),
            //       style: ElevatedButton.styleFrom(
            //         shape: const StadiumBorder(),
            //         padding: const EdgeInsets.symmetric(vertical: 16),
            //         backgroundColor: Colors.red[900],
            //       ),
            //     )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddnewBlooadGroup(hsid: widget.id),
            ),
          );
        },
        label: Text('Add New Blood group'),
        icon: Icon(Icons.bloodtype),
        backgroundColor: Colors.white,
      ),
    );
  }

  showAlertDialog(
      BuildContext context, String id, String count, String type, String msg) {
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
        delete(id, count, type);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are you sure want to " + msg),
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

  Future<void> delete(String id, String count, String type) async {
    setState(() {
      isloading = true;
    });
    Map data = {'id': id, 'count': count, 'type': type};
    print(data.toString());
    final response = await http.post(
      Uri.parse(mainurl().url + "updatecount.jsp"),
      body: data,
    );

    print(response.statusCode);
    setState(() {
      isloading = false;
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

      if (resposne['msg'].toString().contains("success")) {
        getBloodGroups();
        Navigator.pop(context);
        print("Login Successfully Completed !!!!!!!!!!!!!!!!");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Something went wrong.........'),
          backgroundColor: Colors.green,
        ));
      }
    } else {
      print("Please try again!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
  }
}

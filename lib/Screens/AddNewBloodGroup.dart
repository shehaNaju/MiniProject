import 'dart:convert';

import 'package:blood_bank/Model/ViewBloodHospitalModel.dart';
import 'package:blood_bank/Screens/HospitalProfilescreen.dart';
import 'package:blood_bank/URL/url.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddnewBlooadGroup extends StatefulWidget {
  String hsid;
  AddnewBlooadGroup({
    super.key,
    required this.hsid,
  });

  @override
  State<AddnewBlooadGroup> createState() => _hospitalbloodaddState();
}

List<ViewBloodHospitalModel> bloodgrouplist = [];
bool isloading = false;

class _hospitalbloodaddState extends State<AddnewBlooadGroup> {
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Add your blood groups and unit"),
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
                                            keyboardType: TextInputType.number,
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
              SizedBox(
                height: 10,
              ),
              Container(
                  width: 300,
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectedItemsPage(
                            selectedItems: selectedItems,
                            id: widget.hsid,
                          ),
                        ),
                      );
                      // _submit(selectedItems, widget.hsname, widget.hsaddress,
                      //     widget.hsdistrict, widget.placeid, widget.mobileno);
                    },
                    child: isloading == true
                        ? CircularProgressIndicator()
                        : Text(
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.check),
      // ),
    );
  }
}

// ignore: must_be_immutable
class SelectedItemsPage extends StatefulWidget {
  final List<ViewBloodHospitalModel> selectedItems;
  String id;

  SelectedItemsPage({required this.selectedItems, required this.id});

  @override
  State<SelectedItemsPage> createState() => _SelectedItemsPageState();
}

class _SelectedItemsPageState extends State<SelectedItemsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text('Selected Items'),
      ),
      body: ListView.builder(
        itemCount: widget.selectedItems.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text('BloodGroup: ${widget.selectedItems[index].name}'),
                subtitle: Text(
                    'Unit Count: ${widget.selectedItems[index].textFieldData}'),
              ),
              Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: ElevatedButton(
                    onPressed: () {
                      _submit(widget.selectedItems, widget.id);
                    },
                    child: isloading == true
                        ? CircularProgressIndicator()
                        : Container(
                            width: 200,
                            child: Center(
                              child: Text(
                                "Save",
                                style: TextStyle(fontSize: 20,color: Colors.white),
                              ),
                            ),
                          ),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.red[900],
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submit(
    List<ViewBloodHospitalModel> selectedItems,
    String hsid,
  ) async {
    setState(() {
      isloading = true;
    });
    String jsondata = jsonEncode(selectedItems);
    print('jsondata =${jsondata}');

    Map data = {
      'hsid': hsid,
      'blooddetails': jsondata,
    };
    print(data.toString());
    final response = await http.post(
      Uri.parse(mainurl().url + "bloodupdatepage.jsp"),
      body: data,
    );

    print(response.statusCode);
    setState(() {
      isloading = false;
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

      if (resposne['msg'].toString().contains("success")) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => hospitalProfileScreen()));

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

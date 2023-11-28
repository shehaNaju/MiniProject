import 'dart:convert';


import 'package:blood_bank/Model/ViewBloodReqModel.dart';
import 'package:blood_bank/Screens/MainPage.dart';
import 'package:blood_bank/URL/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyRequestScreen extends StatefulWidget {
  const MyRequestScreen({super.key});

  @override
  State<MyRequestScreen> createState() => _MyRequestScreenState();
}

List<ViewBloodReqModel> blodreqlist = [];
bool isloading = false;

class _MyRequestScreenState extends State<MyRequestScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    getbloodrequsets();
  }

  getbloodrequsets() async {
    blodreqlist = await getblreq();

    /// _isChecked = List<bool>.filled(bloodgrouplist.length, false);

    setState(() {});
  }

  Future<List<ViewBloodReqModel>> getblreq() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    String mobileno = logindata.getString("mobileno")!;
    setState(() {
      isloading = true;
    });
    try {
      final response = await http.post(
        Uri.parse(mainurl().url + "getbloodmyrequst.jsp"),
        body: {"type": "0", "mobileno": mobileno},
      );
      setState(() {
        isloading = false;
      });
      if (response.statusCode == 200) {
        print("ddddd==" + response.body);
        List res = jsonDecode(response.body);
        return res.map((e) => ViewBloodReqModel.fromJson(e)).toList();
      }
    } catch (e) {}
    return blodreqlist;
  }

  // filter function
  void updateList(String value) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // centerTitle: true,

          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/images/logo.png',
              //   scale: 12,
              // ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'My Requests are..',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade300, //<-- SEE HERE
        ),
        body: isloading == true
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "My Requests are...",
                        //   style: TextStyle(
                        //       color: Colors.black,
                        //       fontSize: 20.0,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        SizedBox(
                          height: 30.0,
                        ),

                        Expanded(
                            child: blodreqlist.isEmpty
                                ? Center(child: Text("No data found"))
                                : ListView.builder(
                                    itemCount: blodreqlist.length,
                                    itemBuilder: (context, index) {
                                      //                   return Dismissible(
                                      //  key: Key(choice[index]),
                                      // background: Container(
                                      //   alignment: AlignmentDirectional.centerEnd,
                                      //   color: Colors.red,
                                      //   child: Icon(
                                      //     Icons.delete,
                                      //     color: Colors.white,
                                      //   ),
                                      // ),
                                      // onDismissed: (direction) {
                                      //   setState(() {
                                      //     items.removeAt(index);
                                      //   });
                                      return Center(
                                        child: ChoiceCard(
                                          choice: blodreqlist[index],
                                          item: blodreqlist[index],
                                          onTap: () {
                                            // Navigator.of(context).push(
                                            //   MaterialPageRoute(
                                            //       builder: (context) => DonarsScreen()),
                                            // );
                                          },
                                        ),
                                      );
                                    }))
                      ]),
                ),
              ));
  }
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    Key? key,
    required this.choice,
    required this.onTap,
    required this.item,
    this.selected = false,
  }) : super(key: key);
  final ViewBloodReqModel choice;
  final VoidCallback onTap;
  final ViewBloodReqModel item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(mainurl().imageurl + choice.image),
                )),
            Column(children: [
              Container(
                padding: EdgeInsets.only(top: 30),
                alignment: Alignment.topLeft,
                child: Text(
                  choice.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.location_on,
                          color: Colors.red,
                        )),
                    Text(choice.place),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.bloodtype_rounded,
                          color: Colors.red,
                        )),
                    Text(choice.blood),
                  ],
                ),
              ),
            ]),
            Flexible(fit: FlexFit.tight, child: SizedBox()),
            IconButton(
                onPressed: () {
                  showAlertDialog(context, choice.id);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String id) {
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
        delete(id, context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are you sure want to delete"),
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

  Future<void> delete(String id, BuildContext context) async {
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

    // setState(() {
    //   isloading = true;
    // });
    Map data = {'id': id};
    print(data.toString());
    final response = await http.post(
      Uri.parse(mainurl().url + "deletebloodreq.jsp"),
      body: data,
    );

    print(response.statusCode);
    // setState(() {
    //   isloading = false;
    // });
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

      if (resposne['msg'].toString().contains("success")) {
        //  Navigator.pop(context);
        snack("deleted");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MainScreen(selectedIndex: 3,)));

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

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:blood_bank/Model/ViewHospitalModel.dart';
import 'package:blood_bank/Screens/DonarsPage.dart';
import 'package:blood_bank/Screens/HospitalScreen.dart';
import 'package:blood_bank/URL/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<ViewHospitalModel> hospitallist = [];
bool isloading = false;

class _HomePageState extends State<HomePage> {
  List<Bloodstock> _searchResult = [];
  List<Bloodstock> _userDetails = [];


    List<ViewHospitalModel> _searchItems = [];


  void initState() {
    // TODO: implement initState
    super.initState();
    gethospitalGroups();
  }

  gethospitalGroups() async {
    hospitallist = await getbloodgrouplistListGET();
 _searchItems = hospitallist;
    /// _isChecked = List<bool>.filled(bloodgrouplist.length, false);

    setState(() {});
  }

  Future<List<ViewHospitalModel>> getbloodgrouplistListGET() async {
    setState(() {
      isloading = true;
    });
    try {
      final response = await http.get(
        Uri.parse(mainurl().url + "gethospital.jsp"),
      );
      setState(() {
        isloading = false;
      });
      if (response.statusCode == 200) {
        print("ddddd==" + response.body);
        List res = jsonDecode(response.body);
        return res.map((e) => ViewHospitalModel.fromJson(e)).toList();
      }
    } catch (e) {}
    return hospitallist;
  }

  // filter function
  void updateList(String value) {}

  TextEditingController controller =  TextEditingController();
  @override
  Widget build(BuildContext context) {
     Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    bool shouldExit = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Exit'),
          content: Text('Are you sure you want to exit?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                shouldExit = false;
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Exit'),
              onPressed: () {
                shouldExit = true;
                exit(0);
               // Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );

    return shouldExit;
  }


    Widget _buildSearchResults() {
      print("iniseee 444==" + _searchItems.length.toString());
      return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog(context);
      },
      
        child: ListView.builder(
          itemCount: _searchItems.length,
          itemBuilder: (context, i) {
            return Center(
              child: ChoiceCard(
                choice: _searchItems[i],
                item: _searchItems[i],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DonarsScreen()),
                  );
                },
              ),
            );
          },
        ),
      );
    }



      void _runFilter(String enteredKeyword) {
      List<ViewHospitalModel> results = [];
      if (enteredKeyword.isEmpty) {
        results = hospitallist;
      } else {
        results = hospitallist
            .where((item) => item.hospitalname!
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
      }

      setState(() {
        _searchItems = results;
      });
    }


    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to the blood App...",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // TextField(
                  //   style: TextStyle(color: Colors.white),
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     fillColor: Colors.red,
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(8.0),

                  
                  //         borderSide: BorderSide.none),
                  //     hintText: "search the blood group",
                  //     suffixIcon: Icon(Icons.search),
                  //     prefixIconColor: Colors.red,
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:  Card(
                      child:  ListTile(
                        leading:  Icon(Icons.search),
                        title:  TextField(
                          controller: controller,
                          decoration:  InputDecoration(
                            
                              
                              hintText: 'Search',
                               border: InputBorder.none),
                          onChanged: _runFilter,
                        ),
                        trailing: new IconButton(
                          icon: new Icon(Icons.cancel),
                          onPressed: () {
                            setState(() {
                              controller.clear();
                              onSearchTextChanged('');
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  isloading == true
                      ? Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: hospitallist.isEmpty
                              ? Text("No data found")
                              : _searchResult.length != 0 ||
                                      controller.text.isNotEmpty
                                  ? _buildSearchResults()
                                  : ListView.builder(
                                      itemCount: hospitallist.length,
                                      itemBuilder: (context, index) {
                                        _userDetails =
                                            hospitallist[index].bloodstocks;
                                        return Center(
                                          child: ChoiceCard(
                                            choice: hospitallist[index],
                                            item: hospitallist[index],
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DonarsScreen()),
                                              );
                                            },
                                          ),
                                        );
                                      }))
                ]),
          ),
        ));
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }


    //  _searchResult = _userDetails
    //       .where((item) =>
    //           item.bllodgroupname.toLowerCase().contains(enteredKeyword.toLowerCase()))
    //       .toList();

    _userDetails.forEach((userDetail) {
      print(
          "in boytttoooommm===" + _userDetails.toString() + "ffffff===" + text);
      if (userDetail.bllodgroupname.contains(text.toUpperCase()))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

class Hospital {
  Hospital(
      {required this.Hospitalname,
      required this.icon,
      required this.Location,
      required this.bloodgroup,
      required this.units});
  final String Hospitalname;
  final String Location;
// final String Address;
  String bloodgroup;
  int units;
  final IconData icon;
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    Key? key,
    required this.choice,
    required this.onTap,
    required this.item,
    this.selected = false,
  }) : super(key: key);
  final ViewHospitalModel choice;
  final VoidCallback onTap;
  final ViewHospitalModel item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
// TextStyle textStyle = TextStyle(fontSize: 12);
// if (selected)
//  textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    return Card(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.topLeft,
            child: CircleAvatar(
              backgroundImage: choice.image == 0
                  ? AssetImage("assetName")
                  : NetworkImage(mainurl().imageurl + choice.image)
                      as ImageProvider,
              radius: 30,
              child: Text(
                '',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ), //Text
            ), //CircleAvat
          ),
          Column(children: [
            Container(
              padding: EdgeInsets.only(top: 15),
              alignment: Alignment.topLeft,
              child: Text(choice.hospitalname),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.location_on,
                      color: Colors.red[400],
                    )),
                Text(choice.address),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bloodtype_rounded,
                      color: Colors.red[400],
                    )),
                Container(
                  height: 60,
                  child: Center(
                    child: ListView.builder(
                        itemCount: choice.bloodstocks.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Container(
                                // color: Colors.amber,
                                height: 20,
                                width: 50,
                                child: (Text(
                                    choice.bloodstocks[index].bllodgroupname))),
                          );
                        }),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HospitalScreen(
                                    choice: choice,
                                  )),
                        );
                      },
                      child: Text(
                        "View More",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child:
                        Text(choice.bloodstocks.length.toString() + " Units"),
                  )
                ],
              ),
            )
          ])
        ],
        // crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }


   Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    bool shouldExit = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Exit'),
          content: Text('Are you sure you want to exit?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                shouldExit = false;
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Exit'),
              onPressed: () {
                shouldExit = true;
                exit(0);
               // Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );

    return shouldExit;
  }
}
        
  //          ListView.builder(
      
  //     itemCount: items.length,
  //     itemBuilder: (context, index) {
  //       // return Dismissible(
  //       //   key: Key(items[index]),
  //         // background: Container(
  //         //   alignment: AlignmentDirectional.centerEnd,
  //         //   color: Colors.red,
  //         //   child: Icon(
  //         //     Icons.delete,
  //         //     color: Colors.white,
  //         //   ),
  //         // ),
  //         // onDismissed: (direction) {
  //         //   setState(() {
  //         //     items.removeAt(index);
  //         //   });
          
            
  //        return Card(
  //             elevation: 5,
  //             child: Container(
  //             height: 100.0,
  //             child: Row(
  //               children: <Widget>[
  //                 Container(
  //                   height: 100.0,
  //                   width: 70.0,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.only(
  //                       bottomLeft: Radius.circular(5),
  //                       topLeft: Radius.circular(5)
  //                     ),
  //                     image: DecorationImage(
  //                       fit: BoxFit.cover,
  //                       image: NetworkImage("https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png")
  //                     )
  //                   ),
  //                 ),
  //                 Container(
  //                   height: 100,
  //                   child: Padding(
  //                     padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget>[
  //                         Text(
  //                           items[index],
                            
  //                         ),
  //                         Padding(
  //                             padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
  //                              child: Container(
  //                             width: 30,
  //                             decoration: BoxDecoration(
  //                               border: Border.all(color: Colors.teal),
  //                               borderRadius: BorderRadius.all(Radius.circular(10))
  //                             ),
  //                             child: Text("3D",textAlign: TextAlign.center,),
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
  //                             child: Container(
  //                             width: 260,
  //                             child: Text("His genius finally recognized by his idol Chester",style: TextStyle(
  //                               fontSize: 15,
  //                               color: Color.fromARGB(255, 48, 48, 54)
  //                             ),),
                              
      
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
          
             
  //       );
  //     },
  //         ))
          
          

  //         ],
  //     ),
    
  //    ), );
  // }}
  
  //    List getDummyList() {
  //   List list = List.generate(10, (i) {
  //     return "Item ${i + 1}";
  //   });
  //   return list;
  // }

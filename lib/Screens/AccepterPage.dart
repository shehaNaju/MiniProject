import 'dart:convert';

import 'package:blood_bank/Model/ViewBloodReqModel.dart';
import 'package:blood_bank/Screens/Floating%20Pages/floatingpage2.dart';
import 'package:blood_bank/URL/url.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptersScreen extends StatefulWidget {
  const AcceptersScreen({super.key});

  @override
  State<AcceptersScreen> createState() => _AcceptersScreenState();
}

List<ViewBloodReqModel> blodreqlist = [];
bool isloading = false;

class _AcceptersScreenState extends State<AcceptersScreen> {
  List<ViewBloodReqModel> _searchResult = [];
  List<ViewBloodReqModel> _userDetails = [];

  List<ViewBloodReqModel> _searchItems = [];


  void initState() {
    // TODO: implement initState
    super.initState();
    getbloodrequsets();
  }

  getbloodrequsets() async {
    blodreqlist = await getblreq();



        _searchItems = blodreqlist;

    /// _isChecked = List<bool>.filled(bloodgrouplist.length, false);

    setState(() {});
  }

  Future<List<ViewBloodReqModel>> getblreq() async {
    setState(() {
      isloading = true;
    });
    try {
      final response = await http.post(
        Uri.parse(mainurl().url + "getbloodrequst.jsp"),
        body: {"type": "1"},
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

  TextEditingController controller = new TextEditingController();

  Widget build(BuildContext context) {
    Widget _buildSearchResults() {
      print("iniseee 444==" + _searchItems.length.toString());
      return ListView.builder(
        itemCount: _searchItems.length,
        itemBuilder: (context, i) {
          return Card(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.topLeft,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          mainurl().imageurl + _searchItems[i].image,
                        ),
                      )),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        alignment: Alignment.topLeft,
                        child: Text(_searchItems[i].name),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.location_on,
                                color: Colors.red[400],
                              )),
                          Text(
                            _searchItems[i].place,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.bloodtype_rounded,
                                color: Colors.red[400],
                              )),
                          Text(_searchItems[i].blood),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(children: [
                          Container(
                            // decoration: BoxDecoration(
                            //   color: Colors.green,
                            //   borderRadius: BorderRadius.all(
                            //     Radius.circular(50),
                            //   ),
                            // ),
                            child: TextButton(
                              onPressed: () {
                                String whtno = _searchItems[i].whno;
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 25,
                                foregroundImage:
                                    AssetImage("assets/images/Register.jpg"),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green[400],
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                String callno = _searchItems[i].mainno;
                              },
                              child: Text(
                                "Call",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                          )
                        ]),
                      )
                    ],
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ));
        },
      );
    }

    return Scaffold(
      body: isloading == true
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "Select The Acceptors..",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                        ),
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FloattingScreen2()));
                          },
                          child: Icon(Icons.add),
                          backgroundColor: Colors.red[400], //<-- SEE HERE
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                       child:  ListTile(
                      
                      // leading:  Icon(Icons.search),
                      title:  TextField(
                        
                        controller: controller,
                       onChanged: _runFilter,

                        decoration:  InputDecoration(
                          filled: true,
                      fillColor: Colors.red,
                      border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none),
                          
                            
                            hintText: 'Search the Acceptors',
                             suffixIcon: Icon(Icons.search,color: Colors.black,),
                 prefixIconColor: Colors.red,
                            
                        // onChanged: _runFilter,
                        )
                      ),
                      // trailing: new IconButton(
                      //   icon: new Icon(Icons.cancel),
                      //   onPressed: () {
                      //     setState(() {
                      //       controller.clear();
                      //       onSearchTextChanged('');
                      //     });
                      //   },
                      // ),
                    ),
                  ),

                    // Padding(
                    //   padding:  EdgeInsets.all(8.0),
                    //   child: new Card(
                        
                    //     child: new ListTile(
                     
                    //       title: new TextField(
                    //         controller: controller,
                    //            onChanged: _runFilter,
                    //         decoration: new InputDecoration(
                    //            filled: true,
                    //   fillColor: Colors.red,
                    //   border: OutlineInputBorder(
                    //      borderRadius: BorderRadius.circular(10.0),
                    // borderSide: BorderSide.none),

                    //             hintText: 'Search the doners',
                                
                            // onChanged: _runFilter,
                          
                          // trailing: new IconButton(
                          //   icon: new Icon(Icons.cancel),
                          //   onPressed: () {
                          //     setState(() {
                          //       controller.clear();
                          //       onSearchTextChanged('');
                          //     });
                          //   },
                          // ),
                      
                    
                  
                    
                //       child: new Card(
                //         child: new ListTile(
                       
                //           title: new TextField(
                //             controller: controller,
                //               onChanged: _runFilter,
                //             decoration:  InputDecoration(
                //           filled: true,
                //       fillColor: Colors.red,
                //       border: OutlineInputBorder(
                //          borderRadius: BorderRadius.circular(10.0),
                //     borderSide: BorderSide.none),
                          
                            
                //             hintText: 'Search the doners',
                //              suffixIcon: Icon(Icons.search,color: Colors.black,),
                //  prefixIconColor: Colors.red,
                            
                //         // onChanged: _runFilter,
                //         )
                          
                //           ),
                //           // trailing: new IconButton(
                //           //   icon: new Icon(Icons.cancel),
                //           //   onPressed: () {
                //           //     setState(() {
                //           //       controller.clear();
                //           //       onSearchTextChanged('');
                //           //     });
                //           //   },
                //           ),
                //         ),
                    
                  
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: blodreqlist.isEmpty
                            ? Center(child: Text("No data found"))
                            : _searchResult.length != 0 ||
                                    controller.text.isNotEmpty
                                ? _buildSearchResults()
                                : ListView.builder(
                                    itemCount: blodreqlist.length,
                                    itemBuilder: (context, index) {
                                      _userDetails = blodreqlist;
                                      return GestureDetector(
                                          onTap: () {
                                            // Navigator.of(context).push(
                                            //   MaterialPageRoute(
                                            //       builder: (context) => AcceptersScreen()),
                                            //  );
                                          },
                                          child: Card(
                                              color: Colors.white,
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                          mainurl().imageurl +
                                                              blodreqlist[index]
                                                                  .image,
                                                        ),
                                                      )),
                                                  Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 15),
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                            blodreqlist[index]
                                                                .name),
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {},
                                                              icon: Icon(
                                                                Icons
                                                                    .location_on,
                                                                color: Colors
                                                                    .red[400],
                                                              )),
                                                          Text(
                                                              blodreqlist[index]
                                                                  .place),
                                                          IconButton(
                                                              onPressed: () {},
                                                              icon: Icon(
                                                                Icons
                                                                    .bloodtype_rounded,
                                                                color: Colors
                                                                    .red[400],
                                                              )),
                                                          Text(
                                                              blodreqlist[index]
                                                                  .blood),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child: Row(children: [
                                                          Container(
                                                            // decoration: BoxDecoration(
                                                            //   color: Colors.green,
                                                            //   borderRadius: BorderRadius.all(
                                                            //     Radius.circular(50),
                                                            //   ),
                                                            // ),
                                                            child: TextButton(
                                                              onPressed: () {
                                                                String whtno =
                                                                    blodreqlist[
                                                                            index]
                                                                        .whno;
                                                                _launchWhatsapp(
                                                                    whtno);
                                                              },
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                radius: 25,
                                                                foregroundImage:
                                                                    AssetImage(
                                                                        "assets/images/Register.jpg"),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 30,
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .green[400],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    50),
                                                              ),
                                                            ),
                                                            child: TextButton(
                                                              onPressed: () {
                                                                String callno =
                                                                    blodreqlist[
                                                                            index]
                                                                        .mainno;
                                                                openDialPad(
                                                                    "+91" +
                                                                        callno);
                                                              },
                                                              child: Text(
                                                                "Call",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )
                                                        ]),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                              )));
                                    }))
                  ],
                ),
              ),
            ),
    );
  }


   void _runFilter(String enteredKeyword) {
    List<ViewBloodReqModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = blodreqlist;
    } else {
      results = blodreqlist
          .where((item) =>
              item.blood!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _searchItems = results;
    });
  }


  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      print(
          "in boytttoooommm===" + _userDetails.toString() + "ffffff===" + text);
      if (userDetail.place.contains(text)) _searchResult.add(userDetail);
    });

    setState(() {});
  }

  openDialPad(String phoneNumber) async {
    Uri url = Uri(scheme: "tel", path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Can't open dial pad.");
    }
  }

  _launchWhatsapp(String whbno) async {
    var whatsapp = "+91" + whbno;
    var whatsappAndroid =
        Uri.parse("whatsapp://send?phone=$whatsapp&text=hello");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }
}


import 'package:blood_bank/Model/ViewHospitalModel.dart';
import 'package:blood_bank/URL/url.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalScreen extends StatefulWidget {
  //const HospitalScreen({super.key});
  final ViewHospitalModel choice;

  const HospitalScreen({
    Key? key,
    required this.choice,
  }) : super(key: key);
  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.redAccent, Colors.red])),
                child: Container(
                  width: double.infinity,
                  height: 250.0,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              mainurl().imageurl + widget.choice.image
                              // "assets/images/hospital.jpeg",
                              ),
                          radius: 50.0,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          widget.choice.hospitalname,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        // Card(
                        //   margin: EdgeInsets.symmetric(
                        //       horizontal: 20.0, vertical: 5.0),
                        //   clipBehavior: Clip.antiAlias,
                        //   color: Colors.white,
                        //   elevation: 5.0,
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 8.0, vertical: 22.0),
                        //     child: Row(
                        //       children: <Widget>[
                        //         Expanded(
                        //           child: Column(
                        //             children: <Widget>[
                        //               Text(
                        //                 "Blood Group",
                        //                 style: TextStyle(
                        //                   color: Colors.red[400],
                        //                   fontSize: 15.0,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //               SizedBox(
                        //                 height: 5.0,
                        //               ),
                        //               Text(
                        //                 'A+ \n'
                        //                 "O+",
                        //                 style: TextStyle(
                        //                   fontSize: 15.0,
                        //                   color: Colors.red[400],
                        //                 ),
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //         // Expanded(
                        //         //   child: Column(

                        //         //     children: <Widget>[
                        //         //       Text(
                        //         //         "Units",
                        //         //         style: TextStyle(
                        //         //           color: Colors.red[400],
                        //         //           fontSize: 15.0,
                        //         //           fontWeight: FontWeight.bold,
                        //         //         ),
                        //         //       ),
                        //         //       SizedBox(
                        //         //         height: 5.0,
                        //         //       ),
                        //         //       Text(
                        //         //         "20 units" ,
                        //         //         // 15 units",
                        //         //         style: TextStyle(
                        //         //           fontSize: 15.0,
                        //         //       color: Colors.red[400],
                        //         //         ),
                        //         //       )
                        //         //     ],
                        //         //   ),
                        //         // ),
                        //         Expanded(
                        //           child: Column(
                        //             children: <Widget>[
                        //               Text(
                        //                 "Available Hours",
                        //                 style: TextStyle(
                        //                   color: Colors.redAccent,
                        //                   fontSize: 15.0,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //               SizedBox(
                        //                 height: 5.0,
                        //               ),
                        //               Text(
                        //                 "24 hours",
                        //                 style: TextStyle(
                        //                   fontSize: 15.0,
                        //                   color: Colors.red[400],
                        //                 ),
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Blood Available Details ",
                      textScaleFactor: 1.5,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Table(
                      // textDirection: TextDirection.rtl,
                      // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                      // border:TableBorder.all(width: 2.0,color: Colors.red),
                      children: [
                        TableRow(children: [
                          Text(
                            "Blood Group",
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                          Text(
                            "Units",
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                          // Text("Branch",textScaleFactor: 1.5),
                        ]),
                        TableRow(children: [
                          ListView.builder(
                              itemCount: widget.choice.bloodstocks.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return (Text(
                                  widget
                                      .choice.bloodstocks[index].bllodgroupname,
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 15),
                                ));
                              }),
                          ListView.builder(
                              itemCount: widget.choice.bloodstocks.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return (Text(
                                  widget
                                      .choice.bloodstocks[index].bloodunitcount,
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 15),
                                ));
                              }),
                        ]),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            // SizedBox(height: 50,),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Hospital Details:",
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontStyle: FontStyle.normal,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.choice.address +
                          '\n' +
                          widget.choice.district +
                          '\n' +
                          widget.choice.place,
                      // 'Metro International Cardiac Center, \n'
                      // 'near Thondiyad,Bypass Road, \n'
                      // 'Open 24 hours.',
                      style: TextStyle(
                        fontSize: 18.0,
                        // fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Mobile Number :" + widget.choice.mobileno,
                      style: TextStyle(fontSize: 18.0, color: Colors.red[900]),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300.00,
                child: MaterialButton(
                    onPressed: () {
                      // dialNumber(
                      //     phoneNumber: "+91" + widget.choice.mobileno,
                      //     context: context);
                      openDialPad("+91" + widget.choice.mobileno);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    elevation: 0.0,
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [Colors.green, Colors.green]),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Contact Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

openDialPad(String phoneNumber) async {
  Uri url = Uri(scheme: "tel", path: phoneNumber);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    print("Can't open dial pad.");
  }
}

Future<void> dialNumber(
    {required String phoneNumber, required BuildContext context}) async {
  final url = "tel:$phoneNumber";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    // ShowSnackBar.showSnackBar(context, "Unable to call $phoneNumber");
  }

  return;
}
  //   return  SafeArea(
  //     child: Scaffold(
  //       body: 
  //        ListView(
          
  //           children: [
  //                     Container(
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(20),
  //                         child: Center(
  //                           child: Text(
  //                             "Hospital Details..",
  //                             style: TextStyle(
  //                                 color: Colors.black,
  //                                 fontSize: 30.0,
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 20,
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(15.0),
  //                       child: Expanded(
  //                         child: Container(
  //                         // color: Colors.red,
  //                         height: MediaQuery.of(context).size.height,
  //                         width: MediaQuery.of(context).size.width,
  //                                       decoration: BoxDecoration(
  //                                                     color: Colors.grey,
  //                                                     borderRadius: BorderRadius.all(
  //                                                       Radius.circular(50),
  //                                                     ),
  //                                                   ),
                                         
  //                         // height: 600,
  //                         // width: 500,
  //                         // child: Text("data"),
  //                         child: Column(
  //                           children: [
  //                             Container(
  //                               height: 50,
  //                               width: 50,
  //                             )
  //                           ],
  //                         ),
  //                         ),
  //                       ),
  //                     )
                  
  //           ]
  //          ),
  //        )
            
        
            
          
    
      
    
      
  //   );
  // }

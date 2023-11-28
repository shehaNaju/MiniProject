
import 'package:blood_bank/Screens/AccepterPage.dart';
import 'package:blood_bank/Screens/DonarsPage.dart';
import 'package:blood_bank/Screens/HomePage.dart';
import 'package:blood_bank/Screens/HospitalProfilescreen.dart';
import 'package:blood_bank/Screens/MyReqestPage.dart';
import 'package:blood_bank/Screens/UserProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
    int selectedIndex;
    MainScreen({required this.selectedIndex});
  @override
  _MainScreenState createState() => _MainScreenState();
}

String type = "0";

class _MainScreenState extends State<MainScreen> {
  int myCurrentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getshareddata();
  }

  Future<void> getshareddata() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      type = logindata.getString("type")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      HomePage(),
      DonarsScreen(),
      AcceptersScreen(),
      MyRequestScreen(),
      type == "0" ? UserProfileScreen() : hospitalProfileScreen()
    ];

    return Scaffold(
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 25,
              offset: Offset(8, 20))
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.black,
              // backgroundColor:Colors.white,

              currentIndex:  widget.selectedIndex,
              onTap: (index) {
                setState(() {
                   widget.selectedIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.local_hospital), label: "Donars"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.local_hospital_rounded),
                    label: "Accepters"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.view_agenda), label: "My Request"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_2_rounded), label: "Profile"),
              ]),
        ),
      ),
      body: pages[ widget.selectedIndex],
    );
  }
}

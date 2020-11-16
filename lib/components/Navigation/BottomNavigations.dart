import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:technician_car_service_system/components/Other%20Components/ConnectionMySql.dart';
import 'package:technician_car_service_system/screen/Account/ChangePasswordScreen.dart';
import 'package:technician_car_service_system/screen/Account/ForgotPasswordScreen.dart';
import 'package:technician_car_service_system/screen/Account/ProfileScreen.dart';
import 'package:technician_car_service_system/screen/Account/SignInScreen.dart';
import 'package:technician_car_service_system/screen/History/HistoryScreen.dart';
import 'package:technician_car_service_system/screen/Job/JobScreen.dart';

class BottomNavigations extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _BottomNavigationsState();
  }
}

class _BottomNavigationsState extends State<BottomNavigations> {


  int _currentIndex = 0;
  final List<Widget> _children = [
    new ChangePasswordScreen(),
    new HistoryScreen(),
    new ProfileScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: new BottomNavigationBar(

        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,

        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(FontAwesomeIcons.shoppingBag),
            title: new Text('Job'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(FontAwesomeIcons.history),
            title: new Text('History'),
          ),

          new BottomNavigationBarItem(
            icon: new Icon(FontAwesomeIcons.personBooth),
            title: new Text('Profile'),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}



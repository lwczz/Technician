import 'package:flutter/material.dart';
import 'package:technician_car_service_system/components/Navigation/BottomNavigations.dart';
import 'package:technician_car_service_system/screen/Account/SignInScreen.dart';


void main()=> runApp(new App());



class App extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return MaterialApp(


      title: 'Log Me In',
      home: Scaffold(

        body:SignInScreen(),
      ),
    );
  }
}




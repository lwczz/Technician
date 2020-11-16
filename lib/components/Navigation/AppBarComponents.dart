import 'package:flutter/material.dart';

Widget AppBarTitle(AppBarData _appBarData){

  return AppBar(

    backgroundColor: Colors.orange,
    leading: _appBarData._iconButton,


    iconTheme: new IconThemeData(
      color: Colors.white,

    ),

    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

        Text(_appBarData._title,

          style: TextStyle(

              color: Colors.white

          ),

        ),

      ],
    ),
  );
}

class AppBarData{

  AppBarData(this._title,this._iconButton);


  String _title;
  IconButton _iconButton;
}

import 'dart:ui';

import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:technician_car_service_system/components/Navigation/AppBarComponents.dart';
import 'package:technician_car_service_system/components/Other%20Components/ConnectionMySql.dart';
import 'package:technician_car_service_system/models/Account/classAccountData.dart';

class ChangePasswordScreen extends StatefulWidget {

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

List<classAccountTechnicianData> accountDataList=[];
class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  String getPassword="";

  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _new = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  var _formKey=GlobalKey<FormState>();

  var db = new Mysql();

  void _getPassword() {

    accountDataList.clear();
    db.getConnection().then((conn) {
      String sqlQuery = "SELECT PPL.Peoples_Password FROM Technicians TNC,Peoples PPL WHERE PPL.Peoples_Id=TNC.Peoples_Id AND TNC.Technicians_Id='TNC1'";

      conn.query(sqlQuery).then((results) {
        print('${results}');
        for(var row in results){
          classAccountTechnicianData a=new classAccountTechnicianData();
          a.technicianPassword=row[0];
          getPassword=row[0];
          accountDataList.add(a);
        }

      });
      conn.close();
    });
  }


  void _changePassword(String newPassword){

    db.getConnection().then((conn) {

      String sqlQuery = "UPDATE Peoples SET Peoples_Password='${newPassword.toString()}'  WHERE Peoples_Id='PPL3';";

      conn.query(sqlQuery);

      conn.close();
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPassword();
  }

  @override
  Widget build(BuildContext context) {

    AppBarData _appBarData=new AppBarData('Change Password',IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        //back button
        onPressed: () =>   Navigator.pop(context)
    ),);

    return Scaffold(

      appBar:AppBarTitle(_appBarData),

      body: SingleChildScrollView(

        child:Column(

          children: <Widget>[

            SizedBox(height: 15,),

            Form(

              key: _formKey,

              child: Container(

                margin: EdgeInsets.all(20.0),

                child: Column(

                  children: <Widget>[

                    Align(

                      alignment: Alignment.centerLeft,
                      child: Text('Enter your current password to reset your password'),

                    ),

                    SizedBox(height: 20,),
                    currentPassword(),
                    SizedBox(height: 20,),

                    Align(

                      alignment: Alignment.centerLeft,
                      child: Text('Enter new Password',),

                    ),

                    SizedBox(height: 20,),
                    newPassword(),
                    SizedBox(height: 10,),
                    confirmPassword(),
                    SizedBox(height: 10,),
                    changePasswordBtn(),

                  ],

                ),

              ),

            ),

          ],

        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );

  }

  Widget currentPassword(){

    return Theme(

      child: TextFormField(

        controller: _currentPassword,

        validator: (val){
          if(val.isEmpty)
            return 'Current Password Field Empty';
          if(val != getPassword)
            return 'Current Password Not Match';
          return null;
        },

        obscureText: true,
        decoration: InputDecoration(
            border: InputBorder.none,

            enabledBorder: OutlineInputBorder(

              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.black),

            ),

            focusedBorder: OutlineInputBorder(

              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.black),

            ),

            labelText: 'Current Password',
            //LabelText

            hintText: 'Abc1234',
            //HintText

            prefixIcon: Icon(Icons.lock)

        ),

      ),

      data: Theme.of(context).copyWith(primaryColor: Colors.orange,),

    );

  }

  Widget newPassword(){

    return Theme(

      child: TextFormField(
        controller: _new,
        validator: (val){
          if(val.isEmpty)
            return 'New Password Field Empty';
          return null;
        },

        obscureText: true,
        decoration: InputDecoration(
            border: InputBorder.none,

            enabledBorder: OutlineInputBorder(

              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.black),

            ),

            focusedBorder: OutlineInputBorder(

              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.black),

            ),

            labelText: 'New Password',
            //LabelText

            hintText: 'Abc1234',
            //HintText

            prefixIcon: Icon(Icons.lock)

        ),

      ),

      data: Theme.of(context).copyWith(primaryColor: Colors.orange,),

    );

  }

Widget confirmPassword(){

  return Theme(

    child: TextFormField(

      controller: _confirmPass,

      validator: (val){
        if(val.isEmpty)
          return 'Confirm Password Field Empty';
        if(val != _new.text)
          return 'New Password & Confirm Password Not Match';
        return null;
      },

      obscureText:true,
      decoration: InputDecoration(
          border: InputBorder.none,

          enabledBorder: OutlineInputBorder(

            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black),

          ),

          focusedBorder: OutlineInputBorder(

            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.black),

          ),

          labelText: 'Confirm Password',
          //LabelText

          hintText: 'Abc1234',
          //HintText

          prefixIcon: Icon(Icons.lock)

      ),

    ),

    data: Theme.of(context).copyWith(primaryColor: Colors.orange,),

  );

}

Widget changePasswordBtn(){

  return ButtonTheme(

    minWidth: 500.0,
    height: 50.0,

    child: RaisedButton(

      textColor: Colors.white,
      color:Colors.orange,
      splashColor: Colors.orangeAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)
      ),
      child: Text('Change'),
      onPressed: () {

        if(_formKey.currentState.validate()){

          _changePassword(_new.text);

          final snackBar = SnackBar(
            content: Text('Change Password Successfully'),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {
                // Some code to undo the change.
              },
            ),

          );
          Scaffold.of(context).showSnackBar(snackBar);

        }else{

          final snackBar = SnackBar(
            content: Text('Password Unchanged'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),

          );
          Scaffold.of(context).showSnackBar(snackBar);
        }

      },

    ),
  );

}

}
List   getWidgetJob(List<classAccountTechnicianData> list){

  List _list =[];
  for(int i=0;i<list.length;i++){
    _list.add({

      'Account_Password':'${list[i].technicianPassword}',

    });
  }
  return _list;
}

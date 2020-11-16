import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:technician_car_service_system/WebServices/MailServices.dart';
import 'package:technician_car_service_system/components/Navigation/AppBarComponents.dart';
import 'package:technician_car_service_system/components/Other%20Components/ConnectionMySql.dart';
import 'package:technician_car_service_system/components/Other%20Components/RandomCharacter.dart';
import 'package:technician_car_service_system/models/Account/classAccountData.dart';
import 'package:technician_car_service_system/models/classSendEmail.dart';


List<classAccountTechnicianData> accountDataList=[];
class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>{

  final TextEditingController _emailTextField = TextEditingController();

  var _formKey=GlobalKey<FormState>();

  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  var db = new Mysql();

  void _getEmail() {

    accountDataList.clear();
    db.getConnection().then((conn) {
      String sqlQuery = "SELECT PPL.Peoples_Email FROM Technicians TNC,Peoples PPL WHERE PPL.Peoples_Id=TNC.Peoples_Id ";

      conn.query(sqlQuery).then((results) {
        print('${results}');
        for(var row in results){
          classAccountTechnicianData a=new classAccountTechnicianData();
          a.technicianEmail=row[0];
          accountDataList.add(a);
        }

      });
      conn.close();
    });
  }

  String validateEmailDate(){

    String _flag="false";

    for(int i=0;i< accountDataList.length;i++)

      if(getWidgeteEmail(accountDataList)[i]["Account_Email"] ==_emailTextField.text){

        _flag="true";

      }
    return _flag;
  }

  void changePassword(String email,String newPassword){

    db.getConnection().then((conn) {

      String sqlQuery = "UPDATE Peoples SET Peoples_Password='${newPassword.toString()}'  WHERE Peoples_Email='${email.toString()}';";

      conn.query(sqlQuery);

      conn.close();
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getEmail();
  }

  @override
  Widget build(BuildContext context) {

    AppBarData _appBarData=new AppBarData('Forgot Password',null);

    return Scaffold(

      appBar:AppBarTitle(_appBarData),
      body: Container(

        margin:EdgeInsets.fromLTRB(30, 20, 30, 0),

        child: Column(

          children: <Widget>[

            Form(

              key: _formKey,

              child: Column(

                children: <Widget>[

                  forgotPasswordTitle(),

                  SizedBox(height: 20,),

                  emailForgotPassword(),

                  SizedBox(height: 10,),

                  resetButton(),

                ],

              ),

            )

          ],

        ),

      ),

    );
  }

  Widget forgotPasswordTitle(){

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[

          TextSpan(
            text: "Please enter your email address.\n",
            style: TextStyle(color: Colors.blue,fontSize: 18),
          ),

          TextSpan(
            text: "A 4 digit verification code will be sent to this email address.",
            style: TextStyle(color: Colors.black,fontSize: 14),
          ),

        ],
      ),
    );

  }

  Widget emailForgotPassword(){

    RegExp regex = new RegExp(pattern);

    return Theme(

      child: TextFormField(

        controller: _emailTextField,

        validator: (val){
          if(val.isEmpty)
            return 'Email Field is Empty';
          if (!(regex.hasMatch(val)))
            return "Invalid Email";
          if (validateEmailDate()=="false")
            return "Email Not Exists";
          return null;
        },

        obscureText:false,
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

            labelText: 'Email Address',
            //LabelText

            hintText: '123456@gmail.com',
            //HintText

            prefixIcon: Icon(Icons.email)

        ),

      ),

      data: Theme.of(context).copyWith(primaryColor: Colors.orange,),

    );

  }

  Widget resetButton(){

    return ButtonTheme(

      minWidth: 500.0,
      height: 50.0,

      child: RaisedButton(

        textColor: Colors.white,
        color:Colors.orange,
        splashColor: Colors.orangeAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)
        ),
        child: Text('Reset'),
        onPressed: () {

          if(_formKey.currentState.validate()){

            String _randomCharacter="";
            _randomCharacter=RandomCharacter();
            classSendEmail _sendEmail=new classSendEmail(_emailTextField.text,"Forget Password","abc",_randomCharacter);
            sendEmail(_sendEmail);
            changePassword(_emailTextField.text, _randomCharacter);

            final snackBar = SnackBar(
              content: Text('New password send through email'),
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
              content: Text('Please enter valid email'),
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



List   getWidgeteEmail(List<classAccountTechnicianData> list){

  List _list =[];
  for(int i=0;i<list.length;i++){
    _list.add({

      'Account_Email':'${list[i].technicianEmail}',

    });
  }
  return _list;
}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:technician_car_service_system/components/Navigation/AppBarComponents.dart';
import 'package:technician_car_service_system/components/Other%20Components/ConnectionMySql.dart';
import 'package:technician_car_service_system/models/Account/classAccountData.dart';

List<classAccountTechnicianData> accountDataList=[];




class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _counter = 0;
  var db = new Mysql();
  var mail = '';

  void _getAccount() {
    accountDataList.clear();
    db.getConnection().then((conn) {
      String sqlQuery = "SELECT TNC.Technicians_Id,PPL.Peoples_Name,PPL.Peoples_NRIC,PPL.Peoples_Email,PPL.Peoples_Phone_Number,PPL.Peoples_Password FROM Peoples PPL,Technicians TNC WHERE PPL.Peoples_Id=TNC.Peoples_Id AND TNC.Technicians_Id='TNC1'";
      conn.query(sqlQuery).then((results) {
        print('${results}');
        for(var row in results){
          classAccountTechnicianData a=new classAccountTechnicianData();
          a.technicianID=row[0];
          a.technicianName=row[1];
          a.technicianNRIC=row[2];
          a.technicianEmail=row[3];
          a.technicianPhoneNumber=row[4];
          a.technicianPassword=row[5];
          accountDataList.add(a);


        }
        setState(() {
          accountList();
        });
        print('${accountDataList.length}');
      });
      conn.close();
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAccount();
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar:AppBar(

        backgroundColor: Colors.orange,


        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            //back button
          ),
        ],

        iconTheme: new IconThemeData(
          color: Colors.white,

        ),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Text('Profile',

              style: TextStyle(

                  color: Colors.white

              ),

            ),

          ],
        ),
      ),
      body:accountList(),

    );
  }

  Widget accountList(){

    List _elements = [

      {'name': 'Full Name \n${getWidgetAccount(accountDataList)[0]["Technician_Name"]}', 'group': 'Account'},
      {'name': 'IC Number \n${getWidgetAccount(accountDataList)[0]["Technician_NRIC"]}', 'group': 'Account'},
      {'name': 'Email \n${getWidgetAccount(accountDataList)[0]["Technician_Email"]}', 'group': 'Account'},
      {'name': 'Contact Number', 'group': 'Account'},
      {'name': 'Password \n${getWidgetAccount(accountDataList)[0]["Technician_Password"]}', 'group': 'Account'},
      {'name': 'Notification', 'group': 'Settings'},
      {'name': 'Find Us', 'group': 'Help Support'},
      {'name': 'Call Us', 'group': 'Help Support'},
      {'name': 'Share this app', 'group': 'Share'},
      {'name': 'Rate this App', 'group': 'Share'},


    ];

    return Scaffold(

      body:  GroupedListView<dynamic, String>(


        elements: _elements,
        groupBy: (elements) => elements['group'],
        groupComparator: (value1, value2) => value1.compareTo(value1),



        groupSeparatorBuilder: (String value) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

        ),

        itemBuilder: (c, elements) {

          return Card(


            child: Container(
              child: ListTile(
                contentPadding:
                EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),

                title: Text(elements['name']),
                onTap: () {
                  if(elements["name"].toString()=="Password"){
                    Fluttertoast.showToast(
                        msg: ""+elements["FULL NAME"].toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }else if (elements["name"].toString()=="EMAIL"){
                    Fluttertoast.showToast(
                        msg: "EMAIL",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }


                },
              ),
            ),
          );
        },

      ),


    );
  }
}
List   getWidgetAccount(List<classAccountTechnicianData> list){

  List _list =[];
  for(int i=0;i<list.length;i++){
    _list.add({

      'Technician_Id':'${list[i].technicianID}',
      'Technician_Name':'${list[i].technicianName}',
      'Technician_NRIC':'${list[i].technicianNRIC}',
      'Technician_Email':'${list[i].technicianEmail}',
      'Technician_PhoneNumber':'${list[i].technicianPhoneNumber}',
      'Technician_Password':'${list[i].technicianPassword}',

    });
  }
  return _list;
}



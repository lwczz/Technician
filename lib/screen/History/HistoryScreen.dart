import 'package:flutter/material.dart';
import 'package:technician_car_service_system/components/Navigation/AppBarComponents.dart';
import 'package:technician_car_service_system/components/Other%20Components/ConnectionMySql.dart';
import 'package:technician_car_service_system/models/History/classHistoryData.dart';

import 'HistoryDetailScreen.dart';


List<classHistoryData> historyDataList=[];

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _counter = 0;
  var db = new Mysql();


  void _getHistory() {

    historyDataList.clear();
    db.getConnection().then((conn) {
      String sqlQuery = "SELECT BK.Booking_Id,PPL.Peoples_Name FROM Booking BK, Customers CSM,Teams TEAM,Technicians TNC,Peoples PPL WHERE TNC.Teams_Id=TEAM.Teams_Id AND TEAM.Teams_Id=BK.Teams_Id AND BK.Customers_Id=CSM.Customers_Id AND CSM.Peoples_Id=PPL.Peoples_Id AND TNC.Technicians_Id='TNC1' ";
      conn.query(sqlQuery).then((results) {
        print('${results}');
        for(var row in results){
          classHistoryData h=new classHistoryData();
          h.bookingId=row[0];
          h.customerName=row[1];
          historyDataList.add(h);


        }
        setState(() {
          historyList();
        });
        print('${historyDataList.length}');
      });
      conn.close();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHistory();
  }



  @override
  Widget build(BuildContext context) {

    AppBarData _appBarData=new AppBarData('History',null);

    return Scaffold(

      appBar:AppBarTitle(_appBarData),
      body: historyList(),

    );
  }

  Widget historyList(){
    return Scaffold(

      body: ListView.builder(itemCount:  historyDataList.length,

          itemBuilder: (context,index){

            return Container(
              margin:EdgeInsets.fromLTRB(30, 20, 30, 0),

              decoration: BoxDecoration(

                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10)
                ),

              ),

              child: GestureDetector(
                onTap: () => print(historyDataList[index]),
                child: Card(
                  elevation: 5,
                  child: Container(

                    margin:EdgeInsets.fromLTRB(30, 0, 10, 0),

                    height: 50.0,
                    child: Row(
                      children: <Widget>[
                        Text('Customer Name : ${getWidgetHistory(historyDataList)[index]["Customers_Name"]}'),

                        SizedBox(width: 45,),
                        IconButton(icon:Icon(Icons.chevron_right), onPressed: () {



                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => HistoryDetailScreen(),settings: RouteSettings(
                            arguments:todoBookingIdPassing(getWidgetHistory(historyDataList)[index]["Booking_Id"]) ,
                          ),
                          ));

                        },),
                      ],
                    ),

                  ),
                ),

              ),

            );

          }),

    );
  }
}

List   getWidgetHistory(List<classHistoryData> list){

  List _list =[];
  for(int i=0;i<list.length;i++){
    _list.add({

      'Booking_Id':'${list[i].bookingId}',
      'Customers_Name':'${list[i].customerName}',


    });
  }
  return _list;
}

class todoBookingIdPassing{

  String bookingId;
  todoBookingIdPassing(this.bookingId);

}
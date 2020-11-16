import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:technician_car_service_system/components/Navigation/AppBarComponents.dart';
import 'package:technician_car_service_system/components/Other%20Components/ConnectionMySql.dart';
import 'package:technician_car_service_system/models/Job/classJobData.dart';

List<classJobData> jobDataList=[];
List<String> rejectReason=["Leave"];
class JobScreen extends StatefulWidget {
  JobScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {

  var db = new Mysql();

  void _getJob() {

    jobDataList.clear();
    db.getConnection().then((conn) {
      String sqlQuery = "SELECT BK.Booking_Id,PPL.Peoples_Name,BK.Booking_Date FROM FYP_TEST.Job JB,FYP_TEST.Booking BK,FYP_TEST.Teams TEAM,FYP_TEST.Technicians TNC,FYP_TEST.Customers CSM,FYP_TEST.Peoples PPL WHERE TNC.Teams_Id=TEAM.Teams_Id AND TEAM.Teams_Id=JB.Teams_Id AND JB.Booking_Id=BK.Booking_Id AND BK.Customers_Id=CSM.Customers_Id AND CSM.Peoples_Id=PPL.Peoples_Id AND TNC.Leadership='True' AND JB.Teams_Id='TEAM01'";

      conn.query(sqlQuery).then((results) {
        print('${results}');
        for(var row in results){
          classJobData j=new classJobData();
          j.bookingId=row[0];
          j.customerName=row[1];
          j.bookingDate=row[2];
          jobDataList.add(j);

        }
        setState(() {
         jobList();
        });
        print('${jobDataList.length}');
      });
      conn.close();
    });
  }

  void _acceptJob(){

    jobDataList.clear();
    db.getConnection().then((conn) {

      String sqlQuery = "UPDATE Job JB SET JB.Decision='Accept', JB.Assign_Status='Decisioned' WHERE JB.Booking_Id='BK01' AND JB.Teams_Id='TEAM01'";

      conn.query(sqlQuery);

      conn.close();
    });

  }

  void _rejectJob(String reason){

    jobDataList.clear();
    db.getConnection().then((conn) {

      String sqlQuery = "UPDATE Job JB SET JB.Decision='Reject', JB.Assign_Status='Decisioned',JB.Reason_Status='${reason}' WHERE JB.Booking_Id='BK01' AND JB.Teams_Id='TEAM01'";

      conn.query(sqlQuery);

      conn.close();
    });

  }

  void _reasonBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[

                new ListTile(

                    title: new Text('Leave'),
                    onTap: () => {

                      _rejectJob('Leave'),

                    }
                ),

              ],
            ),
          );
        }
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getJob();
  }

  @override
  Widget build(BuildContext context) {

    AppBarData _appBarData=new AppBarData('Job',null);

    return Scaffold(

      appBar:AppBarTitle(_appBarData),
      body: jobList(),

    );
  }

  Widget jobList(){
    return Scaffold(

      body: ListView.builder(itemCount: jobDataList.length,

          itemBuilder: (context,index){

            return Slidable(

                            actionPane: SlidableStrechActionPane(),
                            actionExtentRatio: 0.3,
                            child: Container(
                              margin:EdgeInsets.fromLTRB(0, 20, 0, 0),

                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(10)
                                ),

                              ),

                              child: GestureDetector(
                                onTap: () => print(jobDataList[index]),
                                child: Card(
                                  elevation: 5,
                                  child: Container(

                                      margin:EdgeInsets.fromLTRB(30, 20, 10, 0),

                                      height: 140.0,
                                      child: Container(

                                        child:  Column(

                                          children: <Widget>[

                                            Align(

                                              child:  Text('Customer Name : ${getWidgetJob(jobDataList)[index]["Customers_Name"]}',style: TextStyle(fontSize: 18),),

                                              alignment: Alignment.centerLeft,

                                            ),

                                            Align(

                                              child:  Text('Booking Date       : ${getWidgetJob(jobDataList)[index]["Booking_Date"].toString().substring(0,10)}',style: TextStyle(fontSize: 18),),

                                              alignment: Alignment.centerLeft,

                                            ),

                                            Align(

                                              child:  Text('Booking Time      : ${getWidgetJob(jobDataList)[index]["Booking_Date"].toString().substring(11,18)}',style: TextStyle(fontSize: 18),),

                                              alignment: Alignment.centerLeft,

                                            ),

                                            Align(

                                              child:  Text('Services                : Tire Services',style: TextStyle(fontSize: 18),),

                                              alignment: Alignment.centerLeft,

                                            ),

                                            Align(

                                              child:  Text('Admin assigned  : Lim Soon Yi',style: TextStyle(fontSize: 18),),

                                              alignment: Alignment.centerLeft,

                                            ),

                                            SizedBox(width: 45,),

                                          ],


                                        ),

                                      )

                                  ),
                                ),

                              ),

                            ),

              secondaryActions: <Widget>[

                IconSlideAction(

                  caption: 'Accept',
                  color: Colors.green,
                  icon: Icons.code,

                  onTap: (){
                    _acceptJob();
                  },

                ),

                IconSlideAction(

                  caption: 'Reject',
                  color: Colors.red,
                  icon: Icons.code,

                  onTap: (){

                    _reasonBottomSheet(context);

                  },

                ),

              ],

            );

          }),

    );
  }
}

List   getWidgetJob(List<classJobData> list){

  List _list =[];
  for(int i=0;i<list.length;i++){
    _list.add({

      'Booking_Id':'${list[i].bookingId}',
      'Customers_Name':'${list[i].customerName}',
      'Booking_Date':'${list[i].bookingDate}',

    });
  }
  return _list;
}


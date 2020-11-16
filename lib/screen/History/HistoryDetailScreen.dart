import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:technician_car_service_system/components/Navigation/AppBarComponents.dart';
import 'package:technician_car_service_system/components/Other%20Components/ConnectionMySql.dart';
import 'package:technician_car_service_system/models/History/classHistoryData.dart';
import 'package:technician_car_service_system/screen/History/HistoryScreen.dart';


List<classHistoryDetailsData> historyDetailDataList=[];

class HistoryDetailScreen extends StatefulWidget {
  HistoryDetailScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HistoryDetailScreenState createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {

  String bookingId="";

  int _counter = 0;
  var db = new Mysql();
  var mail = '';

  void _getHistoryDetail() {

    historyDetailDataList.clear();
    db.getConnection().then((conn) {
      String sqlQuery = "SELECT BK.Booking_Id,BK.Booking_Date,CR.Cars_Model,CR.PlateNumber,PPL.Peoples_Name,SSVC.Remarks,BK.Booking_Status,SSVC.Return_Date FROM Booking BK, Customers CSM,Teams TEAM,Technicians TNC,Peoples PPL,Status_Services SSVC,Cars CR WHERE TNC.Teams_Id=TEAM.Teams_Id AND TEAM.Teams_Id=BK.Teams_Id AND BK.Customers_Id=CSM.Customers_Id AND CSM.Peoples_Id=PPL.Peoples_Id AND CSM.Customers_Id=SSVC.Customers_Id AND SSVC.Cars_Id=CR.Cars_Id AND BK.Booking_Id='${bookingId}'";
      conn.query(sqlQuery).then((results) {
        print('${results}');
        for(var row in results){
          classHistoryDetailsData hd=new classHistoryDetailsData();
          hd.bookingId=row[0];
          hd.bookingDate=row[1];
          hd.carsModel=row[2];
          hd.plateNumber=row[3];
          hd.peoplesName=row[4];
          hd.bookingRemarks=row[5];
          hd.bookingStatus=row[6];
          hd.carReturnDate=row[7];
          historyDetailDataList.add(hd);
        }
        setState(() {
          historyDetailList();
        });
        print('${ historyDetailDataList.length}');
      });
      conn.close();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHistoryDetail();
  }



  @override
  Widget build(BuildContext context) {
    todoBookingIdPassing todo = ModalRoute.of(context).settings.arguments;
    bookingId=todo.bookingId;
    AppBarData _appBarData=new AppBarData('d',null);

    return Scaffold(

      appBar:AppBarTitle(_appBarData),
      body: historyDetailList(),

    );
  }

  Widget historyDetailList(){
    return Scaffold(

      body: ExpandableTheme(
        data:
        const ExpandableThemeData(
          iconColor: Colors.orange,
          useInkWell: true,
        ),


        child:  ListView.builder(itemCount:historyDetailDataList.length,

            itemBuilder: (context, index) {

              return ExpandableNotifier(

                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(

                      elevation: 5,

                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 300,
                            child: Container(

                              child: Row(
                                children: <Widget>[

                                  Container(

                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(20, 40, 0, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[


                                          Text('Customer Name       : ${getWidgetHistoryDetail(historyDetailDataList)[index]["Customers_Name"]}',style: TextStyle(fontSize: 20),),
                                          SizedBox(height: 10,),
                                          Text('Booking Date             : ${getWidgetHistoryDetail(historyDetailDataList)[index]["Booking_Date"].toString().substring(0,10)}',style: TextStyle(fontSize: 20)),
                                          SizedBox(height: 10,),
                                          Text('                                       ${getWidgetHistoryDetail(historyDetailDataList)[index]["Booking_Date"].toString().substring(11,19)}',style: TextStyle(fontSize: 20)),
                                          SizedBox(height: 10,),
                                          Text('Car Plate Number     : ${getWidgetHistoryDetail(historyDetailDataList)[index]["Plate_Number"]}',style: TextStyle(fontSize: 20)),
                                          SizedBox(height: 10,),
                                          Text('Car Model                  :${getWidgetHistoryDetail(historyDetailDataList)[index]["Cars_Model"]}',style: TextStyle(fontSize: 20)),
                                          SizedBox(height: 10,),
                                          Text('Return Date               : ${getWidgetHistoryDetail(historyDetailDataList)[index]["Booking_Status"]}',style: TextStyle(fontSize: 20)),
                                          SizedBox(height: 10,),
                                          Text('Services Status         :${getWidgetHistoryDetail(historyDetailDataList)[index]["Car_Return_Date"].toString().substring(0,10)}',style: TextStyle(fontSize: 20)),
                                          SizedBox(height: 10,),
                                          Text('                                      ${getWidgetHistoryDetail(historyDetailDataList)[index]["Car_Return_Date"].toString().substring(11,19)}',style: TextStyle(fontSize: 20)),


                                        ],

                                      ),
                                    ),
                                  ),


                                ],
                              ),

                            ),
                          ),
                          ScrollOnExpand(
                            scrollOnExpand: true,
                            scrollOnCollapse: false,
                            child: ExpandablePanel(
                              theme: const ExpandableThemeData(
                                headerAlignment: ExpandablePanelHeaderAlignment.center,
                                tapBodyToCollapse: true,
                              ),
                              header: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "Remarks",
                                    style: Theme.of(context).textTheme.body2,
                                  )),
                              collapsed: Text(
                                '${getWidgetHistoryDetail(historyDetailDataList)[index]["Booking_Remarks"]}',softWrap: true,
                                  maxLines: 2,
                                overflow: TextOverflow.ellipsis,


                              ),
                              expanded: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[



                                  Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Row(

                                        children: <Widget>[

                                          Text(
                                            '${getWidgetHistoryDetail(historyDetailDataList)[index]["Booking_Remarks"]}',
                                            softWrap: true,
                                            overflow: TextOverflow.fade,style: TextStyle(fontSize: 20)
                                          ),

                                        ],

                                      )

                                  ),



                                ],
                              ),
                              builder: (_, collapsed, expanded) {
                                return Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                  child: Expandable(
                                    collapsed: collapsed,
                                    expanded: expanded,
                                    theme: const ExpandableThemeData(crossFadePoint: 0),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              );

            }),
      ),

    );
  }
}

List   getWidgetHistoryDetail(List<classHistoryDetailsData> list){

  List _list =[];
  for(int i=0;i<list.length;i++){
    _list.add({

      'Booking_Id':'${list[i].bookingId}',
      'Booking_Date':'${list[i].bookingDate}',
      'Cars_Model':'${list[i].carsModel}',
      'Plate_Number':'${list[i].plateNumber}',
      'Customers_Name':'${list[i].peoplesName}',
      'Booking_Remarks':'${list[i].bookingRemarks}',
      'Booking_Status':'${list[i].bookingStatus}',
      'Car_Return_Date':'${list[i].carReturnDate}',

    });
  }
  return _list;
}
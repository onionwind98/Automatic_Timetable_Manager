import 'package:automatic_timetable_manager/Screens/Timetable/dailyTimetable.dart';
import 'package:automatic_timetable_manager/Screens/Timetable/timetableMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/api.dart';
import '../../Shared/myBoxDecoration.dart';
import '../../Shared/myButton.dart';
import '../Tasks/viewTask.dart';

class WeeklyTimetable extends StatefulWidget {


  @override
  _WeeklyTimetableState createState() => _WeeklyTimetableState();
}

class _WeeklyTimetableState extends State<WeeklyTimetable> {
  MyButton button = MyButton();
  MyBoxDecoration boxDeco = MyBoxDecoration();
  Api api = Api();
  late List timeslotList, mainHour;
  List days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
  late List dateRange;
  late List timetableList;
  var timetable;
  late DateTime currentDate;
  final _scrollControllerGroup = LinkedScrollControllerGroup();
  late ScrollController _scrollController1;
  late ScrollController _scrollController2;

  void initState(){
    super.initState();
    timeslotList=[];
    dateRange=[];
    timetableList=[];
    timetable= [];
    mainHour=[];
    currentDate=DateTime.now();

    loadTimeslot();
    loadTimetable(currentDate);
    _scrollController1 = _scrollControllerGroup.addAndGet();
    _scrollController2 = _scrollControllerGroup.addAndGet();


  }

  @override
  void dispose() {
    super.dispose();
  }

  loadTimeslot() async{
    mainHour.clear();
    timeslotList.clear();
    api.getData('getTimeslot').then((res) async{
      setState(() {
        timeslotList = List.from(res);
        for(int i=0; i<timeslotList.length; i++){
          if(i.isEven){
            mainHour.add(timeslotList[i]['startTime']);
          }
        }
      });
      // print(timeslotList);

    });
  }

  loadTimetable(DateTime targetDay) async{
    dateRange.clear();
    timetableList.clear();
    timetable= List.generate(7, (index) => List.generate(49, (index) => {}),growable: false);

    //get target week date from Sunday to Monday
    var subtractAmount=targetDay.weekday;
    var sunday=targetDay.subtract(Duration(days:subtractAmount));
    for(int i=0;i<7;i++){
      List temp=sunday.add(Duration(days: i)).toString().split(" ");
      dateRange.add(temp[0]);
    }

    //add date to timetable list
    for(int i=0; i<days.length;i++){
      timetable[i][48]={
        'date':dateRange[i]
      };
    }

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userID = localStorage.getInt('userID');
    Map data = {
      'userID':userID,
      'weekDateRange': dateRange
    };

    api.postData('getWeeklyTimetable',data).then((res) async{
      setState(() {
        timetableList=List.from(res);
        print(timetableList);

        //input task into timetable
        for(int i=0; i<timetableList.length;i++){
          print(timetableList.length);
          for(int j=0; j<timetable.length;j++){
            if(timetableList[i]['date']==timetable[j][48]['date']){
              int timeslotID = timetableList[i]['timeslotID'];
              timetable[j][timeslotID-1] = timetableList[i]['taskDetails'];
            }
          }
        }
        print(timetable);
      });
    });
  }

  updateTaskStatus(Map task) async{
    api.postData('updateTaskStatus',task).then((res) async{
      print(res);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: screen.height,
        width: screen.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Week navigator
            SizedBox(height: screen.height*0.01),
            Container(
              alignment: Alignment.center,
              width: screen.width*0.95,
              height: screen.height*0.08,
              decoration: boxDeco.timetableDeco(Color.fromRGBO(55, 147, 159, 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    onPressed: () async{
                      print('Previous Week');
                      setState(() {
                        currentDate=currentDate.subtract(Duration(days: 7));
                        loadTimetable(currentDate);
                      });
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      height: screen.height * 0.1,
                      child: Image.asset('assets/img/backButton.png',width: screen.width*0.05,),
                    ),
                  ),
                  Text(
                    dateRange[0].toString().split('-')[1]+'/'+dateRange[0].toString().split('-')[2]+ '   -   ' +
                    dateRange[6].toString().split('-')[1]+'/'+dateRange[6].toString().split('-')[2],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bebasNeue(
                        textStyle:TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      )
                  ),
                  MaterialButton(
                    onPressed: () {
                      print('Next Week');
                      setState(() {
                        currentDate=currentDate.add(Duration(days: 7));
                        loadTimetable(currentDate);
                      });
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      height: screen.height * 0.1,
                      child: Transform.scale(
                          scaleX: -1,
                          child: Image.asset('assets/img/backButton.png',width: screen.width*0.05)
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Main Content
            SizedBox(height: screen.height*0.01),
            Container(
              padding: EdgeInsets.only(top: 10),
              decoration: boxDeco.myBoxDecoration(Color.fromRGBO(127, 235, 249, 1)),
              height: (screen.height*0.67),
              width: (screen.width*0.95),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //day title
                  Container(
                    height: screen.height*0.1,
                    width: screen.width*0.9,
                    padding: EdgeInsets.only(left: screen.width*0.2),
                    child: SingleChildScrollView(
                      controller: _scrollController1,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          7,
                            (index)=>MaterialButton(
                              onPressed: (){

                              },
                              padding: EdgeInsets.all(0),
                              child: Container(
                                  alignment: Alignment.center,
                                  width: screen.width*0.25,
                                  height: screen.height*0.07,
                                  margin: EdgeInsets.all(4.0),
                                  decoration: boxDeco.timetableDeco(Color.fromRGBO(55, 147, 159, 1)),
                                  child:
                                  Text(
                                    days[index].toString()+'\n'+dateRange[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  )
                              )
                            )
                        )
                      ),
                    ),
                  ),
                  //Time and Days Column
                  Container(
                    height: screen.height*0.53,
                    width: screen.width*0.9,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Time Column
                            Column(
                              children: [
                                // SizedBox(height: screen.height*0.08),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                      24,
                                      (index) => Container(
                                        alignment: Alignment.center,
                                        width: screen.width*0.15,
                                        height: screen.height*0.15,
                                        margin: EdgeInsets.all(4.0),
                                        decoration: boxDeco.timetableDeco(Color.fromRGBO(55, 147, 159, 1)),
                                        child: mainHour.isEmpty ? Text(''):
                                        Text(
                                          mainHour[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                  )
                                ),
                              ],
                            ),

                            //Day Columns
                            Flexible(
                              child: SingleChildScrollView(
                                controller: _scrollController2,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(
                                    7,
                                    (index1) => Column(
                                      children: List.generate(
                                        49,
                                          (index2) => timetable[index1][index2]?.isEmpty ?
                                          Container(
                                            width: screen.width*0.25,
                                            height: screen.height*0.07,
                                            margin: EdgeInsets.all(4),
                                            decoration: boxDeco.timetableDeco(Colors.white.withOpacity(0.5)),
                                          ) :
                                          MaterialButton(
                                            onPressed: (){
                                              print(
                                                  'timeslotID: '+ timeslotList[index2]['timeslotID'].toString()+ '\n' +
                                                  'taskID: ' +  timetable[index1][index2]['taskID'].toString()+ '\n' +
                                                  'taskTitle: ' +  timetable[index1][index2]['title'].toString() + '\n' +
                                                  'timeslot: ' + timeslotList[index2]['startTime']+' - '+timeslotList[index2]['endTime']
                                              );
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(32.0))
                                                      ),
                                                      backgroundColor: Color(int.parse(timetable[index1][index2]['taskColor'])),
                                                      actionsAlignment:MainAxisAlignment.center,
                                                      title: Center(
                                                        child: Text(
                                                          timetable[index1][index2]['title'],
                                                            style: GoogleFonts.bebasNeue(
                                                              textStyle:TextStyle(
                                                                fontSize: 40,
                                                                color: Colors.white,
                                                              ),
                                                            )
                                                        )
                                                      ),
                                                      content: Text(
                                                        'Time Slot: '+ timeslotList[index2]['startTime']+' - '+timeslotList[index2]['endTime'],
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                      actions: [
                                                        MaterialButton(
                                                          child: button.myAlertActionButton('View Task', Colors.white, Colors.black, context),
                                                          onPressed: (){
                                                            Navigator.push(context,
                                                              MaterialPageRoute(
                                                                builder: (context) => ViewTask(
                                                                  viewItem:timetable[index1][index2],
                                                                  fromOngoing: timetable[index1][index2]['status']== 2 ? false : true,
                                                                ))).then((value) => {
                                                                  loadTimetable(currentDate)
                                                                }
                                                            );
                                                            // Navigator.pop(context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  }
                                              );
                                            },
                                            padding: EdgeInsets.all(0),
                                            child:  index2==48?
                                            Container():
                                            Container(
                                              alignment: Alignment.center,
                                              width: screen.width*0.25,
                                              height: screen.height*0.07,
                                              margin: EdgeInsets.all(4.0),
                                              decoration:  boxDeco.timetableDeco(timetable[index1][index2]['status']==0 ?
                                                Color(int.parse(timetable[index1][index2]['taskColor'])):
                                                Color(int.parse(timetable[index1][index2]['taskColor'])).withOpacity(0.3)),
                                              child:
                                              timetable[index1][index2]?.isEmpty ? Text('') :
                                              Text(
                                                timetable[index1][index2]['title'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:  Colors.white
                                                ),
                                              )
                                            ),
                                          ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
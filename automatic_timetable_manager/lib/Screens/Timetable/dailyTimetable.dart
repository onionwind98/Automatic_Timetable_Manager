import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/api.dart';
import '../../Shared/myBoxDecoration.dart';
import '../../Shared/myButton.dart';
import '../Tasks/viewTask.dart';

class DailyTimetable extends StatefulWidget {
  DateTime day;
  DailyTimetable({Key? key, required this.day}) : super(key: key);

  @override
  _DailyTimetableState createState() => _DailyTimetableState();
}

class _DailyTimetableState extends State<DailyTimetable> {
  MyButton button = MyButton();
  MyBoxDecoration boxDeco = MyBoxDecoration();
  Api api = Api();
  late List timeslotList, mainHour;
  List days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
  late List timetableList;
  var timetable;
  late DateTime currentDate;
  late Map dayTitle;

  void initState(){
    super.initState();
    timeslotList=[];
    timetableList=[];
    timetable= [];
    mainHour=[];
    currentDate=widget.day;

    loadTimeslot();
    loadTimetable(currentDate);



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
    timetableList.clear();
    timetable= List.generate(48, (index) => {});
    dayTitle={
      'day':DateFormat('EEEE').format(targetDay),
      'date':targetDay.toString().split(" ")[0]
    };
    print(timetable);

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userID = localStorage.getInt('userID');
    Map data = {
      'userID':userID,
      'date': dayTitle['date']
    };

    api.postData('getDailyTimetable',data).then((res) async{
      setState(() {
        timetableList=List.from(res);
        // print(timetableList);

        //input task into timetable
        for(int i=0; i<timetableList.length;i++){
          for(int j=0; j<timetable.length;j++){
            int timeslotID = timetableList[i]['timeslotID'];
            timetable[timeslotID-1] = timetableList[i]['taskDetails'];
            // {
            //   'taskTitle':timetableList[i]['taskTitle'],
            //   'taskID':timetableList[i]['taskID'],
            //   'taskStatus':timetableList[i]['taskStatus']
            // };
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
            //Day Navigator
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
                      print('Yesterday');
                      setState(() {
                        currentDate=currentDate.subtract(Duration(days: 1));
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
                      dayTitle['day'].toString()+'\n'+dayTitle['date'].toString(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bebasNeue(
                        textStyle:TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      )
                  ),
                  MaterialButton(
                    onPressed: () {
                      print('Tomorrow');
                      setState(() {
                        currentDate=currentDate.add(Duration(days: 1));
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
              decoration: boxDeco.myBoxDecoration(Color.fromRGBO(127, 235, 249, 1)),
              height: (screen.height*0.68),
              width: (screen.width*0.95),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screen.height*0.01),
                  Container(
                    height: screen.height*0.63,
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

                            //Task Columns
                            Flexible(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(
                                        48,
                                        (index) => timetable[index]?.isEmpty ?
                                        Container(
                                          width: screen.width*0.7,
                                          height: screen.height*0.07,
                                          margin: EdgeInsets.all(4),
                                          decoration: boxDeco.timetableDeco(Colors.white.withOpacity(0.5)),
                                        ) :
                                        MaterialButton(
                                          onPressed: (){
                                            print(
                                                'timeslotID: '+ timeslotList[index]['timeslotID'].toString()+ '\n' +
                                                    'taskID: ' +  timetable[index]['taskID'].toString()+ '\n' +
                                                    'taskTitle: ' +  timetable[index]['title'].toString() + '\n' +
                                                    'timeslot: ' + timeslotList[index]['startTime']+' - '+timeslotList[index]['endTime']
                                            );
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(32.0))
                                                    ),
                                                    backgroundColor: Color(int.parse(timetable[index]['taskColor'])),
                                                    actionsAlignment:MainAxisAlignment.center,
                                                    title: Center(
                                                        child: Text(
                                                            timetable[index]['title'],
                                                            style: GoogleFonts.bebasNeue(
                                                              textStyle:TextStyle(
                                                                fontSize: 40,
                                                                color: Colors.white,
                                                              ),
                                                            )
                                                        )
                                                    ),
                                                    content: Text(
                                                      'Time Slot: '+ timeslotList[index]['startTime']+' - '+timeslotList[index]['endTime'],
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
                                                                    viewItem:timetable[index],
                                                                    fromOngoing: timetable[index]['status']== 2 ? false : true,
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
                                          child:
                                          //Display tasks
                                          Container(
                                              alignment: Alignment.center,
                                              width: screen.width*0.7,
                                              height: screen.height*0.07,
                                              margin: EdgeInsets.all(4.0),
                                              decoration:  boxDeco.timetableDeco(timetable[index]['status']==0 ? Color(int.parse(timetable[index]['taskColor'])): Color(int.parse(timetable[index]['taskColor'])).withOpacity(0.2))  ,
                                              child:
                                              timetable[index]?.isEmpty ? Text('') :
                                              Text(
                                                timetable[index]['title'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                    color:  Colors.white
                                                ),
                                              )
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
import 'package:automatic_timetable_manager/Screens/Tasks/viewTask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/api.dart';
import '../../Shared/appBar.dart';
import '../../Shared/myBoxDecoration.dart';
import '../../Shared/myButton.dart';
import '../../Shared/sortFunction.dart';

class TaskHistory extends StatefulWidget{
  @override
  _TaskHistoryState createState() => _TaskHistoryState();
}

class _TaskHistoryState extends State<TaskHistory> {
  MyBoxDecoration boxDeco = MyBoxDecoration();
  Api api = Api();
  MyButton button = MyButton();
  SortFunction sortFunction = SortFunction();
  late List ongoingTaskList;
  late bool sortTrigger;
  late String sortOption;
  // late List selectedTask;
  late List taskListHolder;

  late Map selectedDate;
  final DateTime firstDate = DateTime.now().subtract(Duration(days: 4000));
  final DateTime lastDate = DateTime.now().add(Duration(days: 4000));
  late bool dateFilter;

  void initState(){
    super.initState();
    ongoingTaskList=[];
    taskListHolder=[];
    sortTrigger=true;
    sortOption='DateAscending';
    loadTask();

    //set default week selected to this week for date picker on reschedule button
    var sunday = DateTime.now().subtract(Duration(days: DateTime.now().weekday));
    selectedDate={
      'startDate':sunday,
      'endDate':sunday.add(Duration(days: 6)),
      'dateRange':''
    };
    dateFilter=false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadTask() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userID = localStorage.getInt('userID');
    Map data={
      'userID':userID,
    };
    api.postData('getHistoryTask',data).then((res) async{
      setState(() {
        ongoingTaskList = List.from(res);
        for(int i=0; i < ongoingTaskList.length;i++){
          ongoingTaskList[i]['selectedStatus']=false;
          List temp = ongoingTaskList[i]['assignedDate'].split("-");
          DateTime date=DateTime(int.parse(temp[0]),int.parse(temp[1]),int.parse(temp[2]));
          ongoingTaskList[i]['subtitle']=
              DateFormat('E').format(date) + ' ' + date.day.toString() +'/'+date.month.toString() + '   '
                  + ongoingTaskList[i]['startTime']+'-'+ongoingTaskList[i]['endTime'];
        }

        sortFunction.sortFunction(ongoingTaskList, sortOption);
        taskListHolder=[...ongoingTaskList];
        print(ongoingTaskList);
      });
    });
  }

  Widget displayDatePicker(){
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))
      ),
      backgroundColor: Color.fromRGBO(55, 147, 159, 1),
      actionsAlignment:MainAxisAlignment.center,
      title: Text(
        'Choose a week to add tasks into timetable',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 25,
            color: Colors.white
        ),
      ),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return WeekPicker(
              selectedDate: selectedDate['startDate'],
              onChanged: (DatePeriod newPeriod){
                setState(() {
                  //newPeriod.start.day.toString()+'/'+newPeriod.start.day.toString()
                  selectedDate['startDate'] = newPeriod.start;
                  selectedDate['endDate'] =  newPeriod.end;
                  selectedDate['dateRange']= selectedDate['startDate'].year.toString()+'\n'+selectedDate['startDate'].day.toString()+'/'+selectedDate['startDate'].month.toString()+' - '+
                      selectedDate['endDate'].day.toString()+'/'+selectedDate['endDate'].month.toString();
                  print(selectedDate['dateRange']);
                  dateFilter=true;
                  // _selectedPeriod = newPeriod;
                });
              },
              firstDate: firstDate,
              lastDate: lastDate,
              datePickerStyles: DatePickerRangeStyles(
                  defaultDateTextStyle:TextStyle(
                      color: Colors.white
                  ),
                  displayedPeriodTitle:TextStyle(
                      color: Colors.white
                  ),
                  currentDateStyle:TextStyle(
                      color: Colors.white
                  ),
                  dayHeaderStyle: DayHeaderStyle(
                      textStyle: TextStyle(
                          color: Colors.white
                      )
                  )
              ),
              datePickerLayoutSettings: DatePickerLayoutSettings(
                scrollPhysics: NeverScrollableScrollPhysics(),
                showPrevMonthEnd: true,
                showNextMonthStart: true,
              ),
            );
          }
      ),
      actions: [
        MaterialButton(
          child: button.myAlertActionButton('Confirm', Colors.white, Colors.black, context),
          onPressed: () async {
            Navigator.pop(context);
            setState(() {
              print(taskListHolder.length);
              ongoingTaskList=[...taskListHolder];
              // ongoingTaskList
              for(int i=ongoingTaskList.length-1; i>=0;i--){
                print(i);
                if(selectedDate['startDate'].subtract(Duration(days: 1)).isBefore(DateTime.parse(ongoingTaskList[i]['assignedDate']))&&
                selectedDate['endDate'].isAfter(DateTime.parse(ongoingTaskList[i]['assignedDate']))){
                  print('Within Date Range of '+ selectedDate['dateRange']+ ': ' +ongoingTaskList[i]['assignedDate']);
                }else{
                  print('Not Within Date Range of '+ selectedDate['dateRange']+ ': ' +ongoingTaskList[i]['assignedDate']);
                  ongoingTaskList.removeAt(i);
                }
              }
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    MyButton button = MyButton();

    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: screen.height,
          width: screen.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screen.height*0.01),
              //Sort and Date Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Sort Button
                  Container(
                    padding: EdgeInsets.only(left: 20,top: 8),
                    height: screen.height * 0.08,
                    width: screen.width * 0.5,
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black,width: 3.0),
                      color: Color.fromRGBO(55, 147, 159, 1),
                      borderRadius: BorderRadius.circular(40.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: sortOption,
                        items: sortFunction.dropdownItemsOngoingHistory,
                        iconSize: 0,
                        borderRadius: BorderRadius.circular(20),
                        dropdownColor: Color.fromRGBO(55, 147, 159, 1),
                        alignment: Alignment.center,
                        style: GoogleFonts.bebasNeue(
                          textStyle:TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            sortOption = value!;
                            ongoingTaskList = sortFunction.sortFunction(ongoingTaskList, sortOption);
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: screen.height*0.01),
                  //Date Selection Button
                  MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return displayDatePicker();
                          }
                      );
                    },
                    child: button.myShortIconButton(
                        dateFilter?selectedDate['dateRange']:'Date',
                        dateFilter?23:30,
                        Color.fromRGBO(55, 147, 159, 1),
                        'assets/img/dateIcon.png',
                        context
                    ),
                  ),
                ],
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
                    //List of tasks
                    Container(
                      height: screen.height*0.65,
                      width: screen.width*0.95,
                      padding: EdgeInsets.only(top: 10),
                      child: SingleChildScrollView(
                          child:
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            itemCount: ongoingTaskList.isEmpty? 1 : ongoingTaskList.length,
                            itemBuilder: (context,index){
                              if(ongoingTaskList.isNotEmpty){
                                return Column(
                                  children: [
                                    MaterialButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ViewTask(viewItem: ongoingTaskList[index],fromOngoing: true,))).then(
                                                (value) => {loadTask()});
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: screen.height * 0.1,
                                        width: screen.width * 0.9,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(30.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.4),
                                              spreadRadius: 1,
                                              blurRadius: 7,
                                              offset: Offset(0, 5), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0,top:10),

                                          //Items in List view item
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(width: screen.width*0.05),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    ongoingTaskList[index]['title'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(0),
                                                    child: Text(
                                                      ongoingTaskList[index]['subtitle'].toString(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: screen.width*0.15),
                                              Container(
                                                width: screen.width*0.05,
                                                height: screen.height*0.05,
                                                child: Image.asset('assets/img/blueForwardButton.png'),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screen.height*0.015),

                                  ],
                                );
                              }
                              else{
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: screen.height*0.2),
                                      Text(
                                          'Task List Is Empty',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.bebasNeue(
                                            textStyle:TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black38
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                );
                              }

                            },
                          )
                      ),
                    ),
                    SizedBox(height: screen.height*0.01),

                    //Mark task as done button
                    // Center(
                    //   child: MaterialButton(
                    //     onPressed: () async{
                    //       selectedTask.clear();
                    //       for(int i=0; i < ongoingTaskList.length; i++){
                    //         if(ongoingTaskList[i]['selectedStatus']){
                    //           selectedTask.add(ongoingTaskList[i]);
                    //         }
                    //       }
                    //
                    //       Map data = {
                    //         'taskList':selectedTask,
                    //       };
                    //       print(data);
                    //       showDialog(
                    //           context: context,
                    //           builder: (BuildContext context) {
                    //             return AlertDialog(
                    //               actionsAlignment: MainAxisAlignment.center,
                    //               title: Text("Confirmation"),
                    //               content: Text("Mark selected task as done?"),
                    //               actions: [
                    //                 MaterialButton(
                    //                   child: Text('YES'),
                    //                   onPressed: (){
                    //                     api.postData('updateListOfTaskStatus', data).then((value) {
                    //                       print(value);
                    //                     });
                    //                     Navigator.pop(context);
                    //                     loadTask();
                    //                   },
                    //                 ),
                    //                 MaterialButton(
                    //                   child: Text('NO'),
                    //                   onPressed: (){
                    //                     Navigator.pop(context);
                    //                   },
                    //                 ),
                    //               ],
                    //             );
                    //           }
                    //       );
                    //
                    //     },
                    //     child: button.myShortIconButton('Mark As Done', 25, Color.fromRGBO(55, 147, 159, 1), 'assets/img/forwardButton.png', context),
                    //   ),
                    // ),
                  ],
                ),
              )

            ],
          ),
        )
    );

  }

}
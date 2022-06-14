// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:automatic_timetable_manager/Screens/Tasks/createTask.dart';
import 'package:automatic_timetable_manager/Screens/Tasks/editTask.dart';
import 'package:automatic_timetable_manager/Shared/appBar.dart';
import 'package:automatic_timetable_manager/Shared/myButton.dart';
import 'package:automatic_timetable_manager/Shared/sortFunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

import '../../Database/api.dart';
import '../../Shared/myBoxDecoration.dart';
import '../Timetable/timetableMenu.dart';

class UnassignedTasks extends StatefulWidget{

  @override
  _UnassignedTasksState createState() => _UnassignedTasksState();
}

class _UnassignedTasksState extends State<UnassignedTasks> {
  MyBoxDecoration boxDeco = MyBoxDecoration();
  Api api = Api();
  MyButton button = MyButton();
  SortFunction sortFunction = SortFunction();
  late List unassignedTaskList;
  late bool sortTrigger;
  late String sortOption;
  late List selectedTask;

  late Map selectedDate;
  final DateTime firstDate = DateTime.now().subtract(Duration(days: 45));
  final DateTime lastDate = DateTime.now().add(Duration(days: 45));
  // DatePeriod? _selectedPeriod;

  void initState(){
    super.initState();
    unassignedTaskList=[];
    sortTrigger=true;
    sortOption='TitleAscending';
    loadTask();
    selectedTask=[];
    //set default week selected to this week for date picker on reschedule button
    var sunday = DateTime.now().subtract(Duration(days: DateTime.now().weekday));
    selectedDate={
      'startDate':sunday,
      'endDate':sunday.add(Duration(days: 6)),
    };
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
    api.postData('getUnassignedTask',data).then((res) async{
      // print(res);
      setState(() {
        unassignedTaskList = List.from(res);
        for(int i=0; i < unassignedTaskList.length;i++){
          unassignedTaskList[i]['selectedStatus']=false;
        }
        sortFunction.sortFunction(unassignedTaskList, sortOption);

        // print(unassignedTaskList);
      });
    });
  }

  deleteTask(int taskID, BuildContext context) async {
    print(taskID);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Are you sure you want to delete the task?"),
            actions: [
              MaterialButton(
                child: Text('YES'),
                onPressed: (){
                  Map data ={
                    'taskID':taskID
                  };
                  api.postData('deleteTask', data).then((value) {
                    print(value);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Task Deleted!"),
                            content: Text("The task is successfully deleted!"),
                            actions: [
                              MaterialButton(
                                child: Text('OK'),
                                onPressed: (){
                                  loadTask();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        }
                    );
                  });
                },
              ),
              MaterialButton(
                child: Text('NO'),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
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
                  print(newPeriod.start);
                  selectedDate['startDate'] = newPeriod.start;
                  selectedDate['endDate'] = newPeriod.end;
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
          child: button.myAlertActionButton('Confirm Week', Colors.white, Colors.black, context),

          onPressed: () async {
            // print(selectedDate['startDate'].toString()+selectedDate['endDate'].toString());



            SharedPreferences localStorage = await SharedPreferences.getInstance();
            var userID = localStorage.getInt('userID');

            List dateRange = [];
            //get target week date from Sunday to Monday
            for(int i=0;i<7;i++){
              List temp=selectedDate['startDate'].add(Duration(days: i)).toString().split(" ");
              dateRange.add(temp[0]);
            }

            Map data = {
              'userID':userID,
              'taskList':selectedTask,
              'dateRange':dateRange,
            };


            api.postData('addToTimetable', data).then((value) {
              print(value);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Task had been added!"),
                      content: Text("The selected task had been added to the timetable!"),
                      actions: [
                        MaterialButton(
                          child: Text('OK'),
                          onPressed: (){
                            Navigator.pop(context);
                            Navigator.pop(context);
                            loadTask();
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => TimetableMenu(tabSelector: 0))
                            );
                          },
                        ),
                      ],
                    );
                  }
              );
            });
          },
        ),
      ],
    );
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
            //Sort and Add task Button
            SizedBox(height: screen.height*0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Sort Button
                Container(
                  padding: EdgeInsets.only(left:20,top: 8),
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
                      items: sortFunction.dropdownItems,
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
                          unassignedTaskList = sortFunction.sortFunction(unassignedTaskList, sortOption);
                        });
                      },
                    ),
                  ),
                ),

                SizedBox(width: screen.height*0.01),

                //Add Task Button
                MaterialButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => CreateTask(fromDuplicate: false,))
                    ).then((value) => {
                      loadTask()
                    });
                  },
                  child: button.myShortIconButton('Create \nTasks',25, Color.fromRGBO(214, 93, 93, 1),'assets/img/addIcon.png', context),
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
                    height: screen.height*0.57,
                    width: screen.width*0.95,
                    padding: EdgeInsets.only(left:10,top: 10),
                    child: SingleChildScrollView(
                      child:
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0),
                        itemCount: unassignedTaskList.isEmpty? 1 : unassignedTaskList.length,
                        itemBuilder: (context,index){
                          if(unassignedTaskList.isNotEmpty){
                            return Column(
                              children: [
                                Slidable(

                                  //Slide to delete
                                  key: const ValueKey(0),
                                  endActionPane: ActionPane(
                                    extentRatio:0.25,
                                    motion: const ScrollMotion(),
                                    children:  [
                                      // A SlidableAction can have an icon and/or a label.
                                      SlidableAction(
                                          backgroundColor: Color(0xFFFE4A49),
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                          onPressed: (BuildContext context) async{
                                            deleteTask(unassignedTaskList[index]['taskID'],context);
                                          }
                                      ),
                                    ],
                                  ),

                                  //List view item
                                  child: MaterialButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: (){
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => EditTask(editItem: unassignedTaskList[index],))
                                      ).then((value) => {
                                        loadTask()
                                      });
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
                                            Transform.scale(
                                              scale: 1.5,
                                              child: Checkbox(
                                                value: unassignedTaskList[index]['selectedStatus'],
                                                checkColor: Colors.white,
                                                activeColor: Color.fromRGBO(127, 235, 249, 1),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                                onChanged: (newValue){
                                                  setState(() {
                                                    unassignedTaskList[index]['selectedStatus']=newValue!;
                                                  });
                                                }
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  unassignedTaskList[index]['title'],
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
                                                    'Priority Level:'+unassignedTaskList[index]['priorityLevel'].toString(),
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

                                          ],
                                        ),
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
                            //   Container(
                            //   padding: EdgeInsets.all(10),
                            //   height: screen.height*0.3,
                            //   width: screen.width*0.9,
                            //   child: Text(
                            //     'There is no task, click \n Add Task button to create task!',
                            //     textAlign: TextAlign.center,
                            //     style: TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 30,
                            //       color: Color.fromRGBO(214, 93, 93, 1)
                            //     ),
                            //   ),
                            // );
                          }

                        },
                      )
                    ),
                  ),
                  SizedBox(height: screen.height*0.01),

                  //Add to timetable button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Generate Timetable Button
                      SizedBox(width: screen.width*0.02),
                      MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async{
                          selectedTask.clear();
                          for(int i=0; i < unassignedTaskList.length; i++){
                            if(unassignedTaskList[i]['selectedStatus']){
                              selectedTask.add(unassignedTaskList[i]);
                            }
                          }
                          selectedTask=sortFunction.sortFunction(selectedTask, 'PriorityDescending');
                          print('SELECTED TASK: '+selectedTask.toString());

                          if(selectedTask.isEmpty){
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("No task selected"),
                                    content: Text("Please select at least on task by clicking on its checkbox."),
                                    actions: [
                                      MaterialButton(
                                        child: Text('OK'),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                }
                            );
                          }else{
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return displayDatePicker();
                                }
                            );
                          }
                        },
                        child: button.myShortIconButton('Add to\n Timetable', 23, Color.fromRGBO(55, 147, 159, 1), 'assets/img/forwardButton.png', context),
                      ),

                      //Reschedule Timetable Button
                      // SizedBox(width: screen.width*0.01),
                      // MaterialButton(
                      //   padding: EdgeInsets.zero,
                      //   onPressed: (){
                      //
                      //
                      //     showDialog(
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return displayDatePicker('rescheduleTimetable');
                      //         }
                      //     );
                      //   },
                      //   child: button.myShortIconButton('Reschedule \n Timetable', 23, Color.fromRGBO(214, 93, 93, 1), 'assets/img/forwardButton.png', context),
                      // ),
                    ],
                  )
                ],
              ),
            )

          ],
        ),
      )
    );
  }

}
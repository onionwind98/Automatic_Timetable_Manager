// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:automatic_timetable_manager/Screens/Tasks/addTask.dart';
import 'package:automatic_timetable_manager/Screens/Tasks/editTask.dart';
import 'package:automatic_timetable_manager/Shared/appBar.dart';
import 'package:automatic_timetable_manager/Shared/myButton.dart';
import 'package:automatic_timetable_manager/Shared/sortFunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import '../../Database/api.dart';
import '../../Shared/myBoxDecoration.dart';

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

  void initState(){
    super.initState();
    unassignedTaskList=[];
    sortTrigger=true;
    sortOption='TitleAscending';
    loadTask();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadTask() async{
    api.getData('getTask').then((res) async{
      setState(() {
        unassignedTaskList = List.from(res);
        sortFunction.sortFunction(unassignedTaskList, sortOption);
        print(res);
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
            SizedBox(height: screen.height*0.01),
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
                        context, MaterialPageRoute(builder: (context) => AddTask())
                    ).then((value) => {
                      loadTask()
                    });
                  },
                  child: button.myShortIconButton('Add Tasks',27, Color.fromRGBO(214, 93, 93, 1),'assets/img/addIcon.png', context),
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
                                        padding: const EdgeInsets.only(left: 20.0,top:10),

                                        //Items in List view item
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
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
                              child: CircularProgressIndicator(
                                color: Color.fromRGBO(55, 147, 159, 1),
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

                  //Generate and reschdule timetable button
                  Row(
                    children: [
                      SizedBox(width: screen.width*0.02),
                      MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){

                        },
                        child: button.myShortIconButton('Generate \n Timetable', 23, Color.fromRGBO(55, 147, 159, 1), 'assets/img/forwardButton.png', context),
                      ),
                      SizedBox(width: screen.width*0.01),
                      MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){

                        },
                        child: button.myShortIconButton('Reschedule \n Timetable', 23, Color.fromRGBO(214, 93, 93, 1), 'assets/img/forwardButton.png', context),
                      ),
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
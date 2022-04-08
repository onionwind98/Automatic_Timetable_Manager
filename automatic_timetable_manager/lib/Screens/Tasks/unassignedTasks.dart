import 'package:automatic_timetable_manager/Screens/Tasks/addTask.dart';
import 'package:automatic_timetable_manager/Shared/appBar.dart';
import 'package:automatic_timetable_manager/Shared/myButton.dart';
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
  late StreamController _streamController ;

  void initState(){
    super.initState();
    _streamController = new StreamController();
    loadTask();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadTask() async{
    api.getData('getTask').then((res) async{
      _streamController.add(res);
      return res;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    MyButton button = MyButton();

    deleteTask(int taskID) async {
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
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: screen.height,
        width: screen.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screen.height*0.01),
            //Add Task Button
            MaterialButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => AddTask())
                );
              },
              child: button.myLongButton('Add Tasks', Color.fromRGBO(55, 147, 159, 1),context),
            ),

            SizedBox(height: screen.height*0.01),
            Container(
              decoration: boxDeco.whiteBoxDecoration(Color.fromRGBO(127, 235, 249, 1)),
              height: (screen.height*0.68),
              width: (screen.width*0.9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screen.height*0.01),
                  //List of tasks
                  Container(
                    height: screen.height*0.57,
                    width: screen.width*0.9,
                    padding: EdgeInsets.only(left:10,top: 10),
                    child: SingleChildScrollView(
                      child: StreamBuilder<dynamic> (
                        stream: _streamController.stream,
                        builder: (context,snapshot){
                          if(snapshot.hasData){
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.all(0),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context,index){

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
                                              onPressed: (BuildContext context){
                                                deleteTask(snapshot.data[index]['taskID']);

                                              }
                                          ),
                                        ],
                                      ),

                                      //List view item
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: screen.height * 0.1,
                                        width: screen.width * 0.85,
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
                                                    snapshot.data[index]['title'],
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
                                                      'Priority Level:'+snapshot.data[index]['priorityLevel'].toString(),
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
                                    SizedBox(height: screen.height*0.015),

                                  ],
                                );
                              },
                            );
                          }

                          else if (snapshot.connectionState != ConnectionState.done) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          else {
                            return Text(snapshot.error.toString());
                          }
                        },

                      ),
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
import 'package:automatic_timetable_manager/Screens/Tasks/addTask.dart';
import 'package:automatic_timetable_manager/Shared/appBar.dart';
import 'package:automatic_timetable_manager/Shared/myButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Shared/myBoxDecoration.dart';

class UnassignedTasks extends StatefulWidget{
  @override
  _UnassignedTasksState createState() => _UnassignedTasksState();
}

class _UnassignedTasksState extends State<UnassignedTasks> {
  MyBoxDecoration boxDeco = MyBoxDecoration();

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
            SizedBox(height: screen.height*0.02),
            //Add Task Button
            MaterialButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => AddTask())
                );
              },
              child: button.myLongButton('Add Tasks', Color.fromRGBO(55, 147, 159, 1),context),
            ),

            SizedBox(height: screen.height*0.02),
            Container(
              decoration: boxDeco.whiteBoxDecoration(Color.fromRGBO(127, 235, 249, 1)),
              height: (screen.height*0.67),
              width: (screen.width*0.9),
              child: Column(
                children: [

                ],
              ),
            )

          ],
        ),
      )
    );
  }

}
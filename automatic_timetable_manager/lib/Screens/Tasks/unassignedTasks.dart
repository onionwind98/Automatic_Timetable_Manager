import 'package:automatic_timetable_manager/Shared/appBar.dart';
import 'package:automatic_timetable_manager/Shared/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UnassignedTasks extends StatefulWidget{
  @override
  _UnassignedTasksState createState() => _UnassignedTasksState();
}

class _UnassignedTasksState extends State<UnassignedTasks> {

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    Button button = Button();

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

              },
              child: button.longButton('Add Tasks', Color.fromRGBO(55, 147, 159, 1),context),
            ),

            SizedBox(height: screen.height*0.02),
            Container(
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.black,width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Color.fromRGBO(127, 235, 249, 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
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
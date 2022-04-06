import 'package:automatic_timetable_manager/Screens/Tasks/assignedTasks.dart';
import 'package:automatic_timetable_manager/Screens/Tasks/taskHistory.dart';
import 'package:automatic_timetable_manager/Screens/Tasks/unassignedTasks.dart';
import 'package:automatic_timetable_manager/Shared/myButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Shared/appBar.dart';

class TaskMenu extends StatefulWidget {
  @override
  _TaskMenuState createState() => _TaskMenuState();
}

class _TaskMenuState extends State<TaskMenu> {


  final tabs = [
    UnassignedTasks(),
    AssignedTasks(),
    TaskHistory(),
  ];


  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: AppBar(
            backgroundColor:  Color.fromRGBO(127, 235, 249, 1),
            bottom: TabBar(
              tabs: const [
                Tab(child: Text('Unassigned',style: TextStyle(fontSize: 17))),
                Tab(child: Text('Assigned',style: TextStyle(fontSize: 17))),
                Tab(child: Text('History',style: TextStyle(fontSize: 17))),
              ],
            ),
            leading:  Padding(
              padding: EdgeInsets.only(top:15),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: screen.height * 0.17,
                  child: Image.asset('assets/img/backButton.png'),
                ),
              ),
            ),
            centerTitle: true,
            title: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                'Tasks',
                style: GoogleFonts.bebasNeue(
                  textStyle: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            UnassignedTasks(),
            AssignedTasks(),
            TaskHistory(),
          ],
        ),

        //OLD TASK MENU
        // body: Container(
        //   height: screen.height,
        //   width: screen.width,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       SizedBox(height: screen.height * 0.1),
        //       //Unassigned Task Button
        //       MaterialButton(
        //         padding: EdgeInsets.all(0),
        //         onPressed: () {
        //           Navigator.push(context, MaterialPageRoute(builder: (context) => UnassignedTasks()));
        //         },
        //         child: button.longButton('Unassigned Tasks', Color.fromRGBO(55, 147, 159, 1),context)
        //       ),
        //       SizedBox(height: screen.height * 0.1),
        //
        //       //Assigned Task Button
        //       MaterialButton(
        //         padding: EdgeInsets.all(0),
        //         onPressed: () {
        //           Navigator.push(context, MaterialPageRoute(builder: (context) => AssignedTasks()));
        //         },
        //         child: button.longButton('Assigned Tasks', Color.fromRGBO(71, 232, 194, 1),context)
        //       ),
        //       SizedBox(height: screen.height * 0.1),
        //
        //       //Task History Button
        //       MaterialButton(
        //         padding: EdgeInsets.all(0),
        //         onPressed: () {
        //           Navigator.push(context, MaterialPageRoute(builder: (context) => TaskHistory()));
        //         },
        //         child:button.longButton('Task History', Color.fromRGBO(127, 235, 249, 1),context)
        //       ),
        //       //    ],
        //       //  ),
        //       // )
        //     ],
        //   ),
        // ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Shared/appBar.dart';
import '../../Shared/button.dart';

class AssignedTasks extends StatefulWidget{
  @override
  _AssignedTasksState createState() => _AssignedTasksState();
}

class _AssignedTasksState extends State<AssignedTasks> {

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Sort by Button
                    MaterialButton(
                      onPressed: (){

                      },
                      child: button.shortIconButton(
                          'Sort by',
                          Color.fromRGBO(55, 147, 159, 1),
                          'assets/img/sortIcon.png',
                          context
                      ),
                    ),

                  //Date Selection Button
                  MaterialButton(
                    onPressed: (){

                    },
                    child: button.shortIconButton(
                        'Date',
                        Color.fromRGBO(55, 147, 159, 1),
                        'assets/img/dateIcon.png',
                        context
                    ),
                  ),
                ],
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
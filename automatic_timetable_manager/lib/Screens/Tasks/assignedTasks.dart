import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Shared/appBar.dart';
import '../../Shared/myBoxDecoration.dart';
import '../../Shared/myButton.dart';

class AssignedTasks extends StatefulWidget{
  @override
  _AssignedTasksState createState() => _AssignedTasksState();
}

class _AssignedTasksState extends State<AssignedTasks> {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Sort by Button
                    MaterialButton(
                      onPressed: (){

                      },
                      child: button.myShortIconButton(
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
                    child: button.myShortIconButton(
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
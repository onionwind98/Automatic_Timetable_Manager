import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Shared/appBar.dart';
import '../../Shared/myBoxDecoration.dart';
import '../../Shared/myButton.dart';

class TaskHistory extends StatefulWidget{
  @override
  _TaskHistoryState createState() => _TaskHistoryState();
}

class _TaskHistoryState extends State<TaskHistory> {
  TextEditingController titleController = TextEditingController();
  MyButton button = MyButton();
  MyBoxDecoration boxDeco = MyBoxDecoration();

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
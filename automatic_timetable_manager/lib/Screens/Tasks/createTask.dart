import 'dart:convert';

import 'package:automatic_timetable_manager/Screens/Tasks/taskMenu.dart';
import 'package:automatic_timetable_manager/Shared/blockColorPicker.dart';
import 'package:automatic_timetable_manager/Shared/myBoxDecoration.dart';
import 'package:automatic_timetable_manager/Shared/myTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../Database/api.dart';
import '../../Shared/myButton.dart';

class CreateTask extends StatefulWidget {
  Map? createDuplicate;
  bool fromDuplicate;
  CreateTask({Key? key, this.createDuplicate, required this.fromDuplicate}) : super(key: key);

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  MyButton button = MyButton();
  MyTextField textField = MyTextField();
  MyBoxDecoration boxDeco = MyBoxDecoration();
  Api api = Api();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late double priorityLevel;
  late bool preferredTimeCheck, preferredDateCheck;
  //late bool repeatOnCheck;
  // late List repeatList;
  late String startPreferredTime,endPreferredTime;

  DateTime selectedDate = DateTime.now();
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now().add(Duration(days: 365));

  late Color taskColor;

  @override
  void initState(){
    if(!widget.fromDuplicate){
      super.initState();
      priorityLevel=1.0;
      preferredTimeCheck=false;
      preferredDateCheck=false;
      startPreferredTime='00:00';
      endPreferredTime="00:00";
      taskColor= Colors.red;
    }else{
      print(widget.createDuplicate);
      titleController.text=widget.createDuplicate!['title'];
      descriptionController.text= widget.createDuplicate!['description'] ?? '';
      priorityLevel= widget.createDuplicate!['priorityLevel'].toDouble();
      preferredTimeCheck=false;
      preferredDateCheck=false;
      startPreferredTime='00:00';
      endPreferredTime="00:00";
      taskColor= Colors.red;
    }

  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    // Widget showRepeatOnButton(String day){
    //   Color color;
    //   if(repeatList.contains(day)){
    //     if(repeatOnCheck){
    //       color = Color.fromRGBO(55, 147, 159, 1);
    //     }else{
    //       color = Color.fromRGBO(55, 147, 159, 0.5);
    //     }
    //   }else{
    //     color = Color.fromRGBO(55, 147, 159, 0.5);
    //   }
    //   return MaterialButton(
    //
    //     onPressed: repeatOnCheck ?  (){
    //       if(repeatList.contains(day)){
    //         setState(() {
    //           repeatList.remove(day);
    //         });
    //       }else{
    //         setState(() {
    //           repeatList.add(day);
    //         });
    //       }
    //       print(repeatList.toString());
    //     } : null,
    //     padding: EdgeInsets.all(0),
    //     child: button.mySmallButton(day, color, context),
    //   );
    // }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromRGBO(127, 235, 249, 1),
      body: Container(
        height: screen.height,
        width: screen.width,
        child: Scrollbar(
          radius: Radius.circular(30),
          thumbVisibility: true,
          trackVisibility: true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screen.height*0.03),
                //Title and Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: screen.width*0.25),
                    Text(
                      'Create Tasks',
                      style: GoogleFonts.bebasNeue(
                        textStyle: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ),
                    SizedBox(width: screen.width*0.1),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: screen.height*0.1,
                        child: Image.asset('assets/img/closeIcon.png'),
                      ),
                    ),
                  ],
                ),

                //Title text field
                textField.myTextField(titleController, 'Title', screen.height*0.14, screen.width*0.9, context),

                //Priority Field
                SizedBox(height: screen.height*0.03),
                Container(
                  height: screen.height*0.18,
                  width: screen.width*0.9,
                  decoration: boxDeco.myBoxDecoration(Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screen.height*0.03),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          'Priority Level',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30),
                        width: screen.width*0.8,
                        child: SfSliderTheme(
                          data: SfSliderThemeData(
                            thumbColor: Colors.white,
                            thumbStrokeWidth: 2,
                            thumbStrokeColor: Colors.black54,
                            activeLabelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                                color: Colors.black54
                            ),
                            inactiveLabelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black26
                            ),
                            activeTrackColor: Colors.black54,
                            activeTrackHeight: 10,
                            inactiveTrackColor: Colors.black26,
                            inactiveTrackHeight: 10,
                            activeDividerColor: Colors.black54,
                            activeDividerRadius: 5,
                            inactiveDividerColor: Colors.black26,
                            inactiveDividerRadius: 5,
                          ),
                          child: SfSlider(
                            min: 1.0,
                            max: 5.0,
                            value: priorityLevel,
                            interval: 1,
                            stepSize: 1,
                            showTicks: true,
                            showLabels: true,
                            showDividers: true,
                            enableTooltip: true,
                            onChanged: (dynamic value){
                              setState(() {
                                priorityLevel = value;
                              });
                              print(priorityLevel);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Description text field
                SizedBox(height: screen.height*0.03),
                textField.myTextField(descriptionController, 'Description', screen.height*0.2, screen.width*0.9, context),

                //Preferred Time
                SizedBox(height: screen.height*0.03),
                Container(
                  height: screen.height*0.2,
                  width: screen.width*0.9,
                  decoration: boxDeco.myBoxDecoration(Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children:  [
                      //Title and checkbox
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Preferred Time',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),
                            ),
                            Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                value: preferredTimeCheck,
                                checkColor: Colors.white,
                                activeColor: Color.fromRGBO(127, 235, 249, 1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                onChanged: (newValue){
                                  setState(() {
                                    preferredTimeCheck=newValue!;
                                  });
                                }
                              ),
                            )
                          ],
                        ),
                      ),

                      //Time Picker
                      Row(
                        children: [
                          SizedBox(width: screen.width*0.03),
                          AbsorbPointer(
                            absorbing: preferredTimeCheck ? false : true,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40)
                              ),
                              width: screen.width*0.4,
                              height: screen.width*0.2,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                initialDateTime: DateTime( 0, 0),
                                minuteInterval:30,
                                onDateTimeChanged: (DateTime newDateTime) {
                                  setState(() {
                                    startPreferredTime=newDateTime.hour.toString().padLeft(2,'0')+':'+newDateTime.minute.toString().padLeft(2,'0');
                                  });
                                  print('time:'+startPreferredTime);
                                },
                                use24hFormat: true,
                              ),
                            ),
                          ),

                          SizedBox(width: screen.width*0.03),
                          AbsorbPointer(
                            absorbing: preferredTimeCheck ? false : true,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40)
                              ),
                              width: screen.width*0.4,
                              height: screen.width*0.2,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                initialDateTime: DateTime( 0, 0),
                                minuteInterval:30,
                                onDateTimeChanged: (DateTime newDateTime) {
                                  setState(() {
                                    endPreferredTime=newDateTime.hour.toString().padLeft(2,'0')+':'+newDateTime.minute.toString().padLeft(2,'0');
                                  });
                                  print('time:'+endPreferredTime);
                                },
                                use24hFormat: true,
                              ),
                            ),
                          ),


                        ],
                      )
                    ],
                  ),
                ),

                //Preferred Date
                SizedBox(height: screen.height*0.03),
                Container(
                  height: screen.height*0.55,
                  width: screen.width*0.9,
                  decoration: boxDeco.myBoxDecoration(Colors.white),
                  child: Column(
                    children: [
                      //Title and checkbox
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Preferred Date',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),
                            ),
                            Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                  value: preferredDateCheck,
                                  checkColor: Colors.white,
                                  activeColor: Color.fromRGBO(127, 235, 249, 1),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  onChanged: (newValue){
                                    setState(() {
                                      preferredDateCheck=newValue!;
                                      print(preferredDateCheck);
                                    });
                                  }
                              ),
                            )
                          ],
                        ),
                      ),

                      //date picker
                      Container(
                        height: screen.height*0.47,
                        width: screen.width*0.8,
                        child: AbsorbPointer(
                          absorbing: preferredDateCheck ? false : true,
                          child: dp.DayPicker.single(
                            selectedDate: selectedDate,
                            onChanged: (DateTime newDate){
                              setState(() {
                                selectedDate = newDate;
                                print(selectedDate.day.toString()+'/'+selectedDate.month.toString()+'/'+selectedDate.year.toString());
                              });
                            },
                            firstDate: firstDate,
                            lastDate: lastDate,
                            datePickerStyles: dp.DatePickerRangeStyles(
                              selectedSingleDateDecoration: BoxDecoration(
                                color: Color.fromRGBO(55, 147, 159, 1),
                                shape: BoxShape.circle
                              ),
                              currentDateStyle: TextStyle(
                                color: Color.fromRGBO(127, 235, 249, 1)
                              )
                            ),
                            datePickerLayoutSettings: dp.DatePickerLayoutSettings(
                              scrollPhysics: NeverScrollableScrollPhysics(),
                              maxDayPickerRowCount: 2,
                              showPrevMonthEnd: true,
                              showNextMonthStart: true,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ),

                //Color Picker
                SizedBox(height: screen.height*0.03),
                Container(
                  height: screen.height*0.4,
                  width: screen.width*0.9,
                  decoration: boxDeco.myBoxDecoration(Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Title
                      SizedBox(height: screen.height*0.03),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          'Task Color',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54
                          ),
                        ),
                      ),
                      SizedBox(height: screen.height*0.01),
                      Center(
                        child: Container(
                          height: screen.height*0.3,
                          width: screen.width*0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                            color: Color.fromRGBO(127, 235, 249, 0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all( 10.0),
                            child: BlockColorPicker(
                              pickerColor: taskColor,
                              onColorChanged: (Color value) {
                                setState(() {
                                  taskColor = value;
                                  print(taskColor);
                                });
                              },

                            ),
                          )
                        ),
                      )
                    ],
                  ),
                ),
                // //Repeat On
                // SizedBox(height: screen.height*0.03),
                // Container(
                //   height: screen.height*0.28,
                //   width: screen.width*0.9,
                //   decoration: boxDeco.myBoxDecoration(Colors.white),
                //   child: Column(
                //     children: [
                //       //Title and checkbox
                //       Padding(
                //         padding: const EdgeInsets.only(left: 20.0,top: 10),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               'Repeat On',
                //               style: TextStyle(
                //                   fontSize: 25,
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.black54
                //               ),
                //             ),
                //             Transform.scale(
                //               scale: 1.5,
                //               child: Checkbox(
                //                   value: repeatOnCheck,
                //                   checkColor: Colors.white,
                //                   activeColor: Color.fromRGBO(127, 235, 249, 1),
                //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                //                   onChanged: (newValue){
                //                     setState(() {
                //                       repeatOnCheck=newValue!;
                //                       print(repeatOnCheck);
                //                     });
                //                   }
                //               ),
                //             )
                //           ],
                //         ),
                //       ),
                //
                //       //Day Selection Button
                //       Container(
                //         height: screen.height*0.2,
                //         width: screen.width*0.8,
                //         child: GridView.count(
                //           physics: NeverScrollableScrollPhysics(),
                //           padding: EdgeInsets.all(0),
                //           crossAxisCount: 3,
                //           crossAxisSpacing: 5,
                //           mainAxisSpacing: 0,
                //           childAspectRatio: 2,
                //           children: [
                //             showRepeatOnButton('Monday'),
                //             showRepeatOnButton('Tuesday'),
                //             showRepeatOnButton('Wednesday'),
                //             showRepeatOnButton('Thursday'),
                //             showRepeatOnButton('Friday'),
                //             showRepeatOnButton('Saturday'),
                //             showRepeatOnButton('Sunday'),
                //             showRepeatOnButton('Weekday'),
                //             showRepeatOnButton('Weekend'),
                //           ],
                //         ),
                //       )
                //     ],
                //   ),
                // ),

                SizedBox(height: screen.height*0.03),
                MaterialButton(
                  onPressed: () async{
                    SharedPreferences localStorage = await SharedPreferences.getInstance();
                    var userID = localStorage.getInt('userID');
                    List preferredTime = preferredTimeCheck ? [startPreferredTime,endPreferredTime] : [];
                    List selectedDateTemp = preferredDateCheck ? selectedDate.toString().split(" ") : ['',''];
                    Map data = {
                      'userID':userID,
                      'title':titleController.text,
                      'priorityLevel':priorityLevel,
                      'description':descriptionController.text,
                      'status': 1,
                      'preferredTime':jsonEncode(preferredTime),
                      'preferredDate':selectedDateTemp[0],
                      'taskColor':taskColor.value
                      // 'repeatOn':jsonEncode(repeatList),
                    };

                    if(data['title']==''){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Empty title!"),
                              content: Text("Please fill give the task a title."),
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
                      api.postData('addTask', data).then((value) {
                        print(value);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Task added!"),
                                content: Text("The new task had been added!"),
                                actions: [
                                  MaterialButton(
                                    child: Text('OK'),
                                    onPressed: (){
                                      if(widget.fromDuplicate){
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => TaskMenu())
                                        );
                                      }else{
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              );
                            }
                        );
                      });
                    }
                  },
                  child: button.myShortIconButton(
                      'Create Task',
                      27,
                      Color.fromRGBO(55, 147, 159, 1),
                      'assets/img/forwardButton.png',
                      context
                  ),
                ),

                SizedBox(height: screen.height*0.1),


              ],
            ),
          ),
        ),
      ),
    );
  }

}
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../Database/api.dart';
import '../../Shared/blockColorPicker.dart';
import '../../Shared/myBoxDecoration.dart';
import '../../Shared/myButton.dart';
import '../../Shared/myTextField.dart';
import 'createTask.dart';

class ViewTask extends StatefulWidget {
  Map viewItem;
  bool fromOngoing;
  ViewTask({Key? key, required this.viewItem,required this.fromOngoing}) : super(key: key);

  @override
  _ViewTaskState createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  MyButton button = MyButton();
  MyTextField textField = MyTextField();
  MyBoxDecoration boxDeco = MyBoxDecoration();
  Api api = Api();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late double priorityLevel;
  // late bool preferredTimeCheck,preferredDateCheck;
  //late bool repeatOnCheck;
  // late List repeatList;
  late String startPreferredTime,endPreferredTime;
  late List startTime, endTime;
  late DateTime selectedDate;
  late DateTime firstDate = DateTime.now().subtract(Duration(days: 365));
  DateTime lastDate = DateTime.now().add(Duration(days: 365));
  late Color taskColor;

  @override
  void initState() {
    taskColor = Color(int.parse(widget.viewItem['taskColor']));
    print(widget.viewItem);
    super.initState();
    titleController.text = widget.viewItem['title'];
    priorityLevel = widget.viewItem['priorityLevel'].toDouble();

    if (widget.viewItem['description'] == null) {
      descriptionController.text = "";
    } else {
      descriptionController.text = widget.viewItem['description'].toString();
    }
    startPreferredTime =widget.viewItem['startTime'];
    endPreferredTime =widget.viewItem['endTime'];
    startTime=startPreferredTime.split(":");
    endTime=endPreferredTime.split(":");

    selectedDate=DateTime.parse(widget.viewItem['assignedDate']);
  }

  @override
  void dispose() {
    super.dispose();
  }

  deleteTask(int taskID, BuildContext context) async {
    print(taskID);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Text("Confirmation"),
            content: Text("Are you sure you want to remove the task from timetable?"),
            actions: [
              MaterialButton(
                child: Text('YES'),
                onPressed: () async {
                  SharedPreferences localStorage = await SharedPreferences.getInstance();
                  var userID = localStorage.getInt('userID');
                  Map data = {
                    'taskID': taskID,
                    'userID': userID,
                  };
                  api.postData('removeTaskFromTimetable', data).then((value) {
                    print(value);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            actionsAlignment: MainAxisAlignment.center,
                            title: Text("Task Removed!"),
                            content: Text("The task is successfully removed from the timetable!"),
                            actions: [
                              MaterialButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        });
                  });
                },
              ),
              MaterialButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

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
                SizedBox(height: screen.height * 0.03),
                //Title and Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: screen.width * 0.2),
                    Text('Tasks Details',
                        style: GoogleFonts.bebasNeue(
                          textStyle: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                    SizedBox(width: screen.width * 0.02),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: screen.height * 0.1,
                        child: Image.asset('assets/img/closeIcon.png'),
                      ),
                    ),
                  ],
                ),

                //Title text field
                textField.myTextField(titleController, 'Title',
                    screen.height * 0.14, screen.width * 0.9, context),

                //Priority Field
                SizedBox(height: screen.height * 0.03),
                Container(
                  height: screen.height * 0.18,
                  width: screen.width * 0.9,
                  decoration: boxDeco.myBoxDecoration(Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screen.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          'Priority Level',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30),
                        width: screen.width * 0.8,
                        child: SfSliderTheme(
                          data: SfSliderThemeData(
                            thumbColor: Colors.white,
                            thumbStrokeWidth: 2,
                            thumbStrokeColor: Colors.black54,
                            activeLabelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black54),
                            inactiveLabelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black26),
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
                            onChanged: (dynamic value) {
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
                SizedBox(height: screen.height * 0.03),
                textField.myTextField(descriptionController, 'Description',
                    screen.height * 0.2, screen.width * 0.9, context),

                //Assigned Time
                SizedBox(height: screen.height * 0.03),
                Container(
                  height: screen.height * 0.2,
                  width: screen.width * 0.9,
                  decoration: boxDeco.myBoxDecoration(Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      //Title and checkbox
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20),
                        child: Text(
                          'Assigned Time Slot',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),

                      //Time Picker
                      Row(
                        children: [
                          SizedBox(width: screen.width * 0.03),
                          AbsorbPointer(
                            absorbing: true,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40)),
                              width: screen.width * 0.4,
                              height: screen.width * 0.2,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                initialDateTime: DateTime(
                                    1969,
                                    1,
                                    1,
                                    int.parse(startTime[0]),
                                    int.parse(startTime[1])),
                                minuteInterval: 30,
                                onDateTimeChanged: (DateTime newDateTime) {
                                  setState(() {
                                    // startPreferredTime = newDateTime.hour
                                    //         .toString()
                                    //         .padLeft(2, '0') +
                                    //     ':' +
                                    //     newDateTime.minute
                                    //         .toString()
                                    //         .padLeft(2, '0');
                                  });
                                  print('time:' + startPreferredTime);
                                },
                                use24hFormat: true,
                              ),
                            ),
                          ),
                          SizedBox(width: screen.width * 0.03),
                          AbsorbPointer(
                            absorbing: true,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40)),
                              width: screen.width * 0.4,
                              height: screen.width * 0.2,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                initialDateTime: DateTime(
                                    1969,
                                    1,
                                    1,
                                    int.parse(endTime[0]),
                                    int.parse(endTime[1])),
                                minuteInterval: 30,
                                onDateTimeChanged: (DateTime newDateTime) {
                                  setState(() {
                                    // endPreferredTime = newDateTime.hour
                                    //         .toString()
                                    //         .padLeft(2, '0') +
                                    //     ':' +
                                    //     newDateTime.minute
                                    //         .toString()
                                    //         .padLeft(2, '0');
                                  });
                                  print('time:' + endPreferredTime);
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

                //Assigned Date
                SizedBox(height: screen.height * 0.03),
                Container(
                  padding: EdgeInsets.only(left: 20,top: 20),
                    height: screen.height * 0.55,
                    width: screen.width * 0.9,
                    decoration: boxDeco.myBoxDecoration(Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Title and checkbox
                         Text(
                            'Assigned Date',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),

                        Container(
                          height: screen.height * 0.47,
                          width: screen.width * 0.8,
                          child: AbsorbPointer(
                            absorbing: true,
                            child: dp.DayPicker.single(
                              selectedDate: selectedDate,
                              onChanged: (DateTime newDate) {
                                setState(() {
                                  // selectedDate = newDate;
                                  // print(selectedDate.day.toString() +
                                  //     '/' +
                                  //     selectedDate.month.toString() +
                                  //     '/' +
                                  //     selectedDate.year.toString());
                                });
                              },
                              firstDate: firstDate,
                              lastDate: lastDate,
                              datePickerStyles: dp.DatePickerRangeStyles(
                                  selectedSingleDateDecoration: BoxDecoration(
                                      color: Color.fromRGBO(55, 147, 159, 1),
                                      shape: BoxShape.circle),
                                  currentDateStyle: TextStyle(
                                      color: Color.fromRGBO(127, 235, 249, 1))),
                              datePickerLayoutSettings:
                                  dp.DatePickerLayoutSettings(
                                scrollPhysics: NeverScrollableScrollPhysics(),
                                maxDayPickerRowCount: 2,
                                showPrevMonthEnd: true,
                                showNextMonthStart: true,
                              ),
                            ),
                          ),
                        )
                      ],
                    )),

                //Color Picker
                SizedBox(height: screen.height * 0.03),
                Container(
                  height: screen.height * 0.4,
                  width: screen.width * 0.9,
                  decoration: boxDeco.myBoxDecoration(Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Title
                      SizedBox(height: screen.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          'Task Color',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                      SizedBox(height: screen.height * 0.01),
                      Center(
                        child: Container(
                            height: screen.height * 0.3,
                            width: screen.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              color: Color.fromRGBO(127, 235, 249, 0.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: BlockColorPicker(
                                pickerColor: taskColor,
                                onColorChanged: (Color value) {
                                  setState(() {
                                    taskColor = value;
                                  });
                                },
                              ),
                            )),
                      )
                    ],
                  ),
                ),

                //Delete Task and Save Edit Button
                SizedBox(height: screen.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Delete Task Button
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        deleteTask(widget.viewItem['taskID'], context);
                      },
                      child: button.myShortIconButton(
                          'Delete \n from Timetable',
                          20,
                          Color.fromRGBO(214, 93, 93, 1),
                          'assets/img/forwardButton.png',
                          context),
                    ),

                    SizedBox(width: screen.height * 0.01),

                    //Save Edit Button
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        SharedPreferences localStorage =
                            await SharedPreferences.getInstance();
                        var userID = localStorage.getInt('userID');
                        Map data = {
                          'taskID': widget.viewItem['taskID'],
                          'title': titleController.text,
                          'priorityLevel': priorityLevel,
                          'description': descriptionController.text,
                          'taskColor': taskColor.value
                          // 'repeatOn':jsonEncode(repeatList),
                        };
                        print(data);
                        if (data['title'] == '') {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Empty title!"),
                                  content: Text(
                                      "Please fill give the task a title."),
                                  actions: [
                                    MaterialButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else {
                          api.postData('viewTaskEdit', data).then((value) {
                            print(value);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    actionsAlignment: MainAxisAlignment.center,
                                    title: Text("Task edited!"),
                                    content: Text("The task had been edited!"),
                                    actions: [
                                      MaterialButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          });
                        }
                      },
                      child: button.myShortIconButton(
                          'Save Edit',
                          27,
                          Color.fromRGBO(55, 147, 159, 1),
                          'assets/img/forwardButton.png',
                          context),
                    ),
                  ],
                ),

                //Mark As Done & Create Duplicate Button
                SizedBox(height: screen.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Mark As Done Button
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        // List task = [widget.viewItem];


                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                actionsAlignment: MainAxisAlignment.center,
                                title: Text(widget.viewItem['status'] == 0?"Mark the task as DONE.":"Mark the task as ONGOING."),
                                content: Text(widget.viewItem['status'] == 0?"Mark task as done?":"Mark task as ongoing?"),
                                actions: [
                                  MaterialButton(
                                    child: Text('NO'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  MaterialButton(
                                    child: Text('YES'),
                                    onPressed: () {
                                      setState(() {
                                        widget.viewItem['status']= widget.viewItem['status'] == 2 ? 0 : 2;
                                      });

                                      Map data = widget.viewItem;

                                      print('DATA: '+data.toString());

                                      api.postData(
                                          'updateTaskStatus', data)
                                          .then((value) {
                                        print(value);
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: button.myShortIconButton(
                          widget.viewItem['status'] == 0?'Mark As Done':'Mark As \nOngoing',
                          25,
                          Colors.cyan,
                          'assets/img/forwardButton.png',
                          context),
                    ),

                    SizedBox(width: screen.height * 0.01),

                    //Create Duplicate Button
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => CreateTask(fromDuplicate: true,createDuplicate: widget.viewItem,))
                        );
                      },
                      child: button.myShortIconButton(
                          'Create \n Duplicate Task',
                          22,
                          Colors.green,
                          'assets/img/forwardButton.png',
                          context),
                    ),

                  ],
                ),
                SizedBox(height: screen.height * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

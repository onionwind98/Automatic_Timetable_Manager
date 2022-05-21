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

class EditTask extends StatefulWidget {
  Map editItem;
  EditTask({Key? key, required this.editItem}) : super(key: key);

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  MyButton button = MyButton();
  MyTextField textField = MyTextField();
  MyBoxDecoration boxDeco = MyBoxDecoration();
  Api api = Api();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late double priorityLevel;
  late bool preferredTimeCheck,preferredDateCheck;
  //late bool repeatOnCheck;
  // late List repeatList;
  late String startPreferredTime;
  late String endPreferredTime;
  late List startTime, endTime;
  late DateTime selectedDate;
  late DateTime firstDate = DateTime.now().subtract(Duration(days: 365));
  DateTime lastDate = DateTime.now().add(Duration(days: 365));
  late Color taskColor;
  @override
  void initState(){
    taskColor= Color(int.parse(widget.editItem['taskColor']));
    print(widget.editItem);
    super.initState();
    titleController.text=widget.editItem['title'];
    priorityLevel=widget.editItem['priorityLevel'].toDouble();

    if(widget.editItem['description']==null){
      descriptionController.text="";
    }else{
      descriptionController.text=widget.editItem['description'].toString();
    }

    List preferredTime=jsonDecode(widget.editItem['preferredTime']);
    if(preferredTime.isEmpty){
      preferredTimeCheck=false;
      startPreferredTime='00:00';
      endPreferredTime="00:00";
      startTime=startPreferredTime.split(":");
      endTime=endPreferredTime.split(":");
    }else{
      preferredTimeCheck=true;
      startPreferredTime=preferredTime[0];
      endPreferredTime=preferredTime[1];
      startTime=startPreferredTime.split(":");
      endTime=endPreferredTime.split(":");
    }

    if(widget.editItem['preferredDate']==null){
      preferredDateCheck=false;
      selectedDate = DateTime.now();
    }else{
      preferredDateCheck=true;
      List temp = widget.editItem['preferredDate'].split("-");
      selectedDate=DateTime(int.parse(temp[0]),int.parse(temp[1]),int.parse(temp[2]));
    }

    // if(widget.editItem['repeatOn'].isEmpty){
    //   repeatOnCheck=false;
    //   repeatList=[];
    // }else{
    //   repeatOnCheck=true;
    //   repeatList=jsonDecode(widget.editItem['repeatOn']);
    // }

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
                                  Navigator.pop(context);
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
                    SizedBox(width: screen.width*0.33),
                    Text(
                        'Edit Tasks',
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
                                initialDateTime: DateTime(1969, 1, 1, int.parse(startTime[0]), int.parse(startTime[1])),
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
                                initialDateTime:DateTime(1969, 1, 1, int.parse(endTime[0]), int.parse(endTime[1])),
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

                //Delete Task & Save Edit button
                SizedBox(height: screen.height*0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Delete Task Button
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async{
                        deleteTask(widget.editItem['taskID'],context);
                      },
                      child: button.myShortIconButton(
                          'Delete Task',
                          27,
                          Color.fromRGBO(214, 93, 93, 1),
                          'assets/img/forwardButton.png',
                          context
                      ),
                    ),

                    SizedBox(width: screen.height*0.01),

                    //Save Edit Button
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async{
                        SharedPreferences localStorage = await SharedPreferences.getInstance();
                        var userID = localStorage.getInt('userID');
                        List preferredTime = preferredTimeCheck ? [startPreferredTime,endPreferredTime] : [];
                        List selectedDateTemp = preferredDateCheck ? selectedDate.toString().split(" ") : ['',''];
                        Map data = {
                          'taskID':widget.editItem['taskID'],
                          'title':titleController.text,
                          'priorityLevel':priorityLevel,
                          'description':descriptionController.text,
                          'preferredTime':jsonEncode(preferredTime),
                          'preferredDate':selectedDateTemp[0],
                          'taskColor':taskColor.value
                        // 'repeatOn':jsonEncode(repeatList),
                        };
                        print(data);
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
                          api.postData('editTask', data).then((value) {
                            print(value);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Task edited!"),
                                    content: Text("The task had been edited!"),
                                    actions: [
                                      MaterialButton(
                                        child: Text('OK'),
                                        onPressed: (){
                                          Navigator.pop(context);
                                          Navigator.pop(context);
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
                          'Save Edit',
                          27,
                          Color.fromRGBO(55, 147, 159, 1),
                          'assets/img/forwardButton.png',
                          context
                      ),
                    ),
                  ],
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
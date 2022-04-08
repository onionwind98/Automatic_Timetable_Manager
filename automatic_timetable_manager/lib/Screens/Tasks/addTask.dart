import 'dart:convert';

import 'package:automatic_timetable_manager/Shared/myBoxDecoration.dart';
import 'package:automatic_timetable_manager/Shared/myTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../Database/api.dart';
import '../../Shared/myButton.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  MyButton button = MyButton();
  MyTextField textField = MyTextField();
  MyBoxDecoration boxDeco = MyBoxDecoration();
  Api api = Api();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  // FixedExtentScrollController startHourController =FixedExtentScrollController(initialItem: 0);
  // FixedExtentScrollController startMinuteController =FixedExtentScrollController(initialItem: 0);
  // FixedExtentScrollController endHourController =FixedExtentScrollController(initialItem: 0);
  // FixedExtentScrollController endMinuteController =FixedExtentScrollController(initialItem: 0);

  // List hour=['00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23'];
  // List minute=['00','30'];

  late double priorityLevel;
  late bool preferredTimeCheck;
  late bool repeatOnCheck;
  late List repeatList;
  late String startPreferredTime;
  late String endPreferredTime;


  @override
  void initState(){
    super.initState();
    priorityLevel=1.0;
    preferredTimeCheck=false;
    repeatOnCheck=false;
    repeatList=[];
    startPreferredTime='00:00';
    endPreferredTime="00:00";
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    SfRangeValues _initialValues = SfRangeValues(1.0,1.0);


    // Widget showPreferredTimeSlider(FixedExtentScrollController sliderController, List item){
    //   bool hourOrMin;
    //   return AbsorbPointer(
    //     absorbing: preferredTimeCheck ? false : true,
    //     child: CupertinoPicker(
    //       scrollController: sliderController,
    //       itemExtent: screen.height*0.06,
    //       backgroundColor: Colors.white,
    //       onSelectedItemChanged: (int value) {
    //         if(item==hour){
    //           print(sliderController.selectedItem.toString().padLeft(2,'0'));
    //         }else{
    //           if(sliderController.selectedItem==0){
    //             print('00');
    //           }else{
    //             print('30');
    //           }
    //         }
    //       },
    //       children: [
    //         for (var i = 0;
    //         i < item.length;
    //         i++)
    //           Padding(
    //             padding: EdgeInsets.all(10),
    //             child: Text(
    //               item[i],
    //               style: TextStyle(color: preferredTimeCheck? Colors.black : Colors.black12),
    //             ),
    //           )
    //       ],
    //
    //     ),
    //   );
    // }

    Widget showRepeatOnButton(String day){
      Color color;
      if(repeatList.contains(day)){
        if(repeatOnCheck){
          color = Color.fromRGBO(55, 147, 159, 1);
        }else{
          color = Color.fromRGBO(55, 147, 159, 0.5);
        }
      }else{
        color = Color.fromRGBO(55, 147, 159, 0.5);
      }
      return MaterialButton(

        onPressed: repeatOnCheck ?  (){
          if(repeatList.contains(day)){
            setState(() {
              repeatList.remove(day);
            });
          }else{
            setState(() {
              repeatList.add(day);
            });
          }
          print(repeatList.toString());
        } : null,
        padding: EdgeInsets.all(0),
        child: button.mySmallButton(day, color, context),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      'Add Tasks',
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
                  decoration: boxDeco.whiteBoxDecoration(Colors.white),
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
                  decoration: boxDeco.whiteBoxDecoration(Colors.white),
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

                          // Start time
                          // Container(
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(40.0),
                          //   ),
                          //   width: screen.width*0.18,
                          //   child: showPreferredTimeSlider(startHourController,hour)
                          // ),
                          // Text(
                          //   ':',
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 20,
                          //     fontWeight: FontWeight.bold
                          //   ),
                          // ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(40.0),
                          //   ),
                          //   width: screen.width*0.18,
                          //   child: showPreferredTimeSlider(startMinuteController,minute)
                          // ),
                          //
                          // //Dash
                          // Container(
                          //   height: 5,
                          //   width: 20,
                          //   decoration: BoxDecoration(
                          //     color: Colors.black38,
                          //     borderRadius: BorderRadius.circular(40.0),
                          //   ),
                          // ),
                          //
                          // //End Time
                          // Container(
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(40.0),
                          //   ),
                          //   width: screen.width*0.18,
                          //   child: showPreferredTimeSlider(endHourController,hour)
                          // ),
                          // Text(
                          //   ':',
                          //   style: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.bold
                          //   ),
                          // ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(40.0),
                          //   ),
                          //   width: screen.width*0.18,
                          //   child: showPreferredTimeSlider(endMinuteController,minute)
                          // ),

                        ],
                      )
                    ],
                  ),
                ),

                //Repeat On
                SizedBox(height: screen.height*0.03),
                Container(
                  height: screen.height*0.28,
                  width: screen.width*0.9,
                  decoration: boxDeco.whiteBoxDecoration(Colors.white),
                  child: Column(
                    children: [
                      //Title and checkbox
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Repeat On',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),
                            ),
                            Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                  value: repeatOnCheck,
                                  checkColor: Colors.white,
                                  activeColor: Color.fromRGBO(127, 235, 249, 1),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  onChanged: (newValue){
                                    setState(() {
                                      repeatOnCheck=newValue!;
                                      print(repeatOnCheck);
                                    });
                                  }
                              ),
                            )
                          ],
                        ),
                      ),

                      //Day Selection Button
                      Container(
                        height: screen.height*0.2,
                        width: screen.width*0.8,
                        child: GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(0),
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 0,
                          childAspectRatio: 2,
                          children: [
                            showRepeatOnButton('Monday'),
                            showRepeatOnButton('Tuesday'),
                            showRepeatOnButton('Wednesday'),
                            showRepeatOnButton('Thursday'),
                            showRepeatOnButton('Friday'),
                            showRepeatOnButton('Saturday'),
                            showRepeatOnButton('Sunday'),
                            showRepeatOnButton('Weekday'),
                            showRepeatOnButton('Weekend'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: screen.height*0.03),
                MaterialButton(
                  onPressed: () async{
                    SharedPreferences localStorage = await SharedPreferences.getInstance();
                    var userID = localStorage.getInt('userID');
                    List preferredTime = preferredTimeCheck ? [startPreferredTime,endPreferredTime] : [];
                    Map data = {
                      'userID':userID,
                      'title':titleController.text,
                      'priorityLevel':priorityLevel,
                      'description':descriptionController.text,
                      'status': false,
                      'preferredTime':jsonEncode(preferredTime),
                      'repeatOn':jsonEncode(repeatList),
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
                      'Add Task',
                      30,
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
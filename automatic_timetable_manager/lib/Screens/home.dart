// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:automatic_timetable_manager/Screens/Settings/setting.dart';
import 'package:automatic_timetable_manager/Screens/Tasks/taskMenu.dart';
import 'package:automatic_timetable_manager/Screens/Timetable/timetableMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/api.dart';
import '../Shared/myBoxDecoration.dart';
import 'Tasks/viewTask.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MyBoxDecoration boxDeco = MyBoxDecoration();
  Api api = Api();
  DateTime today = DateTime.now();
  late List taskList=[];

  void initState(){
    super.initState();
    loadTodayTask();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadTodayTask() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userID = localStorage.getInt('userID');
    Map data = {
      'userID':userID,
      'today': today.toString().split(" ")[0]
    };
    print(today.toString().split(" ")[0]);
    api.postData('getTodaySchedule',data).then((res) async{
      setState(() {
        print(res);
        taskList=List.from(res);
        print(taskList);
        // print(timetableList);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen= MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          height: screen.height,
          width: screen.width,
          child: Column(
            children: [
              SizedBox(height: screen.height*0.03,),
              //Title and setting button
              Row(
                children: [
                  SizedBox(width: screen.width*0.07),
                  Text(
                      'Welcome Back!',
                      style: GoogleFonts.bebasNeue(
                        textStyle:TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      )
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Setting())
                      ).then((value) => loadTodayTask() );
                    },
                    child: Container(
                      height: screen.height*0.1,
                      child: Image.asset('assets/img/settingIcon.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screen.height*0.001),

              //Main content
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    //Blue Background
                    child: Container(
                      decoration: boxDeco.myBoxDecoration(Color.fromRGBO(127, 235, 249, 1)),
                      height: (screen.height*0.8),
                      width: (screen.width*0.95),
                      child: Column(
                        children: [
                          SizedBox(height: screen.height*0.02,),

                          //White Background
                          Container(
                            decoration: BoxDecoration(
                              // border: Border.all(color: Colors.black,width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(0, 5), // changes position of shadow
                                ),
                              ],
                            ),
                            height: (screen.height*0.55),
                            width: (screen.width*0.85),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  //Title button to daily timetable
                                  MaterialButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => TimetableMenu(tabSelector: 0,))
                                      ).then((value) => loadTodayTask() );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Today\'s Schedule',
                                          style: GoogleFonts.bebasNeue(
                                            textStyle:TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                            ),
                                          )
                                        ),
                                        SizedBox(width: screen.width*0.05),
                                        Container(
                                          width: screen.width*0.05,
                                          height: screen.height*0.05,
                                          child: Image.asset('assets/img/blueForwardButton.png'),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //List of today's task
                                  Container(
                                    height: screen.height*0.45,
                                    width: screen.width*0.95,
                                    padding: EdgeInsets.only(left:5,top: 5),
                                    child: SingleChildScrollView(
                                        child:
                                        ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.all(0),
                                          itemCount: taskList.isEmpty? 1 : taskList.length,
                                          itemBuilder: (context,index){
                                            if(taskList.isNotEmpty){
                                              return Column(
                                                children: [
                                                  MaterialButton(
                                                    padding: EdgeInsets.zero,
                                                    onPressed:(){
                                                      Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                      builder: (context) => ViewTask(viewItem: taskList[index],fromOngoing: true,))).then(
                                                      (value) => {loadTodayTask()});
                                                    },
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      height: screen.height * 0.1,
                                                      width: screen.width * 0.9,
                                                      decoration: BoxDecoration(
                                                        color: taskList[index]['status']==0?Color(int.parse(taskList[index]['taskColor'])):Color(int.parse(taskList[index]['taskColor'])).withOpacity(0.2),
                                                        borderRadius: BorderRadius.circular(30.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey.withOpacity(0.4),
                                                            spreadRadius: 1,
                                                            blurRadius: 7,
                                                            offset: Offset(0, 5), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 15.0,top:10),

                                                        //Items in List view item
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [

                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  taskList[index]['title'],
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 25,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.white
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(0),
                                                                  child: Text(
                                                                    taskList[index]['startTime'].toString()+' - '+taskList[index]['endTime'].toString(),
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 25,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.white
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                            // Transform.scale(
                                                            //   scale: 1.5,
                                                            //   child: Checkbox(
                                                            //       value: taskList[index]['taskStatus'],
                                                            //       checkColor: Colors.white,
                                                            //       activeColor: Color.fromRGBO(127, 235, 249, 1),
                                                            //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                                            //       onChanged: (newValue){
                                                            //         setState(() {
                                                            //           taskList[index]['taskStatus']=newValue!;
                                                            //         });
                                                            //       }
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: screen.height*0.015),

                                                ],
                                              );
                                            }
                                            else{
                                              return Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(height: screen.height*0.2),
                                                    Text(
                                                        'No Task Available Today',
                                                        textAlign: TextAlign.center,
                                                        style: GoogleFonts.bebasNeue(
                                                          textStyle:TextStyle(
                                                              fontSize: 30,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black38
                                                          ),
                                                        )
                                                    ),
                                                  ],
                                                ),
                                              );
                                              //   Container(
                                              //   padding: EdgeInsets.all(10),
                                              //   height: screen.height*0.3,
                                              //   width: screen.width*0.9,
                                              //   child: Text(
                                              //     'There is no task, click \n Add Task button to create task!',
                                              //     textAlign: TextAlign.center,
                                              //     style: TextStyle(
                                              //       fontWeight: FontWeight.bold,
                                              //       fontSize: 30,
                                              //       color: Color.fromRGBO(214, 93, 93, 1)
                                              //     ),
                                              //   ),
                                              // );
                                            }

                                          },
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screen.height*0.02,),

                          //Buttons for Task and Timetable page
                          Row(
                            children: [
                              SizedBox(width: screen.width*0.05,),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: Offset(0, 5), // changes position of shadow
                                    ),
                                  ],
                                ),
                                height: screen.height*0.17,
                                width: screen.width*0.4,
                                child: MaterialButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: (){
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => TaskMenu())
                                    ).then((value) => loadTodayTask() );
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      SizedBox(
                                        height: screen.height*0.1,
                                        child: Image.asset('assets/img/taskIcon.png'),
                                      ),
                                      Text(
                                        'Task',
                                        style: GoogleFonts.bebasNeue(
                                          textStyle:TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(13, 101, 107, 1)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: screen.width*0.05,),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: Offset(0, 5), // changes position of shadow
                                    ),
                                  ],
                                ),
                                height: screen.height*0.17,
                                width: screen.width*0.4,
                                child: MaterialButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: (){
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => TimetableMenu(tabSelector: 0))
                                    ).then((value) => loadTodayTask() );;
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      SizedBox(
                                        height: screen.height*0.1,
                                        child: Image.asset('assets/img/timetableIcon.png'),
                                      ),
                                      Text(
                                        'Timetable',
                                        style: GoogleFonts.bebasNeue(
                                          textStyle:TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(13, 101, 107, 1)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),


                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
  
}
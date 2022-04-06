// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:automatic_timetable_manager/Screens/Settings/setting.dart';
import 'package:automatic_timetable_manager/Screens/Tasks/taskMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Shared/myBoxDecoration.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MyBoxDecoration boxDeco = MyBoxDecoration();

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
                      );
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
                      decoration: boxDeco.whiteBoxDecoration(Color.fromRGBO(127, 235, 249, 1)),
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
                                    );
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
                                    print('timetable');
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
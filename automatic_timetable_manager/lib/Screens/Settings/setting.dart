import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/api.dart';
import '../Authentication/login.dart';

class Setting extends StatefulWidget{
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Api api = Api();

  @override
  Widget build(BuildContext context) {
    Size screen= MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.black,width: 2.0),
                    borderRadius: BorderRadius.only(bottomLeft:Radius.circular(30),bottomRight:Radius.circular(30)),
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
                  height: (screen.height*0.15),
                ),
              ),
              Positioned(
                top:screen.height*0.01,
                left:screen.height*0.02,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: screen.height*0.17,
                        child: Image.asset('assets/img/backButton.png'),
                      ),
                    ),
                    SizedBox(width: 30,),
                    Text(
                        'Settings',
                        style: GoogleFonts.bebasNeue(
                          textStyle:TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        )
                    ),
                    SizedBox(width: 40,),
                    Container(
                      width: 50,
                      child: MaterialButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () async{
                          await api.getData('logout').then((value) async {
                            print(value);
                            if(value['message']=='Logged out'){
                              print('hilogout');
                              SharedPreferences localStorage = await SharedPreferences.getInstance();
                              localStorage.remove('user');
                              localStorage.remove('token');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            }
                          });

                        },
                        child: Icon(Icons.logout,size: 50,color: Colors.white,),

                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
  
}
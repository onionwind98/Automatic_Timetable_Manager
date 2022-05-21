import 'package:automatic_timetable_manager/Screens/Settings/changeEmail.dart';
import 'package:automatic_timetable_manager/Screens/Settings/changePassword.dart';
import 'package:automatic_timetable_manager/Shared/myButton.dart';
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
  MyButton button = MyButton();
  @override
  Widget build(BuildContext context) {
    Size screen= MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screen.height*0.08),
        child: AppBar(
          backgroundColor:  Color.fromRGBO(127, 235, 249, 1),
          leading:  Padding(
            padding: EdgeInsets.only(top:15),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: screen.height * 0.17,
                child: Image.asset('assets/img/backButton.png'),
              ),
            ),
          ),
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
                'Settings',
                style: GoogleFonts.bebasNeue(
                  textStyle: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
            ),
          ),
        ),
      ),

      body: Container(
        height: screen.height,
        width: screen.width,
        child: Column(
          children: [
            SizedBox(height: screen.height*0.1),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ChangeEmail())
                );
              },
              child: button.myLongSettingButton('Change \n Email Address',  Color.fromRGBO(55, 147, 159, 1), 'assets/img/emailIcon.png', context),
            ),

            SizedBox(height: screen.height*0.1),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ChangePassword())
                );
              },
              child: button.myLongSettingButton('Change \n Password',  Color.fromRGBO(71, 232, 194, 1), 'assets/img/emailIcon.png', context),
            ),

            SizedBox(height: screen.height*0.1),
            MaterialButton(
              padding: EdgeInsets.zero,
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
              child: button.myShortIconButton('Logout', 30, Colors.black, 'assets/img/signOutButton.png', context),
            ),



          ],
        ),
      ),
    );
  }
  
}
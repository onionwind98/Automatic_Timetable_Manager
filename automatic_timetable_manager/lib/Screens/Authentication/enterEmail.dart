import 'package:automatic_timetable_manager/Screens/Authentication/enterVerificationCode.dart';
import 'package:automatic_timetable_manager/Screens/Authentication/resetPassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Database/api.dart';

class EnterEmail extends StatefulWidget{
  @override
  _EnterEmailState createState() => _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail> {
  TextEditingController emailController = TextEditingController();
  Api api = Api();
  late bool error,isLoading;
  late String errorText;

  @override
  void initState(){
    super.initState();
    errorText='';
    error=false;
    isLoading=false;

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(127, 235, 249, 1),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: screen.height*0.05,
            left: 10,
            child: Hero(
              tag:'backButton',
              child: Container(
                width: 30,
                child: MaterialButton(
                    padding: EdgeInsets.all(0),
                    onPressed:(){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios_outlined,size:50,)
                ),
              ),
            ),
          ),
          Positioned(
            top:screen.height*0.15,
            child: Column(
              children: [
                Text(
                    'Enter Email Address',
                    style: GoogleFonts.bebasNeue(
                      textStyle:TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                ),
                Text(
                  'Enter email address to \n reset your password',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Container(
                  height: 60,
                  width: screen.width*0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        hintStyle: TextStyle(
                          fontSize: 17,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none
                        ),
                        contentPadding: EdgeInsets.all(20),
                      ),
                      cursorColor: Colors.black
                  ),
                ),
                SizedBox(height: 20),
                if(error)
                  Container(
                      alignment: Alignment.center,
                      height: screen.height*0.05,
                      width: screen.width*0.7,
                      child: Text(
                        errorText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      )
                  ),
                MaterialButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    var emailFormat = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                    bool emailValid = RegExp(emailFormat).hasMatch(emailController.text);
                    setState(() {
                      isLoading=true;
                    });
                    if(emailController.text.isEmpty){
                      setState(() {
                        errorText='Please fill in the email address!';
                        error=true;
                        isLoading=false;

                      });
                    }else if(!emailValid){
                      setState(() {
                        errorText='Please enter a valid email address format!';
                        error=true;
                        isLoading=false;
                      });
                    }
                    else{
                      Map data = {
                        'email': emailController.text
                      };
                      error=false;
                      api.postData('checkSendEmail', data).then((value) {
                        if(value['message']=='Invalid Email Address'){
                          setState(() {
                            errorText='Please enter a valid email address to reset the password.';
                            error=true;
                          });
                        }else{
                          setState(() {
                            isLoading=false;
                          });
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => EnterVerificationCode(email: emailController.text,))
                          );
                        }
                      });

                    }

                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: screen.width*0.7,
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black,width: 3.0),
                      color: Color.fromRGBO(55, 147, 159, 1),
                      borderRadius: BorderRadius.circular(40.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: isLoading? Center(child:CircularProgressIndicator()):
                    Text(
                      'Send \n Verification Email',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: screen.height*0.4,
                  child: Image.asset('assets/img/enterEmailPic.png'),
                )
              ],
            ),
          ),

        ],
      ),
    );


  }

}
import 'login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Database/api.dart';
import '../../Shared/alertDialog.dart';

class Signup extends StatefulWidget{
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Api api = Api();
  MyAlertDialog alertDialog = MyAlertDialog();
  late bool error;
  late String errorText;

  @override
  void initState(){
    super.initState();
    errorText='';
    error=false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen= MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: <Widget> [
                    //Background
                    Hero(
                      tag: 'background',
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
                        height: (screen.height*0.85),
                      ),
                    ),

                    //Main Content
                    Positioned(
                      top:screen.height*0.1,
                      child: Column(
                          children:[
                            //Title
                            Text(
                              'Sign Up',
                              style: GoogleFonts.bebasNeue(
                                textStyle:TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: screen.height*0.04),

                            //Email Address Text Box
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
                                        fontWeight: FontWeight.bold
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
                            SizedBox(height: screen.height*0.03),

                            //Password Text Box
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
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold
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
                            SizedBox(height: screen.height*0.03),

                            //Error Text
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
                            SizedBox(height: screen.height*0.02),

                            //Sign Up Button
                            MaterialButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () async{
                                if(emailController.text.isEmpty||passwordController.text.isEmpty){
                                  setState(() {
                                    errorText='Please fill in all sections!';
                                    error=true;
                                  });
                                }else{
                                  error=false;
                                  var data = {
                                    'email': emailController.text,
                                    'password': passwordController.text
                                  };

                                  api.postData('register', data).then((value) {
                                    print(value);
                                    if(value['errors']['email'][0]=='The email has already been taken.'){
                                      alertDialog.showAlertDialog('Email Taken','Please enter a valid email address.',context);
                                    }else{
                                      alertDialog.showAlertDialog('Account Registered!','Proceed to Login Page',context);
                                    }
                                  });

                                  // Navigator.push(
                                  //     context, MaterialPageRoute(builder: (context) => loginOTP(data: data))
                                  // );
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
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screen.height*0.05),

                            //Sign Up Illustration
                            Container(
                              height: screen.height*0.2,
                              child: Image.asset('assets/img/signupPic.png'),
                            ),
                          ]
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screen.height*0.03),

                //Redirection to Login Page
                RichText(
                  text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                            )
                        ),
                        TextSpan(
                            text: 'Login here!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: Color.fromRGBO(55, 147, 159, 1),
                                fontSize: 20
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = (){
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => Login())
                                );
                              }
                        )
                      ]
                  ),
                )
              ],
            ),
          ),
        )
    );
  }


}
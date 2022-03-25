import 'package:automatic_timetable_manager/Screens/Authentication/enterEmail.dart';
import '../home.dart';
import 'enterEmail.dart';
import 'signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/api.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Api api = Api();
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
                              'Automatic Timetable \n Manager',
                              style: GoogleFonts.bebasNeue(
                                textStyle:TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screen.height*0.02),

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
                          SizedBox(height: screen.height*0.02),

                          //Forget Password Link
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => EnterEmail())
                              );
                            },
                            child: Text(
                              'Forget Password?',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          SizedBox(height: screen.height*0.01),

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

                          //Login Button
                          MaterialButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () async{
                              SharedPreferences localStorage = await SharedPreferences.getInstance();

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

                                api.postData('login', data).then((value) {
                                  print('hi3333');
                                  print(value);
                                  if(value['message']=='Bad creds'){
                                    setState(() {
                                      errorText='Bad Credentials!';
                                      error=true;
                                    });
                                  }else{
                                    localStorage.setInt('userID', value['user']['userID']);
                                    localStorage.setString('email', value['user']['email']);
                                    localStorage.setString('token', value['token']);
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => Home())
                                    );
                                    print('hi');
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
                                'Login',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screen.height*0.03),

                          //Login Illustration
                          Container(
                            height: screen.height*0.17,
                            child: Image.asset('assets/img/loginPic.png'),
                          ),
                        ]
                    ),
                  ),
                ],
              ),
              SizedBox(height: screen.height*0.03),

              //Redirection to Sign Up Page
              RichText(
                text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'New user? ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20
                          )
                      ),
                      TextSpan(
                          text: 'Register here!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: Color.fromRGBO(55, 147, 159, 1),
                              fontSize: 20
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = (){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Signup())
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Database/api.dart';
import '../../Shared/alertDialog.dart';

class ResetPassword extends StatefulWidget{
  final String email;
  ResetPassword({required this.email});
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  late bool errorConfirmPassword,errorPassword,isLoading;
  late String errorText;
  MyAlertDialog alertDialog = MyAlertDialog();
  Api api =Api();
  late bool viewPassword1,viewPassword2;

  @override
  void initState(){
    super.initState();
    errorText='';
    isLoading=false;
    errorConfirmPassword=false;
    errorPassword=false;
    viewPassword1 =true;
    viewPassword2=true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen= MediaQuery.of(context).size;

    return Scaffold(
        body:Stack(
          alignment: Alignment.center,
          children: [
            Hero(
              tag: 'background',
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.black,width: 2.0),
                  // borderRadius: BorderRadius.only(bottomLeft:Radius.circular(30),bottomRight:Radius.circular(30)),
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
                height: (screen.height),
              ),
            ),
            Positioned(
              top:50,
              left:10,
              child: Container(
                width: 30,
                child: MaterialButton(
                    padding: EdgeInsets.all(0),
                    onPressed:(){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios_outlined,size: 40,)
                ),
              ),
            ),

            Positioned(
              top:100,
              child: Column(
                children: [
                  Text(
                      'Reset Password',
                      style: GoogleFonts.bebasNeue(
                        textStyle:TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ),
                  //Old password
                  // SizedBox(height: 20),
                  // Container(
                  //   height: 60,
                  //   width: size.width*0.7,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(40.0),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.withOpacity(0.4),
                  //         spreadRadius: 1,
                  //         blurRadius: 7,
                  //         offset: Offset(0, 5), // changes position of shadow
                  //       ),
                  //     ],
                  //   ),
                  //   child: TextField(
                  //       controller: oldPasswordController,
                  //       obscureText: true,
                  //       decoration: InputDecoration(
                  //         hintText: 'Old Password',
                  //         hintStyle: TextStyle(
                  //           fontSize: 17,
                  //         ),
                  //         fillColor: Colors.white,
                  //         filled: true,
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(30),
                  //             borderSide: BorderSide.none
                  //         ),
                  //         contentPadding: EdgeInsets.all(20),
                  //       ),
                  //       cursorColor: Colors.black
                  //   ),
                  // ),
                  SizedBox(height: 20),
                  // Text(
                  //     'New Password',
                  //     style: GoogleFonts.oswald(
                  //       textStyle:TextStyle(
                  //           fontSize: 20
                  //       ),
                  //     )
                  // ),
                  SizedBox(height: 10),
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
                    child: Row(
                      children: [
                        Container(
                          width: screen.width*0.6,
                          child: TextField(
                              controller: newPasswordController,
                              obscureText: viewPassword1,
                              decoration: InputDecoration(
                                hintText: 'New Password',
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
                        Container(
                          width: screen.width*0.05,
                          child: MaterialButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: (){
                              setState(() {
                                viewPassword1=!viewPassword1;
                                print(!viewPassword1);

                              });

                            },
                            height: screen.height*0.03,
                            child: Container(
                              height: screen.height * 0.025,
                              width: screen.width*0.07,
                              child: viewPassword1?Image.asset('assets/img/eyeOffIcon.png'):Image.asset('assets/img/eyeOnIcon.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Text(
                  //     'Confirm Password',
                  //     style: GoogleFonts.oswald(
                  //       textStyle:TextStyle(
                  //         fontSize: 20,
                  //       ),
                  //     )
                  // ),
                  SizedBox(height: 10),
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
                    child: Row(
                      children: [
                        Container(
                          width: screen.width*0.6,
                          child: TextField(
                              obscureText: viewPassword2,
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                hintText: 'Confirm Password',
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
                        Container(
                          width: screen.width*0.05,
                          child: MaterialButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: (){
                              setState(() {
                                viewPassword2=!viewPassword2;
                                print(!viewPassword2);

                              });

                            },
                            height: screen.height*0.03,
                            child: Container(
                              height: screen.height * 0.025,
                              width: screen.width*0.07,
                              child: viewPassword2?Image.asset('assets/img/eyeOffIcon.png'):Image.asset('assets/img/eyeOnIcon.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: 50,
                      width: screen.width*0.7,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(0),
                      child: Text(
                        'Password must be at least 8 characters.',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                  ),
                  SizedBox(height: 10),
                  if(errorConfirmPassword||errorPassword)
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
                  SizedBox(height: 10),
                  MaterialButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      setState(() {
                        isLoading=true;
                      });
                      //check if field is filled
                      if(confirmPasswordController.text.isEmpty||newPasswordController.text.isEmpty){
                        setState(() {
                          errorText='Please fill in all sections!';
                          errorPassword=true;
                          isLoading=false;
                        });
                      }
                      //check if password meets condition
                      else if(!(newPasswordController.text.length >= 8)){
                        print('what');
                        setState(() {
                          errorText='Password must be at least 8 characters and not empty.';
                          errorPassword=true;
                          isLoading=false;
                        });
                      }
                      //check if password matched
                      else if(newPasswordController.text!=confirmPasswordController.text){
                        setState(() {
                          errorText='Password did not match';
                          errorConfirmPassword=true;
                          isLoading=false;
                        });
                      }
                      else{
                        setState(() {
                          errorPassword=false;
                          errorConfirmPassword=false;
                        });
                        var data = {
                          'newPassword': newPasswordController.text,
                          'email': widget.email,
                        };
                        print(data);
                        api.postData('forgetPassword', data).then((value) async{
                          setState(() {
                            isLoading=false;
                          });
                          print(value);
                          // alertDialog.showAlertDialog('Password Reset Success!','Your password had been reset!',context);

                          if(value['message']=='Old Password Entered!'){
                            alertDialog.showAlertDialog(value['message'],'Old Password Entered!',context);
                          }else{
                            alertDialog.showAlertDialog('Password Reset Success!','Your password had been reset!',context);
                          }
                        });
                      }
                      // Navigator.push(
                      //     context, MaterialPageRoute(builder: (context) => Otp())
                      // );
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
                        'Confirm',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: screen.height*0.2,
                    child: Image.asset('assets/img/resetPasswordPic.png'),
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}
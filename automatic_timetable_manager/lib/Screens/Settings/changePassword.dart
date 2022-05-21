import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/api.dart';
import '../../Shared/alertDialog.dart';
import '../../Shared/myBoxDecoration.dart';
import '../../Shared/myButton.dart';
import '../../Shared/myTextField.dart';

class ChangePassword extends StatefulWidget{
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  Api api = Api();
  MyButton button = MyButton();
  MyBoxDecoration boxDeco = MyBoxDecoration();
  MyTextField textField = MyTextField();
  MyAlertDialog alertDialog = MyAlertDialog();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  late bool errorConfirmPassword,errorFillChecker;
  late String errorText;
  late bool viewPassword1,viewPassword2,viewPassword3;

  // SharedPreferences localStorage = await SharedPreferences.getInstance();
  // var userID = localStorage.getInt('userID');

  @override
  void initState(){
    super.initState();
    errorText='';
    errorConfirmPassword=false;
    errorFillChecker=false;
    viewPassword1 =true;
    viewPassword2=true;
    viewPassword3=true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  myPasswordTextField(TextEditingController textController, String textFieldTitle, Widget button, bool obscureText, BuildContext context){
    Size screen= MediaQuery.of(context).size;
    return Container(
      height: screen.height*0.14,
      width: screen.width*0.9,
      decoration: boxDeco.myBoxDecoration(Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0,top:20),
                child: Text(
                  textFieldTitle,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54
                  ),
                ),
              ),
              Spacer(),
             button,
            ],
          ),
          TextField(
              controller: textController,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: 'Write Here...',
                hintStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black54
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
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    Size screen= MediaQuery.of(context).size;

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
                children:[
                  SizedBox(height: screen.height*0.05),
                  //Title and Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: screen.width*0.2),
                      Text(
                          'Change Password',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.bebasNeue(
                            textStyle: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                      ),

                      // SizedBox(width: screen.width*0.03),
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

                  //Old Email Address Input
                  SizedBox(height: screen.height*0.05),
                  myPasswordTextField(
                      oldPasswordController,
                      'Old Password',
                      MaterialButton(
                        padding: const EdgeInsets.only(top:15),
                        onPressed: (){
                          setState(() {
                            viewPassword1=!viewPassword1;
                          });
                          print(!viewPassword1);

                        },
                        height: screen.height*0.03,
                        child: Container(
                          height: screen.height * 0.025,
                          width: screen.width*0.1,
                          child: viewPassword1?Image.asset('assets/img/eyeOffIcon.png'):Image.asset('assets/img/eyeOnIcon.png'),
                        ),
                      ),
                      viewPassword1,
                      context
                  ),

                  //New Email Address Input
                  SizedBox(height: screen.height*0.03),
                  myPasswordTextField(
                      newPasswordController,
                      'New Password',
                      MaterialButton(
                        padding: const EdgeInsets.only(top:15),
                        onPressed: (){
                          setState(() {
                            viewPassword2=!viewPassword2;
                          });
                          print(!viewPassword2);

                        },
                        height: screen.height*0.03,
                        child: Container(
                          height: screen.height * 0.025,
                          width: screen.width*0.1,
                          child: viewPassword2?Image.asset('assets/img/eyeOffIcon.png'):Image.asset('assets/img/eyeOnIcon.png'),
                        ),
                      ),
                      viewPassword2,
                      context
                  ),

                  //Old Email Address Input
                  SizedBox(height: screen.height*0.03),
                  myPasswordTextField(
                      confirmPasswordController,
                      'Confirm Password',
                      MaterialButton(
                        padding: const EdgeInsets.only(top:15),
                        onPressed: (){
                          setState(() {
                            viewPassword3=!viewPassword3;
                          });
                          print(!viewPassword3);

                        },
                        height: screen.height*0.03,
                        child: Container(
                          height: screen.height * 0.025,
                          width: screen.width*0.1,
                          child: viewPassword3?Image.asset('assets/img/eyeOffIcon.png'):Image.asset('assets/img/eyeOnIcon.png'),
                        ),
                      ),
                      viewPassword3,
                      context
                  ),

                  SizedBox(height: screen.height*0.03),
                  Container(
                      height: screen.height*0.03,
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

                  SizedBox(height: screen.height*0.02),
                  //Error Message
                  if(errorFillChecker||errorConfirmPassword)
                    Container(
                        alignment: Alignment.center,
                        height: screen.height*0.05,
                        width: screen.width*0.7,
                        child: Text(
                          errorText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),

                  SizedBox(height: screen.height*0.02),
                  //Save Button
                  MaterialButton(
                    onPressed: () async {
                      SharedPreferences localStorage = await SharedPreferences.getInstance();
                      var userID = localStorage.getInt('userID');
                      if(oldPasswordController.text.isEmpty||newPasswordController.text.isEmpty||confirmPasswordController.text.isEmpty){
                        setState(() {
                          errorText='Please fill in all sections!';
                          errorFillChecker=true;
                        });
                      }
                      //check if password meets condition
                      else if(newPasswordController.text.length <8||oldPasswordController.text.length < 8){
                        print('what');
                        setState(() {
                          errorText='Password must be at least 8 characters and not empty.';
                          errorConfirmPassword=true;
                        });
                      }
                      else if(newPasswordController.text!=confirmPasswordController.text){
                        setState(() {
                          errorText='Password did not match';
                          errorConfirmPassword=true;
                        });
                      }else{
                        setState(() {
                          errorConfirmPassword=false;
                          errorFillChecker=false;

                          Map data={
                            'oldPassword':oldPasswordController.text,
                            'newPassword':newPasswordController.text,
                            'userID':userID
                          };
                          print(data);

                          api.postData('changePassword', data).then((value) async{
                            print(value);

                            if(value['message']=='Wrong Old Password!'){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(value['message']),
                                      content: Text('You entered a wrong old password !'),
                                      actions: [
                                        MaterialButton(
                                          child: Text("OK"),
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  }
                              );
                            }
                            else{
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Password Successfully Changed!'),
                                      content: Text('Your password had been changed!'),
                                      actions: [
                                        MaterialButton(
                                          child: Text("OK"),
                                          onPressed: (){
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  }
                              );

                            }
                          });

                        });
                      }
                    },
                    child: button.myShortIconButton(
                        'Save',
                        30,
                        Color.fromRGBO(55, 147, 159, 1),
                        'assets/img/forwardButton.png',
                        context
                    ),
                  ),
                  // Container(
                  //   decoration: boxDeco.myBoxDecoration(Color.fromRGBO(127, 235, 249, 1)),
                  //   height: (screen.height*0.5),
                  //   width: (screen.width*0.9),
                  //   child: Column(
                  //     children: [
                  //       SizedBox(height: screen.height*0.03),
                  //
                  //     ],
                  //   ),
                  // ),
                ]
            ),
          ),
        ),
      ),
    );
  }

}
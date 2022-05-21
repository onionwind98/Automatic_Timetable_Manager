import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/api.dart';
import '../../Shared/alertDialog.dart';
import '../../Shared/myBoxDecoration.dart';
import '../../Shared/myButton.dart';
import '../../Shared/myTextField.dart';

class ChangeEmail extends StatefulWidget{
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  Api api = Api();
  MyButton button = MyButton();
  MyBoxDecoration boxDeco = MyBoxDecoration();
  MyTextField textField = MyTextField();
  MyAlertDialog alertDialog = MyAlertDialog();

  // TextEditingController oldEmailController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();
  late bool errorConfirmEmail,errorFillChecker;
  late String errorText;



  @override
  void initState(){
    super.initState();
    errorText='';
    errorConfirmEmail=false;
    errorFillChecker=false;  }

  @override
  void dispose() {
    super.dispose();
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
                        'Change \n Email Address',
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

                // //Old Email Address Input
                // SizedBox(height: screen.height*0.05),
                // textField.myTextField(oldEmailController, 'Old Email', screen.height*0.14, screen.width*0.9, context),

                //New Email Address Input
                SizedBox(height: screen.height*0.03),
                textField.myTextField(newEmailController, 'New Email', screen.height*0.14, screen.width*0.9, context),

                //Old Email Address Input
                SizedBox(height: screen.height*0.03),
                textField.myTextField(confirmEmailController, 'Confirm Email', screen.height*0.14, screen.width*0.9, context),

                SizedBox(height: screen.height*0.03),
                //Error Message
                if(errorFillChecker||errorConfirmEmail)
                  Container(
                      alignment: Alignment.center,
                      height: screen.height*0.07,
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

                //Save Button
                SizedBox(height: screen.height*0.02),
                MaterialButton(
                  onPressed: ()async{
                    SharedPreferences localStorage = await SharedPreferences.getInstance();
                    var userID = localStorage.getInt('userID');
                    var emailFormat = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                    // bool oldEmailValid = RegExp(emailFormat).hasMatch(oldEmailController.text);
                    bool newEmailValid = RegExp(emailFormat).hasMatch(newEmailController.text);
                    bool confirmEmailValid = RegExp(emailFormat).hasMatch(confirmEmailController.text);


                    if(newEmailController.text.isEmpty||confirmEmailController.text.isEmpty){
                      setState(() {
                        errorText='Please fill in all sections!';
                        errorFillChecker=true;
                      });
                    }
                    else if(!newEmailValid||!confirmEmailValid){
                      setState(() {
                        errorText='Please enter a valid email address format!';
                        errorFillChecker=true;
                      });
                    }
                    else if(newEmailController.text!=confirmEmailController.text){
                      setState(() {
                        errorText='Password did not match';
                        errorConfirmEmail=true;
                      });
                    }else{
                      setState(()  {
                        errorConfirmEmail=false;
                        errorFillChecker=false;

                        Map data={
                          'userID':userID,
                          'newEmail':newEmailController.text
                        };
                        print(data);

                        api.postData('changeEmail', data).then((value) async{
                          print(value);
                          // alertDialog.showAlertDialog('Password Reset Success!','Your password had been reset!',context);

                          if(value['message']=='Email Not Available!'){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(value['message']),
                                  content: Text('You entered a used Email! \n Try another valid email address.'),
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
                          // else if(value['message']=='Old Email Not In Database!'){
                          //   showDialog(
                          //       context: context,
                          //       builder: (BuildContext context) {
                          //         return AlertDialog(
                          //           title: Text(value['message']),
                          //           content: Text('Try another valid email address.'),
                          //           actions: [
                          //             MaterialButton(
                          //               child: Text("OK"),
                          //               onPressed: (){
                          //                 Navigator.pop(context);
                          //               },
                          //             ),
                          //           ],
                          //         );
                          //       }
                          //   );
                          // }
                          else{
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Email Successfully Changed!'),
                                    content: Text('Your email address had been changed!'),
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
                            // alertDialog.showAlertDialog('Email Successfully Changed!','Your email address had been changed!',context);
                            // Navigator.pop(context);

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
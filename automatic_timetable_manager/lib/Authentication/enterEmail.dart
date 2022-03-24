import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterEmail extends StatefulWidget{
  @override
  _EnterEmailState createState() => _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail> {
  TextEditingController emailController = TextEditingController();
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
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(127, 235, 249, 1),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: size.height*0.05,
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
            top:size.height*0.15,
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
                  'Enter Phone Number to reset Password',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 60,
                  width: size.width*0.7,
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
                      height: size.height*0.05,
                      width: size.width*0.7,
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
                    // Map data = {
                    //   'email': emailController.text
                    // };
                    // if(emailController.text.isEmpty){
                    //   setState(() {
                    //     errorText='Please fill in the email address!';
                    //     error=true;
                    //   });
                    // }else{
                    //   error=false;
                    //   if(widget.destination=='resetPW'){
                    //     api.postData('checkPhoneNumber', data).then((value) {
                    //       if(value['message']=='Invalid Phone Number'){
                    //         alertDialog.showAlertDialog('Invalid Phone Number','Please enter a valid Phone Number to reset the password.',context);
                    //       }else{
                    //         print(value);
                    //         Navigator.push(
                    //             context, MaterialPageRoute(builder: (context) => ForgetPassword(phoneNumber: phoneNumberController.text,))
                    //         );
                    //       }
                    //     });
                    //   }
                    //   else if(widget.destination=='register'){
                    //     Navigator.push(
                    //         context, MaterialPageRoute(builder: (context) => registerOTP(phoneNumber: phoneNumberController.text))
                    //     );
                    //   }
                    //
                    // }

                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: size.width*0.7,
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
                  height: size.height*0.4,
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
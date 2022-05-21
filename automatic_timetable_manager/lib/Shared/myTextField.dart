
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'myBoxDecoration.dart';

class MyTextField {
  MyBoxDecoration boxDeco = MyBoxDecoration();

  myTextField(TextEditingController textController, String textFieldTitle, double height, double width, BuildContext context){

    return Container(
      height: height,
      width: width,
      decoration: boxDeco.myBoxDecoration(Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          TextField(
              controller: textController,
              minLines: 1,
              maxLines: 5,
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

  myPasswordTextField(TextEditingController textController, String textFieldTitle, double height, double width, BuildContext context){
    Size screen= MediaQuery.of(context).size;
    bool viewPassword =false;
    return Container(
      height: height,
      width: width,
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
              MaterialButton(
                padding: const EdgeInsets.only(top:15),
                onPressed: (){
                  viewPassword=!viewPassword;
                },
                height: screen.height*0.03,
                child: Container(
                  height: screen.height * 0.025,
                  width: screen.width*0.1,
                  child: viewPassword?Image.asset('assets/img/eyeOffIcon.png'):Image.asset('assets/img/eyeOnIcon.png'),
                ),
              )
            ],
          ),
          TextField(
              controller: textController,
              obscureText: true,
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

}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton {
  myLongButton(String buttonTitle, Color buttonColor, BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      height: screen.height*0.08,
      width: screen.width * 0.9,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.black,width: 3.0),
        color: buttonColor,
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
        buttonTitle,
        style: GoogleFonts.bebasNeue(
          textStyle: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        )
      ),
    );
  }

  myShortIconButton(String buttonTitle, double fontSize, Color buttonColor, String icon, BuildContext context){
    Size screen = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      height: screen.height * 0.08,
      width: screen.width * 0.45,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.black,width: 3.0),
        color: buttonColor,
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
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0,top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.bebasNeue(
                textStyle:TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              )
            ),
            Container(
              height: screen.height * 0.15,
              child: Image.asset(icon),
            ),
          ],
        ),
      ),
    );
  }

  mySmallButton(String buttonTitle, Color buttonColor, BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      height: 40,
      width: screen.width * 0.4,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.black,width: 3.0),
        color: buttonColor,
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
          buttonTitle,
          style: GoogleFonts.bebasNeue(
            textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          )
      ),
    );
  }
}
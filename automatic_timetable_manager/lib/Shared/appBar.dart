import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar {
  defaultAppBar(String pageTitle, BuildContext context){
    Size screen = MediaQuery.of(context).size;
    return PreferredSize(
      preferredSize: Size.fromHeight(70.0),
      child: AppBar(
        backgroundColor:  Color.fromRGBO(127, 235, 249, 1),
        leading:  Padding(
          padding: EdgeInsets.only(top:20),
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
          padding: EdgeInsets.only(top: 20),
          child: Text(
              pageTitle,
              style: GoogleFonts.bebasNeue(
                textStyle: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
    );
  }

}
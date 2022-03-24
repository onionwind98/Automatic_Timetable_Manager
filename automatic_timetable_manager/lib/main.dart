// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

import 'Authentication/login.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget{

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    // _checkIfLoggedIn();
    super.initState();
  }
  // void _checkIfLoggedIn() async{
  //   // check if token is there
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var token = localStorage.getString('token');
  //   print(token.toString());
  //   if(token!= null){
  //     setState(() {
  //       _isLoggedIn = true;
  //     });
  //   }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _isLoggedIn ? Home() :  Login(),
      ),

    );
  }

}



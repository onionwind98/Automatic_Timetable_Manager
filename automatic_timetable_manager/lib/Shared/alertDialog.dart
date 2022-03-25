import 'package:flutter/material.dart';

import '../Screens/Authentication/login.dart';

class MyAlertDialog {

  showAlertDialog(String title, String content, BuildContext context) {
    // set up the button
    Widget okButton = MaterialButton(
      child: Text("OK"),
      onPressed: () {
        if(title=='Password Reset Success!'||title=='Account Registered!'){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login())
          );
        }else{
          Navigator.pop(context);
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
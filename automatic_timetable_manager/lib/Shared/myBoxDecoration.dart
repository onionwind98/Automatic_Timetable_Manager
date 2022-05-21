import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyBoxDecoration {
  myBoxDecoration(Color color){
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(40.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(0, 5), // changes position of shadow
        ),
      ],
    );
  }

  timetableDeco(Color color){
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(0, 5), // changes position of shadow
        ),
      ],
    );
  }
}
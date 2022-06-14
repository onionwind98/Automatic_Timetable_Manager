
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:automatic_timetable_manager/Shared/myBoxDecoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SortFunction {
  MyBoxDecoration boxDeco = MyBoxDecoration();

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> dropdownMenuItems = [
      DropdownMenuItem(
          child: Row(
            children:  [
              Text("Sort By: Title"),
              Icon(Icons.arrow_downward_rounded,size: 30,color: Colors.white)
            ],
          ),
          value: "TitleAscending"
      ),
      DropdownMenuItem(
          child: Row(
            children:  [
              Text("Sort By: Title"),
              Icon(Icons.arrow_upward_rounded,size: 30,color: Colors.white)
            ],
          ),
          value: "TitleDescending"
      ),
      DropdownMenuItem(
          child: Row(
            children:  [
              Text("Sort By: \n Priority Level",style: TextStyle(fontSize: 22),textAlign: TextAlign.center),
              Icon(Icons.arrow_downward_rounded,size: 30,color: Colors.white)
            ],
          ),
          value: "PriorityAscending"
      ),
      DropdownMenuItem(
          child: Row(
            children:  [
              Text("Sort By: \n Priority Level",style: TextStyle(fontSize: 22),textAlign: TextAlign.center),
              Icon(Icons.arrow_upward_rounded,size: 30,color: Colors.white)
            ],
          ),
          value: "PriorityDescending"
      ),
    ];
    return dropdownMenuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItemsOngoingHistory{
    List<DropdownMenuItem<String>> dropdownMenuItems = [
      DropdownMenuItem(
          child: Row(
            children:  [
              Text("Sort By: Title"),
              Icon(Icons.arrow_downward_rounded,size: 30,color: Colors.white)
            ],
          ),
          value: "TitleAscending"
      ),
      DropdownMenuItem(
          child: Row(
            children:  [
              Text("Sort By: Title"),
              Icon(Icons.arrow_upward_rounded,size: 30,color: Colors.white)
            ],
          ),
          value: "TitleDescending"
      ),
      DropdownMenuItem(
          child: Row(
            children:  [
              Text("Sort By: Date"),
              Icon(Icons.arrow_downward_rounded,size: 30,color: Colors.white)
            ],
          ),
          value: "DateAscending"
      ),
      DropdownMenuItem(
          child: Row(
            children:  [
              Text("Sort By: Date"),
              Icon(Icons.arrow_upward_rounded,size: 30,color: Colors.white)
            ],
          ),
          value: "DateDescending"
      ),
    ];
    return dropdownMenuItems;
  }


  sortFunction(List sortingList, String sortOption){
    switch(sortOption){
      case 'TitleAscending':
        sortingList.sort(
          (a,b) => a['title'].toLowerCase().compareTo(b['title'].toLowerCase())
        );
        break;
      case 'TitleDescending':
        sortingList.sort(
          (b,a) => a['title'].toLowerCase().compareTo(b['title'].toLowerCase())
        );
        break;
      case 'PriorityAscending':
        sortingList.sort(
          (a,b) => a['priorityLevel'].compareTo(b['priorityLevel'])
        );
        break;
      case 'PriorityDescending':
        sortingList.sort(
          (b,a) => a['priorityLevel'].compareTo(b['priorityLevel'])
        );
        break;
      case 'DateAscending':
        sortingList.sort(
                (a,b) => DateTime.parse(a['assignedDate']).compareTo(DateTime.parse(b['assignedDate']))
        );
        break;
      case 'DateDescending':
        sortingList.sort(
                (b,a) => DateTime.parse(a['assignedDate']).compareTo(DateTime.parse(b['assignedDate']))
        );
        break;
    }

    return sortingList;
  }
}
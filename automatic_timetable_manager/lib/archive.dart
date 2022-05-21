//STREAMBUILDER LISTVIEW
// StreamBuilder<dynamic> (
//   stream: _streamController.stream,
//   builder: (context,snapshot){
//     if(snapshot.hasData){
//       return ListView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         padding: EdgeInsets.all(0),
//         itemCount: snapshot.data.length,
//         itemBuilder: (context,index){
//
//           return Column(
//             children: [
//               Slidable(
//
//                 //Slide to delete
//                 key: const ValueKey(0),
//                 endActionPane: ActionPane(
//                   extentRatio:0.25,
//                   motion: const ScrollMotion(),
//                   children:  [
//                     // A SlidableAction can have an icon and/or a label.
//                     SlidableAction(
//                         backgroundColor: Color(0xFFFE4A49),
//                         foregroundColor: Colors.white,
//                         icon: Icons.delete,
//                         label: 'Delete',
//                         onPressed: (BuildContext context){
//                           deleteTask(snapshot.data[index]['taskID']);
//
//                         }
//                     ),
//                   ],
//                 ),
//
//                 //List view item
//                 child: Container(
//                   alignment: Alignment.center,
//                   height: screen.height * 0.1,
//                   width: screen.width * 0.9,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(30.0),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.4),
//                         spreadRadius: 1,
//                         blurRadius: 7,
//                         offset: Offset(0, 5), // changes position of shadow
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 20.0,top:10),
//
//                     //Items in List view item
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               snapshot.data[index]['title'],
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                     fontSize: 25,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black
//                                 ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(0),
//                               child: Text(
//                                 'Priority Level:'+snapshot.data[index]['priorityLevel'].toString(),
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black
//                                   ),
//                               ),
//                             ),
//                           ],
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: screen.height*0.015),
//
//             ],
//           );
//         },
//       );
//     }
//
//     else if (snapshot.connectionState != ConnectionState.done) {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//
//     else {
//       return Text(snapshot.error.toString());
//     }
//   },
//
// ),


//Custom Time Picker
// Start time
// Container(
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(40.0),
//   ),
//   width: screen.width*0.18,
//   child: showPreferredTimeSlider(startHourController,hour)
// ),
// Text(
//   ':',
//   style: TextStyle(
//     color: Colors.black,
//     fontSize: 20,
//     fontWeight: FontWeight.bold
//   ),
// ),
// Container(
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(40.0),
//   ),
//   width: screen.width*0.18,
//   child: showPreferredTimeSlider(startMinuteController,minute)
// ),
//
// //Dash
// Container(
//   height: 5,
//   width: 20,
//   decoration: BoxDecoration(
//     color: Colors.black38,
//     borderRadius: BorderRadius.circular(40.0),
//   ),
// ),
//
// //End Time
// Container(
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(40.0),
//   ),
//   width: screen.width*0.18,
//   child: showPreferredTimeSlider(endHourController,hour)
// ),
// Text(
//   ':',
//   style: TextStyle(
//       color: Colors.black,
//       fontSize: 20,
//       fontWeight: FontWeight.bold
//   ),
// ),
// Container(
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(40.0),
//   ),
//   width: screen.width*0.18,
//   child: showPreferredTimeSlider(endMinuteController,minute)
// ),


// _scrollController1 = ScrollController();
// _scrollController2 = ScrollController();
//
// _scrollController1.addListener(() {
//   _scrollController2.animateTo(
//       _scrollController1.offset,
//       duration: Duration(microseconds: 100),
//       curve: Curves.easeIn
//   );
// });
//
// _scrollController2.addListener(() {
//   _scrollController1.animateTo(
//       _scrollController2.offset,
//       duration: Duration(microseconds: 100),
//       curve: Curves.easeIn
//   );
// });

// Row(
//   children: [
//     GestureDetector(
//       onTap: (){
//         Navigator.pop(context);
//       },
//       child: Container(
//         height: screen.height*0.17,
//         child: Image.asset('assets/img/backButton.png'),
//       ),
//     ),
//     SizedBox(width: 30,),
//     Text(
//         'Settings',
//         style: GoogleFonts.bebasNeue(
//           textStyle:TextStyle(
//               fontSize: 50,
//               fontWeight: FontWeight.bold,
//               color: Colors.white
//           ),
//         )
//     ),
//     SizedBox(width: 40,),
//     Container(
//       width: 50,
//       child: MaterialButton(
//         padding: EdgeInsets.all(0),
//         onPressed: () async{
//           await api.getData('logout').then((value) async {
//             print(value);
//             if(value['message']=='Logged out'){
//               print('hilogout');
//               SharedPreferences localStorage = await SharedPreferences.getInstance();
//               localStorage.remove('user');
//               localStorage.remove('token');
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => Login()));
//             }
//           });
//
//         },
//         child: Icon(Icons.logout,size: 50,color: Colors.white,),
//
//       ),
//     ),
//
//   ],
// ),


// return AlertDialog(
//   shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.all(Radius.circular(32.0))
//   ),
//   backgroundColor: Color.fromRGBO(55, 147, 159, 1),
//   actionsAlignment:MainAxisAlignment.center,
//   title: Text(
//     "Choose a week to reschedule the timetable with the task selected.",
//     textAlign: TextAlign.center,
//     style: TextStyle(
//       fontSize: 25,
//       color: Colors.white
//     ),
//   ),
//   content: StatefulBuilder(
//     builder: (BuildContext context, StateSetter setState){
//       return WeekPicker(
//         selectedDate: selectedDate['startDate'],
//         onChanged: (DatePeriod newPeriod){
//           setState(() {
//             print(newPeriod.start);
//             selectedDate['startDate'] = newPeriod.start;
//             selectedDate['endDate'] = newPeriod.end;
//             // _selectedPeriod = newPeriod;
//           });
//         },
//         firstDate: firstDate,
//         lastDate: lastDate,
//         datePickerStyles: DatePickerRangeStyles(
//           defaultDateTextStyle:TextStyle(
//             color: Colors.white
//           ),
//           displayedPeriodTitle:TextStyle(
//               color: Colors.white
//           ),
//           currentDateStyle:TextStyle(
//               color: Colors.white
//           ),
//           dayHeaderStyle: DayHeaderStyle(
//             textStyle: TextStyle(
//               color: Colors.white
//             )
//           )
//         ),
//         datePickerLayoutSettings: DatePickerLayoutSettings(
//           scrollPhysics: NeverScrollableScrollPhysics(),
//           showPrevMonthEnd: true,
//           showNextMonthStart: true,
//         ),
//       );
//     }
//   ),
//   actions: [
//     MaterialButton(
//       child: button.myAlertActionButton('Confirm Week', Colors.white, Colors.black, context),
//
//     onPressed: () async {
//         // print(selectedDate['startDate'].toString()+selectedDate['endDate'].toString());
//       selectedTask.clear();
//       for(int i=0; i < unassignedTaskList.length; i++){
//         if(unassignedTaskList[i]['selectedStatus']){
//           selectedTask.add(unassignedTaskList[i]);
//         }
//       }
//       selectedTask=sortFunction.sortFunction(selectedTask, 'PriorityDescending');
//       print(selectedTask);
//
//
//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       var userID = localStorage.getInt('userID');
//       var startDate = selectedDate['startDate'].toString().split(" ");
//       var endDate = selectedDate['endDate'].toString().split(" ");
//       print(startDate);
//
//       Map data = {
//         'userID':userID,
//         'taskList':selectedTask,
//         'selectedStartDate':startDate[0],
//         'selectedEndDate':endDate[0]
//       };
//
//       api.postData('rescheduleTimetable', data).then((value) {
//         print('response: '+value.toString());
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text("Timetable Rescheduled!"),
//                 content: Text("The selected week had been rescheduled!"),
//                 actions: [
//                   MaterialButton(
//                     child: Text('OK'),
//                     onPressed: (){
//                       Navigator.pop(context);
//                       Navigator.pop(context);
//                       loadTask();
//                     },
//                   ),
//                 ],
//               );
//             }
//         );
//       });
//       },
//     ),
//   ],
// );
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
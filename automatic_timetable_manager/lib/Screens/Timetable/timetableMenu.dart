import 'package:automatic_timetable_manager/Screens/Timetable/dailyTimetable.dart';
import 'package:automatic_timetable_manager/Screens/Timetable/weeklyTimetable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimetableMenu extends StatefulWidget {
  int tabSelector;
  TimetableMenu({Key? key, required this.tabSelector}) : super(key: key);

  @override
  _TimetableMenuState createState() => _TimetableMenuState();
}

class _TimetableMenuState extends State<TimetableMenu> {

  final tabs = [
    DailyTimetable( day: DateTime.now()),
    WeeklyTimetable()
  ];

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return DefaultTabController(
      initialIndex: widget.tabSelector,
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: AppBar(
            backgroundColor:  Color.fromRGBO(127, 235, 249, 1),
            bottom: TabBar(
              tabs: const [
                Tab(child: Text('Daily',style: TextStyle(fontSize: 20))),
                Tab(child: Text('Weekly',style: TextStyle(fontSize: 20))),
              ],
            ),
            leading:  Padding(
              padding: EdgeInsets.only(top:15),
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
              padding: EdgeInsets.only(top: 15),
              child: Text(
                  'Timetable',
                  style: GoogleFonts.bebasNeue(
                    textStyle: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: tabs,
        ),
      ),
    );
  }

}
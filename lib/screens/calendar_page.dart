// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/constants.dart';
import 'package:to_do_list_nhatnam/data/local_database.dart';

class CalendarPage extends StatefulWidget {
  // int indexKey;
  // Box<ToDoDataBase> box;
  // CalendarPage({required this.indexKey, required this.box})

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Box<ToDoDataBase> myBox = Hive.box<ToDoDataBase>('myBox');
  Box<ToDoDataBase> myBoxP = Hive.box<ToDoDataBase>('myBoxP');
  Box<ToDoDataBase> myBoxF = Hive.box<ToDoDataBase>('myBoxF');
  final myTopic = Hive.box('topicColor');

  PageController _calendarController = PageController();
  List<DateTime> _markedDates = [];
  DateTime _selectedDate = DateTime.now();
  // void _onDaySelected(DateTime day, List events, List holidays) {
  //   setState(() {
  //     _selectedDate = day;
  //     _updateMarkedDates(day);
  //   });
  // }

  // void _updateMarkedDates(DateTime selectedDate) {
  //   _markedDates.clear();
  //   for (var task in _tasks) {
  //     if (task.taskDate.year == selectedDate.year &&
  //         task.taskDate.month == selectedDate.month &&
  //         task.taskDate.day == selectedDate.day) {
  //       _markedDates.add(task.taskDate);
  //     }
  //   }
  // }

  List<Widget> _buildEventMarkers(DateTime date) {
    List<Widget> markers = [];
    for (var markedDate in _markedDates) {
      if (date.year == markedDate.year &&
          date.month == markedDate.month &&
          date.day == markedDate.day) {
        markers.add(
          Positioned(
            bottom: 2,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    double? width = MediaQuery.of(context).size.width;
    double? height = MediaQuery.of(context).size.height;

    return Container(
      color: listColor[myTopic.get('index')][0],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            //change topic
            backgroundColor: listColor[myTopic.get('index')][0],
            elevation: 0,
            centerTitle: true,
            title: Text(
              'LỊCH HÔM NAY',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: AssetImage('lib/assets/images/andrew1.jpeg'),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2013, 1, 1),
                    lastDay: DateTime.utc(2034, 1, 1),
                    focusedDay: DateTime.now(),
                    //daysOfWeekStyle is sun, mon, tue,...
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        // color: Colors.green.shade700,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      weekendStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      //Các ngày từ thứ 7 và chủ nhật và các ngày của tháng trước và tháng sau
                      defaultTextStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      //Là ngày thứ 7 hoặc chủ nhật của các tuần
                      weekendTextStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      //outside là ngày của tháng trước hoặc tháng sau đó
                      outsideTextStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      // isTodayHighlighted: true,
                      //Màu của ngày tạo task, today, là màu trùng với màu của theme
                      todayTextStyle: TextStyle(
                          color: listColor[myTopic.get('index')][0],
                          fontSize: 17,
                          fontWeight: FontWeight.w900),
                      todayDecoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                      selectedDecoration: BoxDecoration(
                        // color: Color(0XFF4DA8A3),
                        color: kMainOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    //Tháng và năm đang hiển thị

                    headerVisible: true,

                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 75, 75, 75)),
                      leftChevronIcon: Icon(
                        Icons.arrow_left,
                        color: Colors.grey,
                        size: 32,
                      ),
                      rightChevronIcon: Icon(
                        Icons.arrow_right,
                        color: Colors.grey,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                //reset all boxes
                // GestureDetector(
                //   child: Text('reset all boxes'),
                //   onTap: () {
                //     myBox.clear();
                //     myBoxP.clear();
                //     myBoxF.clear();
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

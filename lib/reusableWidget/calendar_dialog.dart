// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:to_do_list_nhatnam/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_nhatnam/data/local_database.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/screens/task_detail_page.dart';
import 'package:to_do_list_nhatnam/screens/task_page.dart';
import 'package:to_do_list_nhatnam/services/data_to_everywhere.dart';
import 'package:provider/provider.dart';

class CalendarDialogBox extends StatefulWidget {
  // const CalendarDialogBox({super.key});
  int indexKey;
  // final void Function(String)? updateTaskDate;
  String taskName;
  Box<ToDoDataBase> box;
  CalendarDialogBox({
    required this.indexKey,
    required this.taskName,
    required this.box,
    // this.updateTaskDate,
  });
  @override
  State<CalendarDialogBox> createState() => _CalendarDialogBoxState();
}

class _CalendarDialogBoxState extends State<CalendarDialogBox> {
  DateTime initDate = DateTime.now();
  DateTime? selectedDay; // Thêm biến selectedDay kiểu DateTime?
  DateTime now = DateTime.now();
  Box<ToDoDataBase> myBox = Hive.box<ToDoDataBase>('myBox');
  Box<ToDoDataBase> myBoxP = Hive.box<ToDoDataBase>('myBoxP');
  Box<ToDoDataBase> myBoxF = Hive.box<ToDoDataBase>('myBoxF');
  final myTopic = Hive.box('topicColor');

  bool select0 = false;
  bool select1 = false;
  bool select2 = false;
  bool select3 = false;
  @override
  void initState() {
    super.initState();
    String? taskDate = widget.box.get(widget.indexKey)?.taskDate;
    initDate = taskDate != null
        ? DateFormat('dd/MM/yyyy').parse(taskDate)
        : DateTime.now();
    selectedDay = initDate;
    print('init dialog calendar');
  }

  void startSelectDay() {
    if (myBox.get(widget.indexKey)!.isNow == true &&
        select1 == false &&
        select2 == false &&
        select3 == false) {
      select0 = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // DateTime initDate = DateFormat('dd/MM/yyyy')
    //     .parse(widget.box.get(widget.indexKey)!.taskDate ?? '');
    startSelectDay();

    return AlertDialog(
      //Không dùng được BorderRadius của Container trong content của AlertDialog
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Đặt giá trị bo tròn ở đây
      ),
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.white,
      content: Container(
        height: height * 70 / 100,
        child: Column(
          children: [
            //Calendar
            Container(
              color: Colors.white,
              height: (height * 80 / 100) * 60 / 100,
              width: width - 50,
              child: Column(children: [
                TableCalendar(
                  locale: 'vi_VN',
                  firstDay: DateTime.utc(2013, 1, 1),
                  lastDay: DateTime.utc(2034, 1, 1),
                  focusedDay: selectedDay ?? initDate,
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDay ?? initDate, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      this.selectedDay = selectedDay;
                    });
                  },
                  //daysOfWeekStyle is sun, mon, tue,...
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      // color: Colors.green.shade700,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    weekendStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    //Các ngày từ thứ 7 và chủ nhật và các ngày của tháng trước và tháng sau
                    defaultTextStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    //Là ngày thứ 7 hoặc chủ nhật của các tuần
                    weekendTextStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    //outside là ngày của tháng trước hoặc tháng sau đó
                    outsideTextStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    // isTodayHighlighted: true,
                    //Màu của ngày tạo task, today, là màu trùng với màu của theme
                    todayTextStyle: TextStyle(
                        // color: Color(0XFF35928D),
                        //change topic
                        color: listColor[myTopic.get('index')][0],
                        fontSize: 14,
                        fontWeight: FontWeight.w800),
                    todayDecoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                    selectedDecoration: BoxDecoration(
                      //change topic
                      color: listColor[myTopic.get('index')][0],
                      shape: BoxShape.circle,
                    ),
                  ),
                  //Tháng và năm đang hiển thị
                  headerVisible: true,
                  headerStyle: HeaderStyle(
                    titleTextFormatter: (
                      DateTime date,
                      dynamic locale,
                    ) {
                      final month = DateFormat.MMMM(locale).format(date);
                      final year = DateFormat.y(locale).format(date);
                      final formattedMonth =
                          month.toUpperCase(); // Convert to uppercase
                      return '$formattedMonth $year';
                    },
                    titleTextStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 75, 75, 75)),
                    formatButtonVisible: false,
                    titleCentered: true,
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
              ]),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      OptionDay(
                        nameOptionDay: 'Hôm nay',
                        isTakeFocusColor: select0,
                        onTap: () {
                          setState(() {
                            selectedDay = DateTime.now();
                            select0 = true;
                            select1 = false;
                            select2 = false;
                            select3 = false;
                          });
                        },
                      ),
                      OptionDay(
                        isTakeFocusColor: select1,
                        nameOptionDay: 'Ngày mai',
                        onTap: () {
                          setState(() {
                            selectedDay = DateTime.now().add(Duration(days: 1));
                            select0 = false;
                            select1 = true;
                            select2 = false;
                            select3 = false;
                          });
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      OptionDay(
                        isTakeFocusColor: select2,
                        nameOptionDay: '3 ngày sau',
                        onTap: () {
                          setState(() {
                            selectedDay = DateTime.now().add(Duration(days: 3));
                            select0 = false;
                            select1 = false;
                            select2 = true;
                            select3 = false;
                          });
                        },
                      ),
                      OptionDay(
                        isTakeFocusColor: select3,
                        nameOptionDay: 'Chủ nhật này',
                        onTap: () {
                          setState(() {
                            selectedDay = getUpcomingSunday();
                            select0 = false;
                            select1 = false;
                            select2 = false;
                            select3 = true;
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(right: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'HỦY',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            // color: kHuyGreenLight,
                            color: listColor[myTopic.get('index')][3],
                          ),
                        )),
                    TextButton(
                        onPressed: () {
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(selectedDay!);
                          DateTime selectedOnlyDate = DateTime(
                              selectedDay!.year,
                              selectedDay!.month,
                              selectedDay!.day);
                          DateTime nowOnlyDate =
                              DateTime(now.year, now.month, now.day);

                          if (selectedDay != null) {
                            //NGÀY CHỌN LÀ NGÀY KHÁC VỀ QUÁ KHỨ
                            if (selectedOnlyDate.isBefore(nowOnlyDate)) {
                              // Provider.of<WantTakeDataFrDetail>(context,
                              //         listen: false)
                              //     .setActionDone(true);
                              // Provider.of<DelCurrentTaskAndReplaceByNextTask>(
                              //         context,
                              //         listen: false)
                              //     .setActionDone(true);
                              //THÊM TASK ĐANG CHỈNH SỬA VÀO BOX PAST
                              if (widget.box.get(widget.indexKey)!.isPast! ==
                                  true) {
                                widget.box.get(widget.indexKey)!.taskDate =
                                    formattedDate;
                                widget.box.put(widget.indexKey,
                                    widget.box.get(widget.indexKey)!);
                                Navigator.pop(context);
                              } else {
                                widget.box.get(widget.indexKey)!.isNow = false;
                                widget.box.get(widget.indexKey)!.isPast = true;
                                widget.box.get(widget.indexKey)!.isFuture =
                                    false;
                                // key
                                int newTaskKey = (myBoxP.length > 0)
                                    ? myBoxP.keyAt(myBoxP.length - 1) + 1
                                    : 0;
                                //add new task
                                ToDoDataBase newTask = ToDoDataBase(
                                  //taskName để nhận controller hiện tại từ trang edit
                                  taskName: widget.taskName,
                                  isCompleted: false,
                                  taskDate: formattedDate,
                                  taskTime:
                                      widget.box.get(widget.indexKey)!.taskTime,
                                  index: newTaskKey,
                                  flgTime:
                                      widget.box.get(widget.indexKey)!.flgTime,
                                  note: widget.box.get(widget.indexKey)!.note,
                                  isStar:
                                      widget.box.get(widget.indexKey)!.isStar,
                                  isPast: true,
                                  isFuture: false,
                                  isNow: false,
                                  isHaveNote: widget.box
                                      .get(widget.indexKey)!
                                      .isHaveNote,
                                  isSetLoop: widget.box
                                      .get(widget.indexKey)!
                                      .isSetLoop,
                                );
                                //add to myBoxP
                                myBoxP.put(newTaskKey, newTask);

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => TaskDetail(
                                      indexKey: newTaskKey,
                                      box: myBoxP,
                                    ),
                                  ),
                                );
                              }

//                               // //XÓA TASK ĐANG CHỈNH SỬA TRONG BOX NOW
//                               int index = widget.indexKey;
//                               print('key nay xoa chua');
//                               // Xóa phần tử tại index
//                               myBox.deleteAt(widget.indexKey);

// // Cập nhật lại key của các phần tử phía sau
//                               for (int i = index; i < myBox.length; i++) {
//                                 final ToDoDataBase? element = myBox.get(i + 1);
//                                 if (element != null) {
//                                   final clonedElement = ToDoDataBase(
//                                     taskName: element.taskName,
//                                     isCompleted: element.isCompleted,
//                                     taskDate: element.taskDate,
//                                     taskTime: element.taskTime,
//                                     index: element.index,
//                                     isStar: element.isStar,
//                                     note: element.note,
//                                     flgTime: element.flgTime,
//                                     // Copy các thuộc tính khác của đối tượng element vào clonedElement
//                                   );
//                                   clonedElement.index = i;
//                                   myBox.put(i, clonedElement);
//                                   myBox.delete(i + 1);
//                                 }
//                               }

                              //going
                            }

                            //NGÀY CHỌN LÀ NGÀY KHÁC VỀ HIỆN TẠI
                            else if (selectedOnlyDate
                                .isAtSameMomentAs(nowOnlyDate)) {
                              if (widget.box.get(widget.indexKey)!.isNow ==
                                  true) {
                                widget.box.get(widget.indexKey)!.taskDate =
                                    formattedDate;
                                widget.box.put(widget.indexKey,
                                    widget.box.get(widget.indexKey)!);
                                Navigator.pop(context);
                              } else {
                                widget.box.get(widget.indexKey)!.isNow = true;
                                widget.box.get(widget.indexKey)!.isPast = false;
                                widget.box.get(widget.indexKey)!.isFuture =
                                    false;
                                // key
                                int newTaskKey = (myBox.length > 0)
                                    ? myBox.keyAt(myBox.length - 1) + 1
                                    : 0;
                                //add new task
                                ToDoDataBase newTask = ToDoDataBase(
                                  //nhận controller để tiếp tục edit
                                  taskName: widget.taskName,
                                  isCompleted: widget.box
                                      .get(widget.indexKey)!
                                      .isCompleted,
                                  taskDate: formattedDate,
                                  taskTime:
                                      widget.box.get(widget.indexKey)!.taskTime,
                                  index: newTaskKey,
                                  flgTime:
                                      widget.box.get(widget.indexKey)!.flgTime,
                                  note: widget.box.get(widget.indexKey)!.note,
                                  isStar:
                                      widget.box.get(widget.indexKey)!.isStar,
                                  isPast: false,
                                  isFuture: false,
                                  isNow: true,
                                  isHaveNote: widget.box
                                      .get(widget.indexKey)!
                                      .isHaveNote,
                                  isSetLoop: widget.box
                                      .get(widget.indexKey)!
                                      .isSetLoop,
                                );
                                //add to myBoxP
                                myBox.put(newTaskKey, newTask);

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => TaskDetail(
                                      indexKey: newTaskKey,
                                      box: myBox,
                                    ),
                                  ),
                                );
                              }
                            }

                            //NGÀY CHỌN LÀ NGÀY KHÁC VỀ TƯƠNG LAI
                            else if (selectedOnlyDate.isAfter(nowOnlyDate)) {
                              if (widget.box.get(widget.indexKey)!.isFuture! ==
                                  true) {
                                widget.box.get(widget.indexKey)!.taskDate =
                                    formattedDate;
                                widget.box.put(widget.indexKey,
                                    widget.box.get(widget.indexKey)!);
                                Navigator.pop(context);
                              } else {
                                widget.box.get(widget.indexKey)!.isNow = false;
                                widget.box.get(widget.indexKey)!.isPast = false;
                                widget.box.get(widget.indexKey)!.isFuture =
                                    true;
                                // key
                                int newTaskKey = (myBoxF.length > 0)
                                    ? myBoxF.keyAt(myBoxF.length - 1) + 1
                                    : 0;
                                //add new task
                                ToDoDataBase newTask = ToDoDataBase(
                                  //nhận controller để tiếp tục edit
                                  taskName: widget.taskName,
                                  isCompleted: widget.box
                                      .get(widget.indexKey)!
                                      .isCompleted,
                                  taskDate: formattedDate,
                                  taskTime:
                                      widget.box.get(widget.indexKey)!.taskTime,
                                  index: newTaskKey,
                                  flgTime:
                                      widget.box.get(widget.indexKey)!.flgTime,
                                  note: widget.box.get(widget.indexKey)!.note,
                                  isStar:
                                      widget.box.get(widget.indexKey)!.isStar,
                                  isPast: false,
                                  isFuture: true,
                                  isNow: false,
                                  isHaveNote: widget.box
                                      .get(widget.indexKey)!
                                      .isHaveNote,
                                  isSetLoop: widget.box
                                      .get(widget.indexKey)!
                                      .isSetLoop,
                                );
                                //add to myBoxP
                                myBoxF.put(newTaskKey, newTask);

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => TaskDetail(
                                      indexKey: newTaskKey,
                                      box: myBoxF,
                                    ),
                                  ),
                                );
                              }
                            }
                            // widget.updateTaskDate!(formattedDate);
                          }
                        },
                        child: Text(
                          'XONG',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            // color: kXongGreen,
                            color: listColor[myTopic.get('index')][0],
                          ),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OptionDay extends StatelessWidget {
  final String? nameOptionDay;
  final void Function()? onTap;
  final bool isTakeFocusColor;

  OptionDay({
    required this.nameOptionDay,
    this.onTap,
    required this.isTakeFocusColor,
  });
  final myTopic = Hive.box('topicColor');
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        margin: EdgeInsets.only(right: 0, top: 7, left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isTakeFocusColor == true
              ? listColor[myTopic.get('index')][0]
              : kGreyLight,
        ),
        child: Text(
          nameOptionDay!,
          style: TextStyle(
            fontSize: 16,
            color:
                isTakeFocusColor == true ? Colors.white : kGreyTextOptionLoop,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

DateTime getUpcomingSunday() {
  DateTime now = DateTime.now();
  int daysUntilSunday = DateTime.sunday - now.weekday;
  if (daysUntilSunday <= 0) {
    daysUntilSunday += 7;
  }
  return now.add(Duration(days: daysUntilSunday));
}

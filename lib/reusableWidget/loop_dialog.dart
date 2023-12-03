// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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

class LoopDialogBox extends StatefulWidget {
  // const LoopDialogBox({super.key});
  int indexKey;
  // // final void Function(String)? updateTaskDate;
  final ValueSetter<bool> onValueSelected;
  // String taskName;
  Box<ToDoDataBase> box;
  LoopDialogBox(
      {required this.indexKey,
      required this.box,
      required this.onValueSelected});
  // LoopDialogBox({
  //   required this.indexKey,
  //   required this.taskName,
  //   required this.box,
  //   // this.updateTaskDate,
  // });
  @override
  State<LoopDialogBox> createState() => _LoopDialogBoxState();
}

final myTopic = Hive.box('topicColor');

class _LoopDialogBoxState extends State<LoopDialogBox> {
  DateTime initDate = DateTime.now();
  DateTime? selectedDay; // Thêm biến selectedDay kiểu DateTime?
  DateTime now = DateTime.now();
  Box<ToDoDataBase> myBox = Hive.box<ToDoDataBase>('myBox');
  Box<ToDoDataBase> myBoxP = Hive.box<ToDoDataBase>('myBoxP');
  Box<ToDoDataBase> myBoxF = Hive.box<ToDoDataBase>('myBoxF');
  bool isSwitched = false;
  @override
  void initState() {
    super.initState();
    print('init loop');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // setState(() {
    //   if (widget.box.get(widget.key)!.isSetLoop != null) {
    //     isSwitched = widget.box.get(widget.key)!.isSetLoop!;
    //   }
    // });
    // DateTime initDate = DateFormat('dd/MM/yyyy')
    //     .parse(widget.box.get(widget.indexKey)!.taskDate ?? '');
    return AlertDialog(
      //Không dùng được BorderRadius của Container trong content của AlertDialog
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Đặt giá trị bo tròn ở đây
      ),
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.white,
      content: Container(
        height: height * 22 / 100,
        width: width * 90 / 100,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: Text(
                      'Đặt làm tác vụ lặp lại',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                    ),
                  ),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    activeTrackColor: listColor[myTopic.get('index')][2],
                    // activeColor: kActiveSwitchGreen,

                    activeColor: listColor[myTopic.get('index')][0],
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: EdgeInsets.only(right: 15, left: 20),
                      decoration: BoxDecoration(
                        color: kGreyLight,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Giờ',
                        style: TextStyle(
                            color:
                                //  isSwitched == true
                                //     ? Colors.white
                                //     : kGreyTextOptionLoop,
                                kGreyTextOptionLoop),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: EdgeInsets.only(
                        right: 15,
                      ),
                      decoration: BoxDecoration(
                        color: isSwitched == true
                            ? listColor[myTopic.get('index')][0]
                            : kGreyLight,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Hằng ngày',
                        style: TextStyle(
                          color: isSwitched == true
                              ? Colors.white
                              : kGreyTextOptionLoop,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: kGreyLight,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Hàng tuần',
                        style: TextStyle(
                            color:
                                //  isSwitched == true
                                //     ? Colors.white
                                //     : kGreyTextOptionLoop,
                                kGreyTextOptionLoop),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: kGreyLight,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Hàng tháng',
                        style: TextStyle(
                            color:
                                //  isSwitched == true
                                //     ? Colors.white
                                //     : kGreyTextOptionLoop,
                                kGreyTextOptionLoop),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin: EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: kGreyLight,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Hàng năm',
                        style: TextStyle(
                            color:
                                //  isSwitched == true
                                //     ? Colors.white
                                //     : kGreyTextOptionLoop,
                                kGreyTextOptionLoop),
                      ),
                    ),
                  ],
                ),
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
                          color: listColor[myTopic.get('index')][3],
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () => {
                              print('isSwitched: $isSwitched'),
                              if (isSwitched)
                                {
                                  widget.box.get(widget.indexKey)!.isSetLoop =
                                      true,
                                  widget.box.put(widget.indexKey,
                                      widget.box.get(widget.indexKey)!),
                                  widget.onValueSelected(true),
                                }
                              else
                                {
                                  widget.box.get(widget.indexKey)!.isSetLoop =
                                      false,
                                  widget.box.put(widget.indexKey,
                                      widget.box.get(widget.indexKey)!),
                                  widget.onValueSelected(false),
                                },
                              Navigator.pop(context),
                            },
                        child: Text(
                          'XONG',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
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
  OptionDay({
    required this.nameOptionDay,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 0, top: 7, left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: kSubColor,
        ),
        child: Text(
          nameOptionDay!,
          style: TextStyle(fontSize: 14),
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

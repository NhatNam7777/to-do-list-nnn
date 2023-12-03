// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/data/local_database.dart';
import '../constants.dart';
import 'package:intl/intl.dart';

class TaskCardStar extends StatefulWidget {
  final String? taskName;
  final bool? taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function()? editTask;
  final Function(BuildContext)? showCalendar;
  final bool? flgPast;
  final int? index;
  final Box<ToDoDataBase> box;
  final String? iconFlgName;
  final Function(BuildContext)? setStar;
  bool? isStar;
  TaskCardStar({
    super.key,
    this.onChanged,
    this.taskCompleted,
    this.taskName,
    this.deleteFunction,
    this.editTask,
    this.showCalendar,
    this.flgPast,
    this.index,
    required this.box,
    this.iconFlgName,
    required this.setStar,
    required this.isStar,
  });

  @override
  State<TaskCardStar> createState() => _TaskCardStarState();
}

bool starState = false;
bool isStar = true;
String iconFlgName = '';
String iconName = '';
final myTopic = Hive.box('topicColor');

class _TaskCardStarState extends State<TaskCardStar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool iconClick = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool flgDatePast = false;
    bool isFutureTask = false;
    Box<ToDoDataBase> myBox = Hive.box<ToDoDataBase>('myBox');
    bool flgStar = false;

    DateTime today = DateTime.now();
    //error here
    DateTime dateTime =
        DateFormat('dd/MM/yyyy').parse(widget.box.get(widget.index)!.taskDate!);
    String taskDate = DateFormat('dd-MM').format(dateTime);

    // if (widget.box.get(widget.key)!.isStar != null) {
    //   setState(() {
    //     bool starState = widget.box.get(widget.key)!.isStar!;
    //   });
    // }
    setState(() {
      bool isStar = widget.box.get(widget.key)?.isStar! ?? false;
    });
    if (widget.box.get(widget.key)?.isStar == null) {
      print('no null me roi');
    }
    print(isStar);
    // DateTime formattedToday =
    //     DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy').format(today));
    // DateTime taskDate1 =
    //     DateFormat('dd/MM/yyyy').parse(widget.box.get(widget.index)!.taskDate!);
    // if (taskDate1.isAfter(formattedToday)) {
    //   isFutureTask = true;
    // }
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor:
            Color(0XFF9AA4AC), // Màu của Checkbox khi chưa được check
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 5),
        child: GestureDetector(
          onTap: () => widget.editTask?.call(),
          child: Container(
            width: width - 20,
            height: 70,
            decoration: BoxDecoration(
              color: Color(0XFFFAFAFA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              Expanded(
                flex: 1,
                child: Checkbox(
                  //Hình lớn fill
                  activeColor: Color(0XFFC4CDD4),
                  //Hình nhỏ ở trong
                  checkColor: Color(0XFFFAFAFA),
                  shape: CircleBorder(),
                  onChanged: widget.onChanged,
                  value: widget.taskCompleted,
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Tên Task
                    Text(
                      widget.taskName!,
                      style: TextStyle(
                        color: Color(0XFF9F9F9F),
                        fontWeight: FontWeight.w500,
                        decoration: widget.taskCompleted!
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationThickness: 1.0,
                        decorationColor: Color.fromARGB(255, 145, 144, 144),
                        decorationStyle:
                            TextDecorationStyle.solid, // Chỉnh vị trí của chữ
                        fontSize: 18.0,
                      ),
                    ),
                    //icon

                    Row(
                      children: [
                        if (widget.box.get(widget.index)!.isFuture == true ||
                            widget.box.get(widget.index)!.isPast == true)
                          Row(
                            children: [
                              Text(
                                taskDate,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: widget.box
                                                .get(widget.index)!
                                                .isFuture! ==
                                            true
                                        ? Color(0XFF9F9F9F)
                                        : Color(0XFFC2706A),
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        if (widget.box.get(widget.index)!.isSetTime == true)
                          Row(
                            children: [
                              Text(
                                widget.box.get(widget.index)!.taskTime!,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0XFFC2706A),
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                'lib/assets/icons/bell.png',
                                width: 13,
                                color: kGreyIconTaskCard,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        if (widget.box.get(widget.index)!.isSetLoop == true)
                          Row(
                            children: [
                              Image.asset(
                                'lib/assets/icons/loop.png',
                                width: 13,
                                color: kGreyIconTaskCard,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        if (widget.box.get(widget.index)!.note != '')
                          Image.asset(
                            'lib/assets/icons/note.png',
                            width: 13,
                            color: kGreyIconTaskCard,
                          ),
                      ],
                    )
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        iconClick = !iconClick;
                      });
                      if (iconClick == true) {
                        widget.box.get(widget.index)!.isStar = true;
                        widget.box
                            .put(widget.index, widget.box.get(widget.index)!);
                      }
                      if (iconClick == false) {
                        widget.box.get(widget.index)!.isStar = false;
                        widget.box
                            .put(widget.index, widget.box.get(widget.index)!);
                      }
                    },
                    child: Image.asset(
                      'lib/assets/icons/star1.png',

                      // 'lib/assets/icons/${widget.iconFlgName}!.png',

                      width: 25,
                      height: 25,
                      //change topic
                      color: iconClick == true
                          ? listColor[myTopic.get('index')][0]
                          : Colors.grey,
                      //below is colorful
                      // color: Color(0xFFED4E80),
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
    ;
  }
}

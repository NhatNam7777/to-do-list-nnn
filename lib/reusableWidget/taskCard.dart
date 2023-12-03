// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/data/local_database.dart';
import '../constants.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatefulWidget {
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
  final bool? isStar;
  TaskCard({
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
  State<TaskCard> createState() => _TaskCardState();
}

bool starState = false;
bool isStar = true;
String iconFlgName = '';
final myTopic = Hive.box('topicColor');

class _TaskCardState extends State<TaskCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
        child: Slidable(
          // enabled: false,
          endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: widget.setStar,
                spacing: 4,
                //Sai
                // icon: widget.box.get(widget.key)!.isStar!
                //     ? Icons.star
                //     : Icons.star_border,
                icon: widget.isStar == true ? Icons.star : Icons.star_border,
                label: 'Star',
                // foregroundColor: flgStar == true ? Colors.yellow : Colors.white,
                // foregroundColor: Color(0XFF96A6A9),
                //GREEN change topic
                // foregroundColor: Color(0XFF4DA7A3),
                // foregroundColor: kMainPink,
                foregroundColor: widget.isStar == true
                    ? listColor[myTopic.get('index')][0]
                    : Color(0XFF96A6A9),
                //change topic
                // backgroundColor: Color(0XFFDCEEED),
                // backgroundColor: kPinklight,
                // backgroundColor: listColor[myTopic.get('index')][1],
                backgroundColor: listColor[myTopic.get('index')][1],
              ),
              SlidableAction(
                onPressed: widget.showCalendar,
                icon: Icons.calendar_month_sharp,
                label: 'Ngày',
                foregroundColor: Colors.white,
                //change topic
                backgroundColor: listColor[myTopic.get('index')][0],
              ),
              SlidableAction(
                onPressed: widget.deleteFunction,
                icon: Icons.delete_forever_rounded,
                label: 'Xóa',
                foregroundColor: Colors.white,
                backgroundColor: Color(0XFFE15757),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              )
            ],
          ),
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
                // Expanded(
                //     flex: 1,
                //     child: GestureDetector(
                //       onTap: () {
                //         OverlayEntry overlayEntry = OverlayEntry(
                //           builder: (context) => PopUpFlagTask(),
                //         );
                //         Overlay.of(context)?.insert(overlayEntry);
                //       },
                //       child: Image.asset(
                //         'lib/assets/icons/priorityFlag.png',
                //         width: 25,
                //         height: 25,
                //       ),
                //     ))
                Builder(builder: (BuildContext context) {
                  // if (widget.isStar == true) {
                  //   iconFlgName = 'star1';
                  // }
                  // if (widget.isStar == false) {
                  //   iconFlgName = 'priorityFlag';
                  // }
                  return PopupMenuButton<String>(
                    icon: Image.asset(
                      'lib/assets/icons/priorityFlag.png',
                      // 'lib/assets/icons/${widget.iconFlgName}!.png',

                      width: 25,
                      height: 25,
                      color: Color(0XFF9AA4AC),
                      //below is colorful
                      // color: Color(0xFFED4E80),
                    ),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    position: PopupMenuPosition.under,
                    offset: Offset(-40, -5),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'option1',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Đánh dấu bằng ký  hiệu',
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                Text('Sạch'),
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text('Lá cờ'),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => print('ok set flg here'),
                                  child: Image.asset(
                                    'lib/assets/icons/flag-pri.png',
                                    color: Color(0xFFED4E80),
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () => print('ok set flg here'),
                                  child: Image.asset(
                                    'lib/assets/icons/flag-pri.png',
                                    color: Color(0xFFF9B604),
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () => print('ok set flg here'),
                                  child: Image.asset(
                                    'lib/assets/icons/flag-pri.png',
                                    color: Color(0xFFC281FF),
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () => print('ok set flg here'),
                                  child: Image.asset(
                                    'lib/assets/icons/flag-pri.png',
                                    color: Color(0xFF4487E8),
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () => print('ok set flg here'),
                                  child: Image.asset(
                                    'lib/assets/icons/flag-pri.png',
                                    color: Color(0xFF37B16C),
                                    width: 25,
                                  ),
                                ),

                                // Icon(
                                //   Icons.emoji_flags_outlined,
                                //   size: 20,
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text('Con số'),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => {},
                                  child: Image.asset(
                                    'lib/assets/icons/number-one.png',
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () => {},
                                  child: Image.asset(
                                    'lib/assets/icons/number-two.png',
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () => {},
                                  child: Image.asset(
                                    'lib/assets/icons/number-three.png',
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () => {},
                                  child: Image.asset(
                                    'lib/assets/icons/number-four.png',
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () => {},
                                  child: Image.asset(
                                    'lib/assets/icons/number-five.png',
                                    width: 25,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text('Khí sắc'),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => {},
                                  child: Image.asset(
                                    'lib/assets/icons/emoji-smile.png',
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () => {},
                                  child: Image.asset(
                                    'lib/assets/icons/emoji-party.png',
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () => {},
                                  child: Image.asset(
                                    'lib/assets/icons/emoji-sad.png',
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () => {},
                                  child: Image.asset(
                                    'lib/assets/icons/emoji-confused.png',
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () => {},
                                  child: Image.asset(
                                    // 'lib/assets/icons/emoji-money.png',
                                    'lib/assets/icons/lovely.png',
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      // PopupMenuItem<String>(
                      //   value: 'option2',
                      //   child: Column(
                      //     children: [
                      //       SizedBox(
                      //         height: 15,
                      //       ),
                      //       GestureDetector(
                      //         child: Text('Tìm kiếm'),
                      //         onTap: () => print(''),
                      //       ),
                      //       SizedBox(
                      //         height: 15,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // PopupMenuItem<String>(
                      //   value: 'option3',
                      //   child: GestureDetector(
                      //     onTap: () => {},
                      //     child: Column(
                      //       children: [
                      //         SizedBox(
                      //           height: 15,
                      //         ),
                      //         Text('Sắp xếp công việc'),
                      //         SizedBox(
                      //           height: 15,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // PopupMenuItem<String>(
                      //   value: 'option3',
                      //   child: Column(
                      //     children: [
                      //       Text('Ngôn ngữ'),
                      //       SizedBox(
                      //         height: 0,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                    onSelected: (String result) {
                      // Xử lý khi người dùng chọn một tùy chọn từ danh sách
                      print('Selected: $result');
                    },
                  );
                })
                // priorityFlag

                // Expanded(
                //     flex: 1,
                //     child: GestureDetector(
                //       onTap: () {
                //         showDialog(
                //             context: context,
                //             builder: (BuildContext context) => CustomDialog());
                //       },
                //       child: Image.asset(
                //         'lib/assets/icons/priorityFlag.png',
                //         width: 25,
                //         height: 25,
                //         color: Color(0XFF9AA4AC),
                //       ),
                //     ))
              ]),
            ),
          ),
        ),
      ),
    );
    ;
  }
}

class PopUpFlagTask extends StatelessWidget {
  const PopUpFlagTask({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pop(); // Đóng cửa sổ nhỏ khi nhấn vào bất kỳ vị trí nào bên ngoài
      },
      child: Material(
        color: Colors.transparent, // Đặt màu nền là mờ
        child: Center(
          child: Container(
            width: 200,
            height: 200,
            color: Colors.red,
            child: Text('Nội dung cửa sổ nhỏ'),
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Đặt màu nền là mờ
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.blue,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nội dung hộp thoại',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại khi nhấn vào nút
              },
              child: Text('Đóng'),
            ),
          ],
        ),
      ),
    );
  }
}
// class CustomDialog1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Theme.of(context).copyWith(
//         // Đặt màu overlay là transparent để không làm mờ phần xung quanh
//         dialogBackgroundColor: Colors.white,
//         overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
//       ),
//       child: AlertDialog(
//         title: Text('Nội dung hộp thoại'),
//         content: Text('Đây là nội dung của hộp thoại'),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Đóng'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:to_do_list_nhatnam/constants.dart';
import 'package:to_do_list_nhatnam/data/category_database.dart';
import 'package:to_do_list_nhatnam/main.dart';
import 'package:to_do_list_nhatnam/reusableWidget/delete_dialog.dart';
import 'package:to_do_list_nhatnam/reusableWidget/calendar_dialog.dart';
import 'package:to_do_list_nhatnam/reusableWidget/loop_dialog.dart';
import 'package:to_do_list_nhatnam/reusableWidget/sub_task.dart';
import 'package:to_do_list_nhatnam/reusableWidget/time_dialog.dart';
import 'package:to_do_list_nhatnam/screens/home_page.dart';
import 'package:to_do_list_nhatnam/screens/note_page.dart';
import 'package:to_do_list_nhatnam/services/notifi_service.dart';
import 'task_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_nhatnam/data/local_database.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_nhatnam/services/data_to_everywhere.dart';

class TaskDetail extends StatefulWidget {
  final int indexKey;
  final Box<ToDoDataBase> box;
  TaskDetail({
    required this.indexKey,
    required this.box,
  });

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

bool flgWantTakeDataFromDetail = true;

class _TaskDetailState extends State<TaskDetail> {
  final taskController = TextEditingController();
  // Box<ToDoDataBase> widget.box = Hive.box<ToDoDataBase>('widget.box');
  // Box<ToDoDataBase> widget.boxP = Hive.box<ToDoDataBase>('widget.boxP');
  // Box<ToDoDataBase> widget.boxF = Hive.box<ToDoDataBase>('widget.boxF');
  Box<Category> myBoxCate = Hive.box<Category>('category');
  final myTopic = Hive.box('topicColor');
  bool isLoop = false;
  TimeOfDay now = TimeOfDay.now();
  bool flgTime = false;
  String receivedValueCre = '';
  // void updateTaskDate(String newDate) {
  //   setState(() {
  //     widget.box.get(widget.indexKey)!.taskDate = newDate;
  //   });
  // }
  bool cateSelected = false;
  final myCateList = Hive.box('cateList');

  void showCalendarDialog() {
    print('fjdsjf');
    Provider.of<WantTakeDataFrDetail>(context, listen: false)
        .setActionDone(true);
    showDialog(
        context: context,
        builder: (context) {
          return CalendarDialogBox(
            indexKey: widget.indexKey,
            taskName: taskController.text,
            box: widget.box,
            // updateTaskDate: updateTaskDate,
          );
        });
  }

  void updateTaskTime(String newTime) {
    setState(() {
      widget.box.get(widget.indexKey)!.taskTime = newTime;
    });
  }

  void showTimeDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return TimeDialog(
            indexKey: widget.indexKey,
            box: widget.box,
            updateTaskTime: updateTaskTime,
            timeFromDetailPage: widget.box.get(widget.indexKey)!.taskTime ?? '',
            // updateFlgTime: updateFlgTime,
          );
        });
  }

  void updateFlgTime(bool flgTimeState) {
    setState(() {
      flgTime = flgTimeState;
    });
  }

  bool activeNotification = false;
  //Đổi kiểu String 'hh:mm a' thành 'HH:mm'
  // String convertTime(String timeString) {
  //   // Định dạng ban đầu của chuỗi thời gian
  //   String initialFormat = 'hh:mm a';

  //   // Định dạng mới của chuỗi thời gian
  //   String newFormat = 'HH:mm';

  //   // Chuyển chuỗi thời gian về định dạng DateTime
  //   DateTime dateTime = DateFormat(initialFormat).parse(timeString);

  //   // Chuyển đổi DateTime sang chuỗi theo định dạng mới
  //   String newTimeString = DateFormat(newFormat).format(dateTime);

  //   return newTimeString;
  // }

  void litenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);
  void onClickedNotification(String? payLoad) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(payLoad: payLoad),
      ),
      (Route<dynamic> route) => false,
    );
  }

//  GestureDetector(
//                   child: Text('t112'),
//                   onTap: () {
//                     NotificationApi.showNotification(
//                       title: 'Nhắc nhở công việc',
//                       body: widget.box.get(widget.indexKey)!.taskName,
//                       payLoad: 'payload ne',
//                     );
//                   },
//                 ),
  void alarm() {
    // if (widget.box.get(widget.indexKey)!.isSetTime == true) {
    String timeString = widget.box
        .get(widget.indexKey)!
        .taskTime!; // Chuỗi có định dạng "HH:mm"
    String newTimeString = '';
    if (timeString.endsWith('AM') || timeString.endsWith('PM')) {
      newTimeString = timeString.substring(0, timeString.length - 2);
    } else {
      newTimeString = timeString;
    }
    List<String> timeParts = newTimeString.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    DateTime currentTime = DateTime.now(); // Thời gian hiện tại

    DateTime dateTime = DateTime(
        currentTime.year, currentTime.month, currentTime.day, hour, minute);
    print('current time: $dateTime');
    setState(() {
      NotificationApi.showScheduleNotification(
        title: 'Nhắc nhở công việc',
        body: widget.box.get(widget.indexKey)!.taskName,
        payLoad: 'work time',
        scheduleDate: dateTime.add(Duration(seconds: 1)),
        // scheduleDate:
      );
      activeNotification = true;
    });
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (activeNotification) {
    //   NotificationApi.init();
    //   litenNotifications();
    // }
    //need
  }

  void showLoopDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return LoopDialogBox(
            indexKey: widget.indexKey,
            box: widget.box,
            onValueSelected: (value) => {
              setState(() {
                if (value) {
                  isLoop = true;
                  print('loop true');
                  widget.box.get(widget.indexKey)!.isSetLoop = true;
                  widget.box
                      .put(widget.indexKey, widget.box.get(widget.indexKey)!);
                } else {
                  isLoop = false;
                  print('loop false');
                  widget.box.get(widget.indexKey)!.isSetLoop = false;
                  widget.box
                      .put(widget.indexKey, widget.box.get(widget.indexKey)!);
                }
              }),
            },
          );
        });
  }

  void deleteTask(int key, Box<ToDoDataBase> box) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteDialog(
          onValueSelected: (value) => {
            if (value)
              {
                // Navigator.pop(context, widget.key),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage())),
                // box.delete(key),
              }
          },
        );
      },
    );
  }

  void setCompleted() {
    widget.box.get(widget.indexKey)!.isCompleted = true;
    widget.box.put(widget.indexKey, widget.box.get(widget.indexKey)!);
  }

  // List<String> popupItems = [
  //   'Item 1',
  //   'Item 2',
  //   'Item 3',
  //   'Item 4',
  //   // Thêm các mục khác nếu cần
  // ];
  List<String> popupItems = [];

  void addCateToPopupItems() {
    for (int index = 0; index < myBoxCate.length; index++) {
      List<int> allKeys = myBoxCate.keys.map<int>((key) => key as int).toList();
      final int key = allKeys[index];
      final Category cate = myBoxCate.get(key)!;
      popupItems.add(myBoxCate.get(key)?.cateName ?? 'null');
    }
  }

  @override
  Widget build(BuildContext context) {
    String taskName = widget.box.get(widget.indexKey)!.taskName!;
    taskController.text = taskName;

    // Lấy chiều dài của giá trị trong TextField
    int textLength = taskController.text.length;
// Di chuyển con trỏ chuột vào cuối của giá trị
    taskController.selection = TextSelection(
        baseOffset: textLength, extentOffset: textLength, isDirectional: false);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // alarm();
    var dataTakeDataFrDetail = Provider.of<WantTakeDataFrDetail>(context);
    bool actionDoneTakeData = dataTakeDataFrDetail.actionDone;
    bool isFake = false;
    // Provider.of<DelCurrentTaskAndReplaceByNextTask>(context, listen: false)
    //     .setActionDone(false);
    // bool actionDone = Provider.of<WantTakeDataFrDetail>(context).actionDone;
    addCateToPopupItems();
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 20, 17, 17),
          ),
          onTap: () {
            print('actionDoneTakeData: $actionDoneTakeData');
            // valuesToReturn.add(taskController.text),
            // if (actionDoneTakeData == true) {
            //   print('Accept to take data from detail');
            //   widget.box.get(widget.indexKey)!.taskName = taskController.text;
            //   widget.box.put(widget.indexKey, widget.box.get(widget.indexKey)!);
            // } else {
            //   print('Deny to take data from detail');
            //   Provider.of<DelCurrentTaskAndReplaceByNextTask>(context,
            //           listen: false)
            //       .setActionDone(true);
            // }
            widget.box.get(widget.indexKey)!.taskName = taskController.text;
            widget.box.put(widget.indexKey, widget.box.get(widget.indexKey)!);
            Provider.of<DelCurrentTaskAndReplaceByNextTask>(context,
                    listen: false)
                .setActionDone(false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                // fullscreenDialog: true,
                builder: (context) => HomePage(),
              ),
            );
          },
        ),
        actions: [
          // Image.asset(
          //   'lib/assets/icons/three-dots.png',
          //   // height: 10,
          //   width: 30,
          //   color: Colors.grey.shade700,
          // ),
          PopupMenuButton<String>(
            icon: Image.asset(
              'lib/assets/icons/three-dots.png',
              // height: 10,
              width: 25,
              color: Colors.grey.shade700,
            ),
            elevation: 25,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            // position: PopupMenuPosition.under,
            offset: Offset(-25, 40),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'option1',
                child: GestureDetector(
                  onTap: () {
                    setCompleted();
                  },
                  child: Column(
                    children: [
                      Text('Đánh dấu là hoàn thành'),
                      SizedBox(
                        //when have 3
                        // height: 40,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              // PopupMenuItem<String>(
              //   value: 'option2',
              //   child: Column(
              //     children: [
              //       GestureDetector(
              //         child: Text('Bắt đầu tập chung'),
              //         onTap: () => print(''),
              //       ),
              //       SizedBox(
              //         height: 30,
              //       ),
              //     ],
              //   ),
              // ),
              PopupMenuItem<String>(
                value: 'option3',
                child: GestureDetector(
                  onTap: () => deleteTask(widget.indexKey, widget.box),
                  child: Column(
                    children: [
                      Text('Xóa nhiệm vụ này'),
                      SizedBox(
                        height: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            onSelected: (String result) {
              // Xử lý khi người dùng chọn một tùy chọn từ danh sách
              print('Selected: $result');
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GestureDetector(
          //   child: Text('test'),
          //   onTap: () {
          //     // print(popupItems);
          //   },
          // ),
          Container(
            margin: EdgeInsets.only(left: 25),
            child: PopupMenuButton<String>(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: listColor[myTopic.get('index')][1],
                ),
                child: Text(popupItems.length < 1
                    ? 'Chưa phân loại'
                    : widget.box.get(widget.indexKey)?.category ??
                        'Chưa phân loại'),
              ),
              offset: Offset(10, 40),
              itemBuilder: (BuildContext context) {
                return popupItems.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              },
              onSelected: (String selectedItem) {
                // Xử lý khi một mục trong menu được chọn

                print('Selected item: $selectedItem');
                widget.box.get(widget.indexKey)!.category = selectedItem;
                widget.box
                    .put(widget.indexKey, widget.box.get(widget.indexKey)!);
                for (int index = 0; index < myBoxCate.length; index++) {
                  List<int> allKeys =
                      myBoxCate.keys.map<int>((key) => key as int).toList();
                  final int key = allKeys[index];
                  final Category cate = myBoxCate.get(key)!;
                  if (myBoxCate.get(key)!.cateName == selectedItem) {
                    myBoxCate.get(key)!.numTask =
                        myBoxCate.get(key)!.numTask! + 1;
                  }
                  myBoxCate.put(key, myBoxCate.get(key)!);
                }
                setState(() {});
              },
            ),
          ),

          SizedBox(
            height: 10,
          ),
          // Material(
          //Ô chỉnh sửa tên task
          // child:
          Container(
            height: height * 15 / 100,
            width: width - 30,
            padding: EdgeInsets.only(left: 20),
            child: TextField(
              maxLength: (100).toInt(),
              expands: true,
              maxLines: null,
              controller: taskController,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          // ),
          SizedBox(
            height: 50,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DividerDetailPage(),
                //NGÀY ĐẾN HẠN
                ValueListenableBuilder(
                    valueListenable: widget.box.listenable(),
                    builder: (context, Box<ToDoDataBase> box, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'lib/assets/icons/calendar-detail.png',
                                  width: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Ngày đến hạn",
                                    style: TextStyle(color: Color(0XFF747474)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => showCalendarDialog(),
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
//change topic
                                  color: listColor[myTopic.get('index')][1],
                                ),
                                child: Text(
                                  widget.box.get(widget.indexKey)!.taskDate ??
                                      'f',
                                )),
                          )
                        ],
                      );
                    }),

                DividerDetailPage(),
                //THỜI GIAN LÀM VIỆC
                ValueListenableBuilder(
                  valueListenable: widget.box.listenable(),
                  builder: (context, Box<ToDoDataBase> box, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'lib/assets/icons/clock-detail.png',
                                width: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Thời gian làm việc",
                                  style: TextStyle(color: Color(0XFF747474)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: widget.box.listenable(),
                          builder: (context, Box<ToDoDataBase> box, _) {
                            return GestureDetector(
                              onTap: () => showTimeDialog(),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

//change topic
                                  color: listColor[myTopic.get('index')][1],
                                ),
                                child: Text(
                                  widget.box.get(widget.indexKey)!.flgTime ==
                                          true
                                      ? widget.box
                                          .get(widget.indexKey)!
                                          .taskTime!
                                      : 'Không',
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    );
                  },
                ),
                DividerDetailPage(),
                //LẶP LẠI NHIỆM VỤ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Image.asset(
                            'lib/assets/icons/loop-detail.png',
                            width: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "Lặp lại nhiệm vụ",
                              style: TextStyle(color: Color(0XFF747474)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showLoopDialog();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),

//change topic
                          color: listColor[myTopic.get('index')][1],
                        ),
                        child: Text(
                            isLoop == false ? 'Không' : 'Hằng ngày lặp lại'),
                      ),
                    )
                  ],
                ),
                DividerDetailPage(),
                //GHI CHÚ
                GestureDetector(
                  onTap: () async {
                    var receivedValue = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => NotePage(
                          taskName: taskController.text,
                          index: widget.indexKey,
                          box: widget.box,
                        ),
                      ),
                    );
                    if (receivedValue != null) {
                      setState(() {
                        receivedValueCre = receivedValue;
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder(
                          valueListenable: widget.box.listenable(),
                          builder: (context, Box<ToDoDataBase> box, _) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'lib/assets/icons/calendar-detail.png',
                                    width: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Ghi chú',
                                          style: TextStyle(
                                              color: Color(0XFF747474)),
                                        ),
                                        if (widget.box
                                                    .get(widget.indexKey)!
                                                    .note !=
                                                null &&
                                            widget.box
                                                    .get(widget.indexKey)!
                                                    .note !=
                                                '')
                                          Text(widget.box
                                                  .get(widget.indexKey)!
                                                  .note ??
                                              '')
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),

//change topic
                          color: listColor[myTopic.get('index')][1],
                        ),
                        child: Text(
                          widget.box.get(widget.indexKey)!.note! == null ||
                                  widget.box.get(widget.indexKey)!.note! == ''
                              ? 'Thêm'
                              : 'CHỈNH SỬA',
                        ),
                      ),
                    ],
                  ),
                ),
                DividerDetailPage(),
                //TEST DEBUG
                // GestureDetector(
                //   child: Text('Demo Notification'),
                //   onTap: () {
                //     NotificationApi.showNotification(
                //       title: 'Nhắc nhở công việc',
                //       body: widget.box.get(widget.indexKey)!.taskName,
                //       payLoad: 'payload ne',
                //     );
                //   },
                // ),
                // DividerDetailPage(),
                // GestureDetector(
                //   child: Text('t112'),
                //   onTap: () {
                //     NotificationApi.showScheduleNotification(
                //       title: 'Nhắc nhở công việc',
                //       body: widget.box.get(widget.indexKey)!.taskName,
                //       payLoad: 'work time',
                //       scheduleDate: DateTime.now().add(Duration(seconds: 10)),
                //       // scheduleDate:
                //     );
                //   },
                // ),
                // DividerDetailPage(),
//           GestureDetector(
//               child: Text('t1123'),
//               onTap: () {
//                 String timeString = widget.box
//                     .get(widget.indexKey)!
//                     .taskTime!; // Chuỗi có định dạng "HH:mm"
//                 List<String> timeParts = timeString.split(":");
//                 int hour = int.parse(timeParts[0]);
//                 int minute = int.parse(timeParts[1]);
//                 DateTime currentTime = DateTime.now(); // Thời gian hiện tại
// // Tạo đối tượng DateTime mới với giờ và phút được đọc từ chuỗi
//                 DateTime dateTime = DateTime(currentTime.year,
//                     currentTime.month, currentTime.day, hour, minute);
//                 print('DateTime từ widget.box sau khi định dạng thành kiểu DateTime' +
//                     dateTime
//                         .toString()); // In ra kết quả: 2023-07-19 10:06:00.000
//                 // print(widget.box.get(widget.indexKey)!.taskTime);
//                 // print('test ' + DateTime.now().toString());
//                 setState(() {
//                   NotificationApi.showScheduleNotification(
//                     title: 'Nhắc nhở công việc',
//                     body: widget.box.get(widget.indexKey)!.taskName,
//                     payLoad: 'work time',
//                     scheduleDate: dateTime.add(Duration(seconds: 1)),
//                     // scheduleDate:
//                   );
//                 });
//               }),
                // Row(
                //   children: [Text('Tệp đính kèm')],
                // ),
                // DividerDetailPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Divider DividerDetailPage() {
    return Divider(
      endIndent: 20,
      indent: 20,
      color: Color(0XFFF6F6F6),
      thickness: 1,
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list_nhatnam/constants.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart' as tz;

//time_picker_sheet
import 'package:time_picker_sheet/widget/behaviour/snap_scroll.dart';
import 'package:time_picker_sheet/widget/composition/body.dart';
import 'package:time_picker_sheet/widget/composition/header.dart';
import 'package:time_picker_sheet/widget/composition/indicator.dart';
import 'package:time_picker_sheet/widget/composition/numbers.dart';
import 'package:time_picker_sheet/widget/composition/wheel.dart';
import 'package:time_picker_sheet/widget/provider/time_picker.dart';
import 'package:time_picker_sheet/widget/sheet.dart';
import 'package:time_picker_sheet/widget/time_picker.dart';
//time_picker_sheet
import 'package:to_do_list_nhatnam/data/local_database.dart';
import 'package:hive/hive.dart';

//numberpicker
import 'package:numberpicker/numberpicker.dart';

class TimeDialog extends StatefulWidget {
  int? indexKey;
  Box<ToDoDataBase> box;

  final void Function(String)? updateTaskTime;
  String? timeFromDetailPage;
  // final void Function(bool)? updateFlgTime;

  TimeDialog({
    required this.indexKey,
    required this.box,
    required this.updateTaskTime,
    required this.timeFromDetailPage,
    // required this.updateFlgTime,
  });
  @override
  State<TimeDialog> createState() => TimeDialogState();
}

final myTopic = Hive.box('topicColor');

class TimeDialogState extends State<TimeDialog> {
  // String graphicIconName = 'access_time';
  // String typedIconName = 'keyboard_alt_sharp ';
  IconData currentIcon = Icons.keyboard_alt_sharp;
  bool flg = false;
  TimeOfDay? selectedTime;
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool flgTime = false;
  bool pressDone = false;
  Color? boxTimeColorUNSelected = Color(0XFFF2F6F7);
  Color? boxTimeColorSelected = Colors.green[200];

  bool timeNoneselected = false;
  bool time7selected = false;
  bool time9selected = false;
  bool time10selected = false;
  bool time12selected = false;
  bool time14selected = false;
  bool time16selected = false;
  bool time18selected = false;

  var hour = 0;
  var minute = 0;
  var timeFormat = "AM";

  Box<ToDoDataBase> myBox = Hive.box<ToDoDataBase>('myBox');
  // Box<List<ToDoDataBase>> myBoxNow = Hive.box<List<ToDoDataBase>>('myBoxNow');

  Box<ToDoDataBase> myBoxP = Hive.box<ToDoDataBase>('myBoxP');
  Box<ToDoDataBase> myBoxF = Hive.box<ToDoDataBase>('myBoxF');

  void toggleIcon() {
    setState(() {
      if (currentIcon == Icons.keyboard_alt_sharp) {
        currentIcon = Icons.access_time;
      } else {
        currentIcon = Icons.keyboard_alt_sharp;
      }
    });
  }

  Widget fdsfds() {
    return new TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: TextStyle(fontSize: 24, color: Colors.deepOrange),
      highlightedTextStyle: TextStyle(fontSize: 24, color: Colors.yellow),
      spacing: 50,
      itemHeight: 80,
      isForce2Digits: true,
      onTimeChange: (time) {
        setState(() {
          // _dateTime = time;
        });
      },
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        flgTime = true;
        _selectedTime = pickedTime;
        // widget.updateFlgTime!(flgTime);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    String? taskTime = widget.box.get(widget.indexKey)?.taskTime;
    DateTime? taskDateTime = DateFormat('HH:mm').parse(taskTime ?? '');
    _selectedTime = taskDateTime != null
        ? TimeOfDay.fromDateTime(taskDateTime)
        : TimeOfDay.now();
    // selectedTime = _selectedTime;

    timeNoneselected = false;
    time7selected = false;
    time9selected = false;
    time10selected = false;
    time12selected = false;
    time14selected = false;
    time16selected = false;
    time18selected = false;
  }

  void startSelectTime() {
    if (widget.box.get(widget.indexKey)!.isSetTime == false &&
        time7selected == false &&
        time9selected == false &&
        time10selected == false &&
        time12selected == false &&
        time14selected == false &&
        time16selected == false &&
        time18selected == false) {
      timeNoneselected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime? timeFromDetailPage =
        DateFormat('HH:mm').parse(widget.timeFromDetailPage ?? '');
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    startSelectTime();
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Container(
          height: height * 65 / 100,
          width: width - 50,
          child: Builder(
            builder: ((context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Title
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, top: 15),
                      child: Text(
                        'Cài đặt thời gian',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  //Pick time number picker
                  // Expanded(
                  //   flex: 3,
                  //   child: Container(
                  //     width: width - 50,
                  //     decoration: BoxDecoration(
                  //         border: Border.all(width: 1, color: Colors.red)),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       mainAxisSize: MainAxisSize.max,
                  //       children: [
                  //         Text(
                  //             "Pick Your Time! ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, "0")} ${timeFormat}",
                  //             style: const TextStyle(
                  //                 fontWeight: FontWeight.bold, fontSize: 18)),
                  //         const SizedBox(
                  //           height: 10,
                  //         ),
                  //         Container(
                  //           padding: const EdgeInsets.symmetric(
                  //               horizontal: 20, vertical: 10),
                  //           decoration: BoxDecoration(
                  //               color: Colors.black87,
                  //               borderRadius: BorderRadius.circular(10)),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //             children: [
                  //               NumberPicker(
                  //                 minValue: 0,
                  //                 maxValue: 12,
                  //                 value: hour,
                  //                 zeroPad: true,
                  //                 infiniteLoop: true,
                  //                 itemWidth: 80,
                  //                 itemHeight: 60,
                  //                 onChanged: (value) {
                  //                   setState(() {
                  //                     hour = value;
                  //                   });
                  //                 },
                  //                 textStyle: const TextStyle(
                  //                     color: Colors.grey, fontSize: 20),
                  //                 selectedTextStyle: const TextStyle(
                  //                     color: Colors.white, fontSize: 30),
                  //                 decoration: const BoxDecoration(
                  //                   border: Border(
                  //                       top: BorderSide(
                  //                         color: Colors.white,
                  //                       ),
                  //                       bottom: BorderSide(color: Colors.white)),
                  //                 ),
                  //               ),
                  //               NumberPicker(
                  //                 minValue: 0,
                  //                 maxValue: 59,
                  //                 value: minute,
                  //                 zeroPad: true,
                  //                 infiniteLoop: true,
                  //                 itemWidth: 80,
                  //                 itemHeight: 60,
                  //                 onChanged: (value) {
                  //                   setState(() {
                  //                     minute = value;
                  //                   });
                  //                 },
                  //                 textStyle: const TextStyle(
                  //                     color: Colors.grey, fontSize: 20),
                  //                 selectedTextStyle: const TextStyle(
                  //                     color: Colors.white, fontSize: 30),
                  //                 decoration: const BoxDecoration(
                  //                   border: Border(
                  //                       top: BorderSide(
                  //                         color: Colors.white,
                  //                       ),
                  //                       bottom: BorderSide(color: Colors.white)),
                  //                 ),
                  //               ),
                  //               Column(
                  //                 children: [
                  //                   GestureDetector(
                  //                     onTap: () {
                  //                       setState(() {
                  //                         timeFormat = "AM";
                  //                       });
                  //                     },
                  //                     child: Container(
                  //                       padding: const EdgeInsets.symmetric(
                  //                           horizontal: 20, vertical: 10),
                  //                       decoration: BoxDecoration(
                  //                           color: timeFormat == "AM"
                  //                               ? Colors.grey.shade800
                  //                               : Colors.grey.shade700,
                  //                           border: Border.all(
                  //                             color: timeFormat == "AM"
                  //                                 ? Colors.grey
                  //                                 : Colors.grey.shade700,
                  //                           )),
                  //                       child: const Text(
                  //                         "AM",
                  //                         style: TextStyle(
                  //                             color: Colors.white, fontSize: 25),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   const SizedBox(
                  //                     height: 15,
                  //                   ),
                  //                   GestureDetector(
                  //                     onTap: () {
                  //                       setState(() {
                  //                         timeFormat = "PM";
                  //                       });
                  //                     },
                  //                     child: Container(
                  //                       padding: const EdgeInsets.symmetric(
                  //                           horizontal: 20, vertical: 10),
                  //                       decoration: BoxDecoration(
                  //                         color: timeFormat == "PM"
                  //                             ? Colors.grey.shade800
                  //                             : Colors.grey.shade700,
                  //                         border: Border.all(
                  //                           color: timeFormat == "PM"
                  //                               ? Colors.grey
                  //                               : Colors.grey.shade700,
                  //                         ),
                  //                       ),
                  //                       child: const Text(
                  //                         "PM",
                  //                         style: TextStyle(
                  //                             color: Colors.white, fontSize: 25),
                  //                       ),
                  //                     ),
                  //                   )
                  //                 ],
                  //               )
                  //             ],
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  Expanded(
                    flex: 4,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
//big place to display time
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  // mặc định là có AM/PM sử dụng replace để bỏ đồng thời hiện thị
                                  // kiểu 24h
                                  // _selectedTime
                                  //     .format(context)
                                  //     .toString()
                                  //     .replaceAll(RegExp('[A-z]'), ''),
                                  // formattedTime,
                                  _selectedTime.format(context).toString(),
                                  style: TextStyle(
                                      fontSize: 46,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromARGB(255, 54, 54, 54)),
                                ),
                              ),
                              onTap: () => _selectTime(),
                            ),
                          ),

                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TimeOption(
                                      isTakeFocusColor: timeNoneselected,
                                      nameTimeOption: 'Không có thời gian',
                                      onTap: () {
                                        setState(() {
                                          flgTime = false;
                                          _selectedTime = TimeOfDay.now();
                                          print(_selectedTime);

                                          // widget.updateFlgTime!(flgTime);
                                          timeNoneselected = true;
                                          time7selected = false;
                                          time9selected = false;
                                          time10selected = false;
                                          time12selected = false;
                                          time14selected = false;
                                          time16selected = false;
                                          time18selected = false;
                                        });

                                        // widget.box
                                        //     .get(widget.indexKey)!
                                        //     .isSetTime = false;
                                        // widget.box.put(widget.indexKey,
                                        //     widget.box.get(widget.indexKey)!);
                                      },
                                    ),
                                    TimeOption(
                                      isTakeFocusColor: time7selected,
                                      nameTimeOption: '07:00',
                                      onTap: () {
                                        setState(() {
                                          flg = true;
                                          _selectedTime =
                                              TimeOfDay(hour: 7, minute: 0);
                                          print(_selectedTime);
                                          flgTime = true;
                                          // widget.updateFlgTime!(flgTime);
                                          timeNoneselected = false;
                                          time7selected = true;
                                          time9selected = false;
                                          time10selected = false;
                                          time12selected = false;
                                          time14selected = false;
                                          time16selected = false;
                                          time18selected = false;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TimeOption(
                                      isTakeFocusColor: time9selected,
                                      nameTimeOption: '09:00',
                                      onTap: () {
                                        setState(() {
                                          flg = true;
                                          _selectedTime =
                                              TimeOfDay(hour: 9, minute: 0);
                                          print(_selectedTime);
                                          flgTime = true;
                                          // widget.updateFlgTime!(flgTime);
                                          timeNoneselected = false;
                                          time7selected = false;
                                          time9selected = true;
                                          time10selected = false;
                                          time12selected = false;
                                          time14selected = false;
                                          time16selected = false;
                                          time18selected = false;
                                        });
                                      },
                                    ),
                                    TimeOption(
                                      isTakeFocusColor: time10selected,
                                      nameTimeOption: '10:00',
                                      onTap: () {
                                        setState(() {
                                          flg = true;
                                          _selectedTime =
                                              TimeOfDay(hour: 10, minute: 0);
                                          print(_selectedTime);
                                          flgTime = true;
                                          // widget.updateFlgTime!(flgTime);
                                          timeNoneselected = false;
                                          time7selected = false;
                                          time9selected = false;
                                          time10selected = true;
                                          time12selected = false;
                                          time14selected = false;
                                          time16selected = false;
                                          time18selected = false;
                                        });
                                      },
                                    ),
                                    TimeOption(
                                      isTakeFocusColor: time12selected,
                                      nameTimeOption: '12:00',
                                      onTap: () {
                                        setState(() {
                                          flg = true;
                                          _selectedTime =
                                              TimeOfDay(hour: 12, minute: 0);
                                          print(_selectedTime);
                                          flgTime = true;
                                          // widget.updateFlgTime!(flgTime);
                                          timeNoneselected = false;
                                          time7selected = false;
                                          time9selected = false;
                                          time10selected = false;
                                          time12selected = true;
                                          time14selected = false;
                                          time16selected = false;
                                          time18selected = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TimeOption(
                                      nameTimeOption: '14:00',
                                      isTakeFocusColor: time14selected,
                                      onTap: () {
                                        setState(() {
                                          flg = true;
                                          _selectedTime =
                                              TimeOfDay(hour: 14, minute: 0);
                                          print(_selectedTime);
                                          flgTime = true;
                                          // widget.updateFlgTime!(flgTime);
                                          timeNoneselected = false;
                                          time7selected = false;
                                          time9selected = false;
                                          time10selected = false;
                                          time12selected = false;
                                          time14selected = true;
                                          time16selected = false;
                                          time18selected = false;
                                        });
                                      },
                                    ),
                                    TimeOption(
                                      nameTimeOption: '16:00',
                                      isTakeFocusColor: time16selected,
                                      onTap: () {
                                        setState(() {
                                          flg = true;
                                          _selectedTime =
                                              TimeOfDay(hour: 16, minute: 0);
                                          print(_selectedTime);
                                          flgTime = true;
                                          // widget.updateFlgTime!(flgTime);
                                          timeNoneselected = false;
                                          time7selected = false;
                                          time9selected = false;
                                          time10selected = false;
                                          time12selected = false;
                                          time14selected = false;
                                          time16selected = true;
                                          time18selected = false;
                                        });
                                      },
                                    ),
                                    TimeOption(
                                      nameTimeOption: '18:00',
                                      isTakeFocusColor: time18selected,
                                      onTap: () {
                                        setState(() {
                                          flg = true;
                                          _selectedTime =
                                              TimeOfDay(hour: 18, minute: 0);
                                          print(_selectedTime);
                                          flgTime = true;
                                          // widget.updateFlgTime!(flgTime);
                                          timeNoneselected = false;
                                          time7selected = false;
                                          time9selected = false;
                                          time10selected = false;
                                          time12selected = false;
                                          time14selected = false;
                                          time16selected = false;
                                          time18selected = true;
                                        });
                                        print(pressDone);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20, right: 10),
                            child: Align(
                              alignment: Alignment.bottomRight,
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
                                          color: listColor[myTopic.get('index')]
                                              [3],
                                        ),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        String formattedTime = _selectedTime
                                            .format(context)
                                            .toString();
                                        Navigator.pop(context, formattedTime);
                                        widget.updateTaskTime!(formattedTime);
                                        setState(() {
                                          widget.box
                                              .get(widget.indexKey)
                                              ?.taskTime = formattedTime;
                                          widget.box
                                              .get(widget.indexKey)!
                                              .flgTime = flgTime;
                                          widget.box.put(widget.indexKey,
                                              widget.box.get(widget.indexKey)!);
                                        });
                                        if (flgTime) {
                                          widget.box
                                              .get(widget.indexKey)!
                                              .isSetTime = true;
                                          widget.box.put(widget.indexKey,
                                              widget.box.get(widget.indexKey)!);
                                        } else {
                                          widget.box
                                              .get(widget.indexKey)!
                                              .isSetTime = false;
                                          widget.box.put(widget.indexKey,
                                              widget.box.get(widget.indexKey)!);
                                        }
                                      },
                                      child: Text(
                                        'XONG',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: listColor[myTopic.get('index')]
                                              [0],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          )
                        ]),
                  ),
                ],
              );
            }),
            // height: 500,
          ),
        ),
      ),
    );
  }
}

// class TimeOption1 extends StatelessWidget {
//   final String? nameTimeOption;
//   final void Function()? onTap;
//   Color? boxTimeOptionColor;
//    bool isOptionSelected = false;
//   TimeOption({
//     required this.nameTimeOption,
//     this.onTap,
//     this.boxTimeOptionColor,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//         margin: EdgeInsets.only(right: 15, top: 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           color: boxTimeOptionColor,
//         ),
//         child: Text(
//           nameTimeOption!,
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }

class TimeOption extends StatefulWidget {
  final String? nameTimeOption;
  final void Function()? onTap;
  final bool isTakeFocusColor;
  TimeOption(
      {required this.nameTimeOption,
      this.onTap,
      required this.isTakeFocusColor});
  @override
  _TimeOptionState createState() => _TimeOptionState();
}

class _TimeOptionState extends State<TimeOption> {
  bool isOptionSelected = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 10, color: Colors.red),
      ),
      onPressed: () {
// Gọi hàm onTap được truyền vào từ ngoài TimeOption
        setState(() {});
        widget.onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
        // margin: EdgeInsets.only(right: 15, top: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            // color: isOptionSelected ? Colors.green[200] : Color(0XFFF2F6F7),
            color: widget.isTakeFocusColor == true
                ? listColor[myTopic.get('index')][0]
                : kGreyLight),
        child: Text(
          widget.nameTimeOption!,
          style: TextStyle(
            fontSize: 16,
            // color: kGreyTextOptionLoop,
            color: widget.isTakeFocusColor == true
                ? Colors.white
                : kGreyTextOptionLoop,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

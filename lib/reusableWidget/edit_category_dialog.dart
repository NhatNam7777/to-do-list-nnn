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

class EditCategoryDialogBox extends StatefulWidget {
  // const EditCategoryDialogBox({super.key});
  // int indexKey;
  // // final void Function(String)? updateTaskDate;
  // String taskName;
  // Box<ToDoDataBase> box;
  // EditCategoryDialogBox({
  //   required this.indexKey,
  //   required this.taskName,
  //   required this.box,
  //   // this.updateTaskDate,
  // });
  @override
  State<EditCategoryDialogBox> createState() => _EditCategoryDialogBoxState();
}

class _EditCategoryDialogBoxState extends State<EditCategoryDialogBox> {
  DateTime initDate = DateTime.now();
  DateTime? selectedDay; // Thêm biến selectedDay kiểu DateTime?
  DateTime now = DateTime.now();
  final myBoxCate = Hive.box('categories');
  final addCateController = TextEditingController();
  final myTopic = Hive.box('topicColor');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // DateTime initDate = DateFormat('dd/MM/yyyy')
    //     .parse(widget.box.get(widget.indexKey)!.taskDate ?? '');
    return AlertDialog(
      //Không dùng được BorderRadius của Container trong content của AlertDialog
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Đặt giá trị bo tròn ở đây
      ),

      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 27 / 100,
              width: width * 90 / 100,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                          ),
                          child: Text(
                            'Tạo danh mục mới',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // margin: EdgeInsets.only(top: 15, bottom: 10),
                      height: 85,
                      width: (width * 90 / 100) - 40,
                      child: TextField(
                        maxLength: 50,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          //border dưới
                          border: InputBorder.none,
                          hintText: 'Nhập tại đây',
                          filled: true,
                          fillColor: Color(0XFFF3F7F8),
                          contentPadding:
                              EdgeInsets.only(left: 20, top: 30, bottom: 30),

                          // counterText: '0/100',
                        ),
                        controller: addCateController,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: listColor[myTopic.get('index')][3],
                                ),
                              )),
                          TextButton(
                              onPressed: (() {}),
                              child: Text(
                                'LƯU',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:to_do_list_nhatnam/constants.dart';
import 'package:hive/hive.dart';

class DeleteCate extends StatelessWidget {
  // bool isDelete;
  final ValueSetter<bool> onValueSelected;

  DeleteCate({required this.onValueSelected});
  final myTopic = Hive.box('topicColor');
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),

      // title: Text('Xác nhận'),
      content: Container(
        width: width - 30,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height * 7 / 100,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  'Xóa danh mục?',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 23, 23, 23)),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 18),
              child: Text(
                'Tất cả các nhiệm vụ trong danh mục này sẽ bị xóa',
                style: TextStyle(fontSize: 18, color: kGreyTextOptionLoop),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onValueSelected(false);

            Navigator.of(context).pop(); // Đóng AlertDialog khi nhấn nút Hủy
          },
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
          onPressed: () {
            // Xử lý khi nhấn nút Xóa
            // ...
            onValueSelected(true);
            // isDelete = true;
            Navigator.pop(context); // Đóng AlertDialog khi nhấn nút Xóa
          },
          child: Text(
            'XÓA',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: listColor[myTopic.get('index')][0],
            ),
          ),
        ),
      ],
    );
  }
}

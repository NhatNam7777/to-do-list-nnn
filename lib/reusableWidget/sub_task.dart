// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../constants.dart';

class SubTaskCard extends StatelessWidget {
  final String subTaskName;
  final bool subTaskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function()? editTask;

  SubTaskCard({
    super.key,
    required this.onChanged,
    required this.subTaskCompleted,
    required this.subTaskName,
    required this.deleteFunction,
    required this.editTask,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController myController = TextEditingController();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 5),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(10),
            )
          ],
        ),
        child: GestureDetector(
          onTap: () => editTask?.call(),
          child: Container(
            width: width - 20,
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Checkbox(
                      onChanged: onChanged,
                      value: subTaskCompleted,
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    // child: Container(
                    //   child: Text(
                    //     subTaskName,
                    //     style: ktaskName.copyWith(
                    //       decoration: subTaskCompleted
                    //           ? TextDecoration.lineThrough
                    //           : TextDecoration.none,
                    //     ),
                    //   ),
                    // ),
                    child: TextField(
                      controller: myController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Nhập nhiệm vụ phụ',
                        hintStyle: TextStyle(color: kSubColor, fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomDialog());
                        },
                        child: Image.asset(
                          'lib/assets/icons/priorityFlag.png',
                          width: 25,
                          height: 25,
                        ),
                      ))
                ]),
          ),
        ),
      ),
    );
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

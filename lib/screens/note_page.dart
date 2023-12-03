// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_nhatnam/data/local_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotePage extends StatefulWidget {
  String taskName;
  int index;
  Box<ToDoDataBase> box;

  NotePage({
    required this.taskName,
    required this.index,
    required this.box,
  });

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.box.get(widget.index)!.note != null)
      noteController.text = widget.box.get(widget.index)!.note!;

    // // Khởi tạo TextEditingController
    // // noteController = TextEditingController();

    // // Lấy dữ liệu đã lưu từ local storage hoặc state management (nếu cần thiết)
    // // Ví dụ sử dụng shared_preferences:
    // SharedPreferences.getInstance().then((prefs) {
    //   final savedText = prefs.getString('saved_note_text') ?? '';
    //   setState(() {
    //     noteController.text = savedText;
    //   });
    // });
  }

  final noteController = TextEditingController();
  // @override
  // void dispose() {
  //   // Lưu nội dung của TextField vào biến tạm thời trước khi widget bị hủy
  //   final text = noteController.text;
  //   // Lưu biến tạm thời vào local storage hoặc state management (nếu cần thiết)
  //   // Ví dụ sử dụng shared_preferences:
  //   SharedPreferences.getInstance().then((prefs) {
  //     prefs.setString('saved_note_text', text);
  //   });

  //   noteController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 93, 90, 90),
          ),
          onTap: () {
            widget.box.get(widget.index)!.note = noteController.text;
            widget.box.put(widget.index, widget.box.get(widget.index)!);

            Navigator.pop(
              context,
              noteController.text,
            );
            // Navigator.pop(context),
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 25,
            ),
            child: Text(
              widget.taskName,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextField(
              maxLines: null,
              controller: noteController,
              style: TextStyle(
                color: Color(0XFF4D4D4D),
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Thêm ghi chú',
                  hintStyle: TextStyle(
                      color: Color(0XFF4D4D4D),
                      fontWeight: FontWeight.w400,
                      fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

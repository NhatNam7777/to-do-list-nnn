// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/data/local_database.dart';
import 'package:to_do_list_nhatnam/reusableWidget/calendar_dialog.dart';
import 'package:to_do_list_nhatnam/reusableWidget/delete_dialog.dart';
import 'package:to_do_list_nhatnam/reusableWidget/taskCard.dart';
import 'package:to_do_list_nhatnam/reusableWidget/taskCardStar.dart';
import 'package:to_do_list_nhatnam/screens/task_detail_page.dart';

class StarTasksPage extends StatefulWidget {
  const StarTasksPage({super.key});

  @override
  State<StarTasksPage> createState() => _StarTasksPageState();
}

Box<ToDoDataBase> myBox = Hive.box<ToDoDataBase>('myBox');
Box<ToDoDataBase> myBoxP = Hive.box<ToDoDataBase>('myBoxP');
Box<ToDoDataBase> myBoxF = Hive.box<ToDoDataBase>('myBoxF');
bool isExpandedStar = true;

class _StarTasksPageState extends State<StarTasksPage> {
  //edit
  void editTask(int key, Box<ToDoDataBase> box) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => TaskDetail(
          indexKey: key,
          box: box,
        ),
      ),
    );
  }

//delete
  void deleteTask(int key, Box<ToDoDataBase> box) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteDialog(
          onValueSelected: (value) => {
            if (value)
              {
                box.delete(key),
              }
          },
        );
      },
    );
  }

  void checkBoxChanged(int key, bool? value, Box<ToDoDataBase> box) {
    setState(() {
      // myBox.get(key)!.isCompleted = !myBox.get(key)!.isCompleted!;
      var task = box.get(key)!;
      task.isCompleted = !task.isCompleted!;
      box.put(key, task);
    });
  }

  void showCalendar(int key, Box<ToDoDataBase> box) {
    showDialog(
        context: context,
        builder: (context) {
          return CalendarDialogBox(
            indexKey: key,
            taskName: box.get(key)!.taskName!,
            box: box,
            // updateTaskDate: updateTaskDate,
          );
        });
    // updateDemFuture();
    // updateDemPast();
    // updateDemToday();
  }

  void setStar(int key, Box<ToDoDataBase> box) {
    box.get(key)!.isStar != box.get(key)!.isStar!;
    box.put(key, box.get(key)!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          //like appbar
          Container(
            margin: EdgeInsets.only(left: 20, top: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 20, 17, 17),
                    size: 24,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: Text('Nhiệm vụ sao', style: TextStyle(fontSize: 25)),
                ),
              ],
            ),
          ),
          // GestureDetector(
          //     onTap: () {
          //       print(myBox.get(0)!.isStar);
          //     },
          //     child: Text('hello')),
          //content
          Flexible(
            fit: FlexFit.loose,
            child: ValueListenableBuilder(
              valueListenable: myBox.listenable(),
              builder: (context, Box<ToDoDataBase> box, _) {
                return Container(
                  height: myBox.length * 75,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        //cách gán list kiểu dynamic thành kiểu list<int> sử dụng map và cast
                        // List<int> allKeys = myBox.keys.toList();
                        List<int> allKeys =
                            box.keys.map<int>((key) => key as int).toList();
                        final int key = allKeys[index];
                        final ToDoDataBase toDoTask = box.get(key)!;
                        if (toDoTask == null) {
                          return SizedBox();
                          print('hallo');
                        }
                        if (toDoTask.isStar == false) {
                          return SizedBox();
                        }
                        //NOW
                        return TaskCardStar(
                          editTask: () => editTask(key, box),
                          deleteFunction: (context) => deleteTask(key, box),
                          onChanged: (value) =>
                              checkBoxChanged(key, value, box),
                          taskCompleted: toDoTask.isCompleted ?? false,
                          taskName: toDoTask.taskName ?? '',
                          showCalendar: (context) => showCalendar(key, box),
                          index: key,
                          flgPast: false,
                          box: myBox,
                          iconFlgName: 'priorityFlag',
                          setStar: (context) => setStar(key, box),
                          isStar: toDoTask.isStar ?? false,
                        );
                      }),
                );
              },
            ),
          ),

          Flexible(
            fit: FlexFit.loose,
            child: ValueListenableBuilder(
              valueListenable: myBoxP.listenable(),
              builder: (context, Box<ToDoDataBase> box, _) {
                return Container(
                  height: myBoxP.length * 75,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        //cách gán list kiểu dynamic thành kiểu list<int> sử dụng map và cast
                        // List<int> allKeys = myBoxP.keys.toList();
                        List<int> allKeys =
                            box.keys.map<int>((key) => key as int).toList();
                        final int key = allKeys[index];
                        final ToDoDataBase toDoTask = box.get(key)!;
                        if (toDoTask == null) {
                          return SizedBox();
                          print('hallo');
                        }
                        if (toDoTask.isStar == false) {
                          return SizedBox();
                        }
                        //NOW
                        return TaskCardStar(
                          editTask: () => editTask(key, box),
                          deleteFunction: (context) => deleteTask(key, box),
                          onChanged: (value) =>
                              checkBoxChanged(key, value, box),
                          taskCompleted: toDoTask.isCompleted ?? false,
                          taskName: toDoTask.taskName ?? '',
                          showCalendar: (context) => showCalendar(key, box),
                          index: key,
                          flgPast: false,
                          box: myBoxP,
                          iconFlgName: 'priorityFlag',
                          setStar: (context) => setStar(key, box),
                          isStar: toDoTask.isStar ?? false,
                        );
                      }),
                );
              },
            ),
          ),

          Flexible(
            fit: FlexFit.loose,
            child: ValueListenableBuilder(
              valueListenable: myBoxF.listenable(),
              builder: (context, Box<ToDoDataBase> box, _) {
                return Container(
                  height: myBoxF.length * 75,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        //cách gán list kiểu dynamic thành kiểu list<int> sử dụng map và cast
                        // List<int> allKeys = myBoxF.keys.toList();
                        List<int> allKeys =
                            box.keys.map<int>((key) => key as int).toList();
                        final int key = allKeys[index];
                        final ToDoDataBase toDoTask = box.get(key)!;
                        if (toDoTask == null) {
                          return SizedBox();
                          print('hallo');
                        }
                        if (toDoTask.isStar == false) {
                          return SizedBox();
                        }
                        //NOW
                        return TaskCardStar(
                          editTask: () => editTask(key, box),
                          deleteFunction: (context) => deleteTask(key, box),
                          onChanged: (value) =>
                              checkBoxChanged(key, value, box),
                          taskCompleted: toDoTask.isCompleted ?? false,
                          taskName: toDoTask.taskName ?? '',
                          showCalendar: (context) => showCalendar(key, box),
                          index: key,
                          flgPast: false,
                          box: myBoxF,
                          iconFlgName: 'priorityFlag',
                          setStar: (context) => setStar(key, box),
                          isStar: toDoTask.isStar ?? false,
                        );
                      }),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

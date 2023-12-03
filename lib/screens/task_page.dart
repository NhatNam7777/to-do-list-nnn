// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/data/category_database.dart';
import 'package:to_do_list_nhatnam/data/local_database.dart';
import 'package:to_do_list_nhatnam/data/topic_database.dart';
import 'package:to_do_list_nhatnam/reusableWidget/add_category_dialog.dart';
import 'package:to_do_list_nhatnam/reusableWidget/delete_dialog.dart';
import 'package:to_do_list_nhatnam/reusableWidget/save_dialog.dart';
import 'package:to_do_list_nhatnam/reusableWidget/calendar_dialog.dart';
import 'package:to_do_list_nhatnam/reusableWidget/sort_dialog.dart';
import 'package:to_do_list_nhatnam/screens/calendar_page.dart';
import 'package:to_do_list_nhatnam/screens/home_page.dart';
import 'package:to_do_list_nhatnam/screens/manage_categories.dart';
import 'package:to_do_list_nhatnam/screens/setting_page.dart';
import 'package:to_do_list_nhatnam/screens/star_tasks_page.dart';
import 'package:to_do_list_nhatnam/screens/task_detail_page.dart';
import 'package:to_do_list_nhatnam/screens/topic_page.dart';
import 'package:to_do_list_nhatnam/screens/user_page.dart';
import 'package:to_do_list_nhatnam/services/data_to_everywhere.dart';
import 'package:to_do_list_nhatnam/services/gg_auth.dart';
import 'package:to_do_list_nhatnam/services/notifi_service.dart';
import '../constants.dart';
import '../reusableWidget/reusableListTitleInDrawer.dart';
import 'package:to_do_list_nhatnam/reusableWidget/taskCard.dart';
import 'package:to_do_list_nhatnam/reusableWidget/save_dialog.dart';
import 'package:to_do_list_nhatnam/services/adapter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatefulWidget {
  final String? payLoad;
  TasksPage({this.payLoad});
  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // ToDoDataBase db = ToDoDataBase();
  Category dbcate = Category();
  bool showTopic = false;
  // Box<List<ToDoDataBase>> myBoxNow = Hive.box<List<ToDoDataBase>>('myBoxNow');
  Box<ToDoDataBase> myBox = Hive.box<ToDoDataBase>('myBox');
  Box<ToDoDataBase> myBoxP = Hive.box<ToDoDataBase>('myBoxP');
  Box<ToDoDataBase> myBoxF = Hive.box<ToDoDataBase>('myBoxF');
  Box<Category> myCate = Hive.box<Category>('category');
  final myTopic = Hive.box('topicColor');

  final _controller = TextEditingController();
  bool isExpandedToday = true;
  bool isExpandedPast = true;
  bool isExpandedFuture = true;
  DateTime today = DateTime.now();
  int demPast = 0;
  int demToday = 0;
  int demFuture = 0;
  bool isTemp = false;

  bool boom = false;

  int indexPast = 0;

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onPressed: saveNewTask,
          );
        });
  }

  void saveNewTask() {
    setState(() {
      // List<ToDoDataBase> listOfTasksNow = [];

      // Xác định key cho task mới
      int newTaskKey =
          (myBox.length > 0) ? myBox.keyAt(myBox.length - 1) + 1 : 0;
      // Lấy ngày hôm nay
      DateTime today = DateTime.now();
      // Định dạng ngày thành chuỗi "dd/MM/yyyy"
      String formattedDate = DateFormat('dd/MM/yyyy').format(today);
      TimeOfDay timeNow = TimeOfDay.now();
      String formattedTime = timeNow.format(context).toString();
      // Tạo một phần tử mới
      ToDoDataBase newTask = ToDoDataBase(
        taskName: _controller.text,
        isCompleted: false,
        taskDate: formattedDate,
        taskTime: formattedTime,
        index: newTaskKey,
        flgTime: false,
        note: '',
        isStar: false,
        isPast: false,
        isFuture: false,
        isNow: true,
        isSetLoop: false,
        isSetTime: false,
        isHaveNote: false,
      );

      // Thêm task mới vào Hive Box
      myBox.put(newTaskKey, newTask);
      _controller.clear();
      Navigator.of(context).pop();

      // updateDemToday();
      // updateDemPast();
      // updateDemFuture();

      // db.listOfNowTask.add(newTask);
      // db.updateDataBaseNow();
      // listOfTasksNow.add(newTask);
      // myBox.put('tasksListNow', listOfTasksNow);
    });
  }

  void checkBoxChanged(int key, bool? value, Box<ToDoDataBase> box) {
    setState(() {
      // myBox.get(key)!.isCompleted = !myBox.get(key)!.isCompleted!;
      var task = box.get(key)!;
      task.isCompleted = !task.isCompleted!;
      box.put(key, task);
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
                box.delete(key),
              }
          },
        );
      },
    );
    // print('resultDelete: $resultDelete');
    // if (resultDelete) {
    //   // Xóa phần tử tại index
    //   await box.delete(key);
    // }
    // // Cập nhật lại key của các phần tử phía sau
    // for (int i = index; i < box.length; i++) {
    //   final ToDoDataBase? element = box.get(i + 1);
    //   if (element != null) {
    //     final clonedElement = ToDoDataBase(
    //       taskName: element.taskName,
    //       isCompleted: element.isCompleted,
    //       taskDate: element.taskDate,
    //       taskTime: element.taskTime,
    //       index: element.index,
    //       isStar: element.isStar,
    //       note: element.note,
    //       flgTime: element.flgTime,
    //       // Copy các thuộc tính khác của đối tượng element vào clonedElement
    //     );
    //     clonedElement.index = i;
    //     await box.put(i, clonedElement);
    //     await box.delete(i + 1);
    //   }
    // }

    // updateDemToday();
    // updateDemPast();
    // updateDemFuture();
  }

  void editTask(int key, Box<ToDoDataBase> box) async {
    for (int index = 0; index < myCate.length; index++) {
      List<int> allKeys = myBoxCate.keys.map<int>((key) => key as int).toList();
      final int key = allKeys[index];
      final Category cate = myBoxCate.get(key)!;
    }

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

  void updateTaskDate(String newDate) {
    setState(() {
      myBox.get(indexPast)!.taskDate = newDate;
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

  void deleteTaskNowToPast(bool delTask, key) {
    if (delTask == true) {
      deleteTask(key, myBox);
    }
  }

  // void updateDemPast() {
  //   demPast = 0;
  //   String formattedToday = DateFormat('dd/MM/yyyy').format(today);
  //   for (int i = 0; i < myBox.length; i++) {
  //     ToDoDataBase? task = myBox.get(i);
  //     DateTime formattedToday = DateFormat('dd/MM/yyyy')
  //         .parse(DateFormat('dd/MM/yyyy').format(today));
  //     DateTime taskDate = DateFormat('dd/MM/yyyy').parse(task!.taskDate ?? '');
  //     if (task != null && taskDate.isBefore(formattedToday)) {
  //       demPast++;
  //     }
  //   }
  // }

  // void updateDemToday() {
  //   demToday = 0;
  //   String formattedToday = DateFormat('dd/MM/yyyy').format(today);
  //   for (int i = 0; i < myBox.length; i++) {
  //     if (myBox.get(i) != null) {
  //       ToDoDataBase? task = myBox.get(i);
  //       if (task != null && task.taskDate == formattedToday) {
  //         demToday++;
  //       }
  //     }
  //   }
  // }

  // void updateDemFuture() {
  //   demFuture = 0;
  //   String formattedToday = DateFormat('dd/MM/yyyy').format(today);
  //   //50 = myBox.length
  //   for (int i = 0; i < myBox.length; i++) {
  //     ToDoDataBase? task = myBox.get(i);
  //     DateTime formattedToday = DateFormat('dd/MM/yyyy')
  //         .parse(DateFormat('dd/MM/yyyy').format(today));
  //     DateTime taskDate = DateFormat('dd/MM/yyyy').parse(task!.taskDate ?? '');
  //     if (task != null && taskDate.isAfter(formattedToday)) {
  //       demFuture++;
  //     }
  //   }
  // }

  void showAddCategoryDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AddCategoryDialogBox();
        });
  }

  void setStar(int key, Box<ToDoDataBase> box) {
    setState(() {
      box.get(key)!.isStar = !box.get(key)!.isStar!;
      box.put(key, box.get(key)!);
    });
  }

  @override
  void initState() {
    super.initState();
    // myBox.clear();
    // myBoxP.clear();
    // myBoxF.clear();
    // myBoxCate.clear();
    // setState(() {
    // });
    // Provider.of<DelCurrentTaskAndReplaceByNextTask>(context, listen: false)
    //     .setActionDone(false);
    // if (myCate.get('CATEGORIES') == null) {
    //   print('Data created');
    //   dbcate.createInitialData();
    //   dbcate.updateDataBase();
    // } else {
    //   dbcate.loadData();
    //   print('load data');
    // }

    print('Taskpage init');
  }

  @override
  Widget build(BuildContext context) {
    double? width = MediaQuery.of(context).size.width;
    double? height = MediaQuery.of(context).size.height;
    // bool actionDelTaskRePlaceByNxtTask = false;
    var dataDel = Provider.of<DelCurrentTaskAndReplaceByNextTask>(context);
    setState(() {});
    bool actionDelTaskRePlaceByNxtTask = dataDel.actionDone;

    // bool actionDelTaskRePlaceByNxtTask =
    //     Provider.of<DelCurrentTaskAndReplaceByNextTask>(context).actionDone;
    // isTemp = false;
    // ValueNotifier<List<dynamic>> categoriesNotifier =
    //     ValueNotifier<List<dynamic>>(dbcate.categories);

    return Container(
      //change topic
      // color: Color.fromARGB(255, 37, 90, 88),
      // color: kMainPink,
      // color: kMainBlue,
      // color: kMainOrange,
      color: listColor[myTopic.get('index')][0],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          //Add new task
          floatingActionButton: FloatingActionButton(
            //change topic
            backgroundColor: listColor[myTopic.get('index')][0],

            foregroundColor: Colors.white,
            onPressed: createNewTask,
            child: Icon(Icons.add),
          ),
          key: _scaffoldKey,

          appBar: AppBar(
            toolbarHeight: 70,
            //change topic
            // backgroundColor: Color.fromARGB(255, 34, 140, 135),
            // backgroundColor: kMainPink,
            // backgroundColor: kMainBlue,
            backgroundColor: listColor[myTopic.get('index')][0],
            // foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            title: Text(
              '',
              style: kmainTextColor,
            ),
            leading: IconButton(
              icon: ImageIcon(
                AssetImage('lib/assets/icons/menu-dra.png'),
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            actions: [
              // Icon(
              //   Icons.more_vert,
              //   color: Color.fromARGB(255, 58, 60, 60),
              // ),

              PopupMenuButton<String>(
                icon: Image.asset(
                  'lib/assets/icons/three-dots.png',
                  // height: 10,
                  width: 25,
                  color: Colors.white,
                ),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                position: PopupMenuPosition.under,
                offset: Offset(-18, -5),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'option1',
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageCategory(),
                            // builder: (context) => HomePage(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text('Quản lý danh mục'),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
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

                  PopupMenuItem<String>(
                    value: 'option3',
                    child: GestureDetector(
                      onTap: () => {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SortDialog(
                              onValueSelected: (value) => {
                                // if (value)
                                //   {
                                //     box.delete(key),
                                //   }
                                if (value == '1')
                                  {
                                    setState(() {
                                      isTemp = false;
                                    }),
                                  }
                                else
                                  {
                                    setState(() {
                                      isTemp = true;
                                    }),
                                  }
                              },
                            );
                          },
                        ),
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Text('Sắp xếp công việc'),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
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
                // onValueSelected: (String result) {
                //   if (result == '1') {
                //     setState(() {
                //       isTemp = false;
                //     });
                //   } else {
                //     setState(() {
                //       isTemp = true;
                //     });
                //   }
                // },
              ),
            ],
          ),
          //DRAWER
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                //DRAWER-HEADER
                DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('lib/assets/images/drawer-header.png'),
                        fit: BoxFit.fill),
                  ),
                  child: Container(),
                ),

                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StarTasksPage())),
                  child: reusableListTitleInDrawer(
                    title: 'Nhiệm vụ ưu tiên',
                    iconName: 'star1',
                    //                   color: Color.fromARGB(255, 34, 140, 135),
                    // change topic
                    color: listColor[myTopic.get('index')][0],
                  ),
                ),
                reusableListTitleInDrawer(
                  title: 'Phân loại',
                  iconName: 'category-icon',
                  color: listColor[myTopic.get('index')][0],
                  tail: SizedBox(
                    width: 20,
                    child: IconButton(
                      padding: EdgeInsets.only(left: 0),
                      icon: showTopic == false
                          ? Image.asset(
                              'lib/assets/icons/arrow-point-to-down.png',
                              color: Colors.grey,
                              width: 15)
                          : Image.asset(
                              'lib/assets/icons/arrow-point-to-up.png',
                              color: Colors.grey,
                              width: 15),
                      onPressed: () {
                        setState(() {
                          showTopic = !showTopic;
                        });
                      },
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  color: kSubColor,
                  indent: 15,
                  endIndent: 15,
                ),
                //ALL THE CATEGORY
                if (showTopic)
                  ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,

                          // ignore: prefer_const_literals_to_create_immutables
                          children: <Widget>[
                            ValueListenableBuilder(
                              valueListenable: myCate.listenable(),
                              builder: (context, Box<Category> box, _) {
                                // Xây dựng giao diện người dùng sử dụng danh sách categories
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: myCate.length,
                                    itemBuilder: (context, index) {
                                      List<int> allKeys = myCate.keys
                                          .map<int>((key) => key as int)
                                          .toList();
                                      final int key = allKeys[index];
                                      final Category? cate = box.get(key);
                                      return reusableListTitleInDrawer(
                                        title: cate!.cateName,
                                        iconName: 'paper',
                                        tail: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(cate.numTask.toString()),
                                        ),
                                        color:
                                            Color.fromARGB(255, 164, 167, 170),
                                      );
                                    });
                              },
                            ),
//add category
                            GestureDetector(
                              onTap: () {
                                showAddCategoryDialog();
                              },
                              child: reusableListTitleInDrawer(
                                title: 'Tạo mới',
                                iconName: 'add-category',
                                //                   color: Color.fromARGB(255, 34, 140, 135),
// change topic
                                color: listColor[myTopic.get('index')][0],
                              ),
                            ),
                            // reusableListTitleInDrawer(
                            //   title: 'Tất cả',
                            //   iconName: 'bag',
                            //   tail: Padding(
                            //     padding: const EdgeInsets.only(right: 10),
                            //     child: Text('136'),
                            //   ),
                            //   color: Color(0xffC5CCD2),
                            // ),
                            // reusableListTitleInDrawer(
                            //   title: 'Công việc',
                            //   iconName: 'bag',
                            //   tail: Padding(
                            //     padding: const EdgeInsets.only(right: 10),
                            //     child: Text('23'),
                            //   ),
                            //   color: Color(0xffC5CCD2),
                            // ),
                            // reusableListTitleInDrawer(
                            //   title: 'Cá nhân',
                            //   iconName: 'bag',
                            //   tail: Padding(
                            //     padding: const EdgeInsets.only(right: 10),
                            //     child: Text('0'),
                            //   ),
                            //   color: Color(0xffC5CCD2),
                            // ),
                            // reusableListTitleInDrawer(
                            //   title: 'Đi học',
                            //   iconName: 'bag',
                            //   tail: Padding(
                            //     padding: const EdgeInsets.only(right: 10),
                            //     child: Text('1'),
                            //   ),
                            //   color: Color(0xffC5CCD2),
                            // ),
                            // reusableListTitleInDrawer(
                            //   title: 'Tất cả',
                            //   iconName: 'bag',
                            //   tail: Padding(
                            //     padding: const EdgeInsets.only(right: 10),
                            //     child: Text('136'),
                            //   ),
                            //   color: Color(0xffC5CCD2),
                            // ),
                            // reusableListTitleInDrawer(
                            //   title: 'Công việc',
                            //   iconName: 'bag',
                            //   tail: Padding(
                            //     padding: const EdgeInsets.only(right: 10),
                            //     child: Text('23'),
                            //   ),
                            //   color: Color(0xffC5CCD2),
                            // ),
                            // reusableListTitleInDrawer(
                            //   title: 'Cá nhân',
                            //   iconName: 'bag',
                            //   tail: Padding(
                            //     padding: const EdgeInsets.only(right: 10),
                            //     child: Text('0'),
                            //   ),
                            //   color: Color(0xffC5CCD2),
                            // ),
                            // reusableListTitleInDrawer(
                            //   title: 'Đi học',
                            //   iconName: 'bag',
                            //   tail: Padding(
                            //     padding: const EdgeInsets.only(right: 10),
                            //     child: Text('1'),
                            //   ),
                            //   color: Color(0xffC5CCD2),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TopicPage()),
                  ),
                  child: reusableListTitleInDrawer(
                    title: 'Chủ đề',
                    iconName: 'theme',
                    //                   color: Color.fromARGB(255, 34, 140, 135),
// change topic
                    color: listColor[myTopic.get('index')][0],
                  ),
                ),
                // reusableListTitleInDrawer(
                //   title: 'Tiện ích',
                //   iconName: 'puzzle-icon',
                // ),
                reusableListTitleInDrawer(
                  title: 'Ứng dụng gia đình',
                  iconName: 'app-family',
//                   color: Color.fromARGB(255, 34, 140, 135),
// change topic
                  color: listColor[myTopic.get('index')][0],
                ),
                reusableListTitleInDrawer(
                  title: 'Phản hồi',
                  iconName: 'response',
//                   color: Color.fromARGB(255, 34, 140, 135),
// change topic
                  color: listColor[myTopic.get('index')][0],
                ),
                reusableListTitleInDrawer(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => SettingPage()));

                    AuthService().signOut();
                    AuthService().signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  // title: 'Cài đặt',
                  title: 'Đăng xuất',
                  // iconName: 'setting',
                  iconName: 'logout',
//                   color: Color.fromARGB(255, 34, 140, 135),
// change topic
                  color: listColor[myTopic.get('index')][0],
                ),
                reusableListTitleInDrawer(
                  title: 'Nâng cấp tính năng Pro',
                  iconName: 'crown-hand',
                  // color: Color.fromARGB(255, 34, 140, 135),
                ),
                // ListTile(
                //   leading: Icon(Icons.message),
                //   title: Text('Chủ đề'),
                //   trailing: IconButton(
                //     icon: Icon(
                //       Icons.waves,
                //       color: kmainIconColor,
                //     ),
                //     onPressed: () => topic(),
                //   ),
                // ),
                // ListTile(
                //   leading: Icon(Icons.account_circle),
                //   title: Text('Profile'),
                //   trailing: Text('0'),
                // ),
                // ListTile(
                //   leading: Icon(Icons.settings),
                //   title: Text('Settings'),
                //   trailing: Text('0'),
                // ),
              ],
            ),
          ),

          //BODY
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //NOW
                Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 20, left: 10),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpandedToday = !isExpandedToday;
                        });
                      },
                      child: isExpandedToday
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Hôm nay',
                                  style: TextStyle(
                                      color: Color(0XFF474C4C),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                    'lib/assets/icons/arrow-point-to-up.png',
                                    color: Colors.grey,
                                    width: 15)
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Hôm nay',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                    'lib/assets/icons/arrow-point-to-down.png',
                                    color: Colors.grey,
                                    width: 15)
                              ],
                            )),
                ),
                // GestureDetector(
                //   child: Text('ttt date'),
                //   onTap: () {
                //     print(myBox.get(0)!.category);
                //   },
                // ),
                //NOW
                Flexible(
                  fit: FlexFit.loose,
                  child: ValueListenableBuilder(
                    valueListenable: myBox.listenable(),
                    builder: (context, Box<ToDoDataBase> box, _) {
                      if (isExpandedToday) {
                        return Container(
                          height: myBox.length * 75,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: box.length,
                              itemBuilder: (context, index) {
                                //cách gán list kiểu dynamic thành kiểu list<int> sử dụng map và cast
                                // List<int> allKeys = myBox.keys.toList();
                                List<int> allKeys = box.keys
                                    .map<int>((key) => key as int)
                                    .toList();
                                if (isTemp == true) {
                                  allKeys = allKeys.reversed.toList();
                                }
                                // / Đảo ngược danh sách các task
                                final int key = allKeys[index];
                                final ToDoDataBase toDoTask = box.get(key)!;
                                if (toDoTask == null) {
                                  return SizedBox();
                                }

                                // DateTime today = DateTime.now();
                                // // Kiểm tra ngày của task
                                // DateTime taskDate = DateFormat('dd/MM/yyyy')
                                //     .parse(toDoTask.taskDate ?? '');
                                // if (taskDate.isBefore(today) ||
                                //     taskDate.isAfter(today)) {
                                //   // Nếu taskDate sau ngày hôm nay, không hiển thị
                                //   return SizedBox();
                                // }
                                String formattedToday =
                                    DateFormat('dd/MM/yyyy').format(today);
                                if (toDoTask.taskDate != formattedToday) {
                                  // Nếu ngày của task không trùng với ngày hôm nay, không hiển thị
                                  return SizedBox();
                                }
                                // deleteTaskNowToPast(
                                //     actionDelTaskRePlaceByNxtTask, index);
                                if (toDoTask.isPast == true ||
                                    toDoTask.isFuture == true) {
                                  // box.deleteAt(index);
                                  box.delete(key);
                                  // return SizedBox();
                                }
                                //NOW
                                return TaskCard(
                                  editTask: () => editTask(key, box),
                                  deleteFunction: (context) =>
                                      deleteTask(key, box),
                                  onChanged: (value) =>
                                      checkBoxChanged(key, value, box),
                                  taskCompleted: toDoTask.isCompleted ?? false,
                                  taskName: toDoTask.taskName ?? '',
                                  showCalendar: (context) =>
                                      showCalendar(key, box),
                                  index: key,
                                  flgPast: false,
                                  box: myBox,
                                  iconFlgName: 'priorityFlag',
                                  setStar: (context) => setStar(key, box),
                                  isStar: toDoTask.isStar ?? false,
                                );
                              }),
                        );
                      } else
                        return SizedBox();
                    },
                  ),
                ),

                //PAST
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 10),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpandedPast = !isExpandedPast;
                        });
                      },
                      child: isExpandedPast
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Trước',
                                  style: TextStyle(
                                      color: Color(0XFF474C4C),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                    'lib/assets/icons/arrow-point-to-up.png',
                                    color: Colors.grey,
                                    width: 15)
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Trước',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                    'lib/assets/icons/arrow-point-to-down.png',
                                    color: Colors.grey,
                                    width: 15)
                              ],
                            )),
                ),
                if (isExpandedPast)
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
                                    // List<int> allKeys = myBox.keys.toList();
                                    List<int> allKeys = box.keys
                                        .map<int>((key) => key as int)
                                        .toList();
                                    final int key = allKeys[index];
                                    final ToDoDataBase? toDoTask = box.get(key);
                                    if (toDoTask == null) {
                                      return SizedBox(); // Hoặc bạn có thể thay bằng Widget khác tùy ý
                                    }
                                    if (toDoTask.isNow == true ||
                                        toDoTask.isFuture == true) {
                                      myBoxP.delete(key);
                                      // return SizedBox();
                                    }
                                    //need
                                    // Kiểm tra ngày của task
                                    DateTime formattedToday =
                                        DateFormat('dd/MM/yyyy').parse(
                                            DateFormat('dd/MM/yyyy')
                                                .format(today));
                                    DateTime taskDate = DateFormat('dd/MM/yyyy')
                                        .parse(toDoTask.taskDate ?? '');
                                    if (taskDate.isAfter(formattedToday) ||
                                        taskDate
                                            .isAtSameMomentAs(formattedToday)) {
                                      // Nếu taskDate sau hoặc là hôm nay, không hiển thị
                                      box.delete(key);
                                      return SizedBox();
                                    }
                                    //need

                                    // void updateTaskDate(String newDate) {
                                    //   setState(() {
                                    //     myBox.get(index)!.taskDate = newDate;
                                    //   });
                                    // }

                                    //PAST
                                    return TaskCard(
                                      taskName: toDoTask.taskName ?? '',
                                      taskCompleted:
                                          toDoTask.isCompleted ?? false,
                                      onChanged: (value) =>
                                          checkBoxChanged(key, value, box),
                                      deleteFunction: (context) =>
                                          deleteTask(key, box),
                                      editTask: () => editTask(
                                        key,
                                        box,
                                      ),
                                      showCalendar: (context) =>
                                          showCalendar(key, box),
                                      flgPast: true,
                                      index: key,
                                      box: myBoxP,
                                      setStar: (context) => setStar(key, box),
                                      isStar: toDoTask.isStar ?? false,
                                    );
                                  }),
                            );
                          })),

                //FUTURE
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 10),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpandedFuture = !isExpandedFuture;
                        });
                      },
                      child: isExpandedFuture
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Tương lai',
                                  style: TextStyle(
                                      color: Color(0XFF474C4C),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                    'lib/assets/icons/arrow-point-to-up.png',
                                    color: Colors.grey,
                                    width: 15)
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Tương lai',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                    'lib/assets/icons/arrow-point-to-down.png',
                                    color: Colors.grey,
                                    width: 15)
                              ],
                            )),
                ),
                if (isExpandedFuture)
                  Flexible(
                      fit: FlexFit.loose,
                      child: ValueListenableBuilder(
                        valueListenable: myBoxF.listenable(),
                        builder: (context, Box<ToDoDataBase> box, _) {
                          return Container(
                            height: myBoxF.length * 75,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: myBoxF.length,
                                itemBuilder: (context, index) {
                                  //cách gán list kiểu dynamic thành kiểu list<int> sử dụng map và cast
                                  // List<int> allKeys = myBox.keys.toList();
                                  List<int> allKeys = box.keys
                                      .map<int>((key) => key as int)
                                      .toList();
                                  final int key = allKeys[index];
                                  final ToDoDataBase? toDoTask = box.get(key);
                                  if (toDoTask == null) {
                                    return SizedBox(); // Hoặc bạn có thể thay bằng Widget khác tùy ý
                                  }
                                  // Kiểm tra ngày của task
                                  DateTime formattedToday =
                                      DateFormat('dd/MM/yyyy').parse(
                                          DateFormat('dd/MM/yyyy')
                                              .format(today));
                                  DateTime taskDate = DateFormat('dd/MM/yyyy')
                                      .parse(toDoTask.taskDate ?? '');
                                  if (taskDate.isBefore(formattedToday) ||
                                      taskDate
                                          .isAtSameMomentAs(formattedToday)) {
                                    // Nếu taskDate sau hoặc là hôm nay, không hiển thị
                                    return SizedBox();
                                  }

                                  if (toDoTask.isNow == true ||
                                      toDoTask.isPast == true) {
                                    myBoxF.delete(key);
                                    // return SizedBox();
                                  }
                                  //FUTURE
                                  return TaskCard(
                                    editTask: () => editTask(key, box),
                                    deleteFunction: (context) =>
                                        deleteTask(key, box),
                                    onChanged: (value) =>
                                        checkBoxChanged(key, value, box),
                                    taskCompleted:
                                        toDoTask.isCompleted ?? false,
                                    taskName: toDoTask.taskName ?? '',
                                    showCalendar: (context) =>
                                        showCalendar(index, box),
                                    flgPast: true,
                                    index: key,
                                    box: myBoxF,
                                    setStar: (context) => setStar(key, box),
                                    isStar: toDoTask.isStar ?? false,
                                  );
                                }),
                          );
                        },
                      )),

                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<ListTile> topic() {
  return [
    ListTile(
      leading: Icon(Icons.message),
      title: Text('Messages'),
      trailing: Text('0'),
    ),
    ListTile(
      leading: Icon(Icons.account_circle),
      title: Text('Profiled'),
      trailing: Text('0'),
    ),
    ListTile(
      leading: Icon(Icons.settings),
      title: Text('Settings'),
      trailing: Text('0'),
    ),
  ];
}

class TimeSubtractionScreen extends StatefulWidget {
  @override
  _TimeSubtractionScreenState createState() => _TimeSubtractionScreenState();
}

class _TimeSubtractionScreenState extends State<TimeSubtractionScreen> {
  TextEditingController _timeInputController = TextEditingController();
  String _result = '';

  void _subtractTime() {
    DateTime now = DateTime.now();
    DateTime selectedTime = DateTime.parse(_timeInputController.text);
    Duration difference = selectedTime.difference(now);

    setState(() {
      _result =
          'Khoảng thời gian: ${difference.inDays} ngày, ${difference.inHours % 24} giờ, ${difference.inMinutes % 60} phút';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trừ giờ')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _timeInputController,
                decoration: InputDecoration(
                    labelText: 'Nhập thời điểm (YYYY-MM-DD HH:mm)'),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _subtractTime,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('Trừ giờ', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 20),
              Text(_result, style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

// List<List<Color>> listColor = [
//   [
//     kMainOrange,
//     kUpOrangeLight,
//     kOrangelight,
//     kHuyOrange,
//     kProOrangeCardUser,
//   ],
//   [
//     kMainPink,
//     kUpPinkLight,
//     kPinklight,
//     kHuyPink,
//     kProPinkCardUser,
//   ],
// ];

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/constants.dart';
import 'package:to_do_list_nhatnam/data/category_database.dart';
import 'package:to_do_list_nhatnam/data/local_database.dart';
import 'package:to_do_list_nhatnam/reusableWidget/add_category_dialog.dart';
import 'package:to_do_list_nhatnam/reusableWidget/delete_category.dart';
import 'package:to_do_list_nhatnam/reusableWidget/delete_dialog.dart';
import 'package:to_do_list_nhatnam/reusableWidget/edit_category_dialog.dart';
import 'package:to_do_list_nhatnam/screens/home_page.dart';
import 'package:to_do_list_nhatnam/screens/star_tasks_page.dart';

class ManageCategory extends StatefulWidget {
  const ManageCategory({super.key});

  @override
  State<ManageCategory> createState() => _ManageCategoryState();
}

Box<Category> myBoxCate = Hive.box<Category>('category');
Box<ToDoDataBase> myBox = Hive.box<ToDoDataBase>('myBox');
Box<ToDoDataBase> myBoxP = Hive.box<ToDoDataBase>('myBoxP');
Box<ToDoDataBase> myBoxF = Hive.box<ToDoDataBase>('myBoxF');
final myTopic = Hive.box('topicColor');
// ValueNotifier<Category?> categoryNotifier = ValueNotifier<Category?>(null);
int callBuild = 0;

class _ManageCategoryState extends State<ManageCategory> {
  void showEditCategories(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return EditCategoryDialogBox();
        });
  }

  // void deleteCate(int key) {
  //   // for ( int i = 0; i< dbcate.categories.length; i++) {
  //   myBoxCate.delete(key);
  //   print('deleted');

  //   // }
  // }

  void deleteCate(int keyIndex, Box<Category> box) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteCate(
          onValueSelected: (value) {
            if (value) {
              setState(() {});

              String cateName = box.get(keyIndex)?.cateName ?? 'null';
              //delete now
              for (int index = 0; index < myBox.length; index++) {
                List<int> allKeys =
                    myBox.keys.map<int>((key) => key as int).toList();
                final int key = allKeys[index];
                final ToDoDataBase task = myBox.get(key)!;
                if (task.category != null && task.category == cateName) {
                  myBox.delete(key);
                  // print('Task cate: ' + task.category!);
                  // print(' cate Name: ' + cateName);
                }
              }
              //delete past
              for (int index = 0; index < myBoxP.length; index++) {
                List<int> allKeys =
                    myBoxP.keys.map<int>((key) => key as int).toList();
                final int key = allKeys[index];
                final ToDoDataBase task = myBoxP.get(key)!;
                if (task.category == box.get(keyIndex)!.cateName) {
                  myBoxP.delete(key);
                  // myBox.put(key, task);
                }
              }

              //delete future
              for (int index = 0; index < myBoxF.length; index++) {
                List<int> allKeys =
                    myBoxF.keys.map<int>((key) => key as int).toList();
                final int key = allKeys[index];
                final ToDoDataBase task = myBoxF.get(key)!;
                if (task.category == box.get(keyIndex)!.cateName) {
                  myBoxF.delete(key);

                  // myBox.put(key, task);
                }
              }
              box.delete(keyIndex);
            }
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // if (myBoxCate.get('CATEGORIES') == null) {
    //   print('Data created');
    //   dbcate.createInitialData();
    //   dbcate.updateDataBase();
    // } else {
    //   dbcate.loadData();
    //   print('load data');
    // }
  }

  @override
  Widget build(BuildContext context) {
    void showAddCategoryDialog() {
      showDialog(
          context: context,
          builder: (context) {
            return AddCategoryDialogBox(
                // indexKey: widget.indexKey,
                // updateTaskTime: updateTaskTime,
                // timeFromDetailPage: widget.box.get(widget.indexKey)!.taskTime ?? '',
                // updateFlgTime: updateFlgTime,
                );
          });
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý Danh mục'),
        backgroundColor: listColor[myTopic.get('index')][0],
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: SingleChildScrollView(
        reverse: false,
        child: Column(children: [
          //header
          Container(
            height: 40,
            width: width,
            //change topic
            // color: Color(0XFFDCEEED),
            color: listColor[myTopic.get('index')][1],

            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Các danh mục hiển thị trên trang chủ',
                style: TextStyle(color: kGreyTextOptionLoop),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          //category

          // Xây dựng giao diện người dùng sử dụng danh sách categories
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: myBoxCate.length,
              itemBuilder: (context, index) {
                List<int> allKeys =
                    myBoxCate.keys.map<int>((key) => key as int).toList();
                final int key = allKeys[index];
                final Category? cate = myBoxCate.get(key);
                return ManageCateCard(
                  width: width,
                  cateName: cate!.cateName,
                  numTaskCate: cate.numTask,
                  showEditCategories: () => showEditCategories(context),
                  onTap: () => deleteCate(key, myBoxCate),
                );
              }),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 5,
              ),
              Image.asset(
                'lib/assets/icons/add-category.png',
                width: 23,
                color: listColor[myTopic.get('index')][0],
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  showAddCategoryDialog();
                },
                child: Text(
                  'Tạo mới',
                  style: TextStyle(
                      color: listColor[myTopic.get('index')][0],
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}

class ManageCateCard extends StatelessWidget {
  final double width;
  String? cateName;
  int? numTaskCate;
  // // final void Function(String)? updateTaskDate
  final void Function()? showEditCategories;
  void Function()? onTap;
  ManageCateCard(
      {required this.width,
      this.cateName,
      this.numTaskCate,
      this.showEditCategories,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          height: 100,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: listColor[myTopic.get('index')][0],
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    child: Text(
                      cateName ?? 'Null',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Text(
                      numTaskCate.toString(),
                      style:
                          TextStyle(fontSize: 20, color: kGreyTextOptionLoop),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     margin: EdgeInsets.only(right: 10, left: 30),
                  //     child: Image.asset(
                  //       'lib/assets/icons/three-dots.png',
                  //       height: 24,
                  //       color: Colors.grey.shade700,
                  //     ),
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: PopupMenuButton<String>(
                      icon: Image.asset(
                        'lib/assets/icons/three-dots.png',
                        // height: 10,
                        height: 26,

                        color: kGreyTextOptionLoop,
                      ),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      position: PopupMenuPosition.under,
                      offset: Offset(-25, 5),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'option1',
                          child: GestureDetector(
                            onTap: showEditCategories!,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Chỉnh sửa'),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        //hive category
                        // PopupMenuItem<String>(
                        //   value: 'option2',
                        //   child: Column(
                        //     children: [
                        //       SizedBox(
                        //         height: 15,
                        //       ),
                        //       GestureDetector(
                        //         child: Text('Ẩn giấu'),
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
                              // setState(() {
                              //   isTemp = !isTemp;
                              // })
                              // // isTemp = !isTemp,
                            },
                            child: GestureDetector(
                              onTap: onTap,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text('Xóa'),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                      onSelected: (String result) {
                        // Xử lý khi người dùng chọn một tùy chọn từ danh sách
                        print('Selected: $result');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

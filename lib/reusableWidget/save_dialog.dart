// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/constants.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController controller;
  DialogBox({super.key, required this.controller, required this.onPressed});
  final Function()? onPressed;
  final myTopic = Hive.box('topicColor');
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),

      child: AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                16.0), // Thay đổi giá trị để điều chỉnh radius
          ),
          // backgroundColor: Color(0xFF1F6F9),
          backgroundColor: Color(0XFFFDFFFE),
          content: Container(
            // color: Color(0xFDBDFEA),
            width: width * 80 / 100,
            height: 170,
            child: Column(children: [
              // ignore: prefer_const_constructors
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 10),
                height: 85,
                width: (width * 80 / 100) * 90 / 100,
                child: TextField(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    //border dưới
                    border: InputBorder.none,
                    hintText: 'Nhập nhiệm vụ mới tại đây',
                    hintStyle: TextStyle(fontSize: 16),
                    filled: true,
                    fillColor: Color(0XFFF3F7F8),
                    contentPadding:
                        EdgeInsets.only(left: 20, top: 30, bottom: 30),
                  ),
                  controller: controller,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick category
                  PopupMenuButton<String>(
                    child: Container(
                      child: Text(
                        'Không có thể loại',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.grey.shade200),
                    ),
                    elevation: 30,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    position: PopupMenuPosition.under,
                    offset: Offset(10, 15),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'option1',
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('Tất cả'),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'option2',
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              child: Text('Công việc'),
                              onTap: () => print(''),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),

                      PopupMenuItem<String>(
                        value: 'option3',
                        child: GestureDetector(
                          onTap: () => {},
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text('Cá nhân'),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'option4',
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              child: Text('Trường học'),
                              onTap: () => print(''),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),

                      PopupMenuItem<String>(
                        value: 'option5',
                        child: GestureDetector(
                          onTap: () => {},
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text('Danh sách yêu thích'),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'option6',
                        child: GestureDetector(
                          onTap: () => {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                      'lib/assets/icons/add-category.png',
                                      width: 20,
                                      color: kGreyTextOptionLoop),
                                  Text(
                                    'Tạo mới',
                                    style: TextStyle(
                                      color: listColor[myTopic.get('index')][0],
                                    ),
                                  ),
                                ],
                              ),
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
                  ),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          //change topic
                          // backgroundColor: Color(0XFF4DA8A3),
                          // backgroundColor: kMainPink,
                          backgroundColor: listColor[myTopic.get('index')][0],
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(100), // Set border radius
                          ),
                        ),
                        onPressed: onPressed,
                        // child: Image.asset(
                        //   'lib/assets/icons/arrow-up-icon.png',
                        //   width: 50,
                        //   height: 50,
                        // ),
                        child: Icon(
                          Icons.check,
                          size: 20,
                        )),
                  )
                ],
              ),
            ]),
          )),
    );
  }
}

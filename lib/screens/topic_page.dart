// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:to_do_list_nhatnam/data/topic_database.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/screens/home_page.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({super.key});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

// bool selectedTopic = true;
// bool selectedTopic1 = false;

// bool selectedTopic2 = false;

// bool selectedTopic3 = false;

// bool selectedTopic4 = false;

// bool selectedTopic5 = false;
// bool selectedTopic6 = false;

// bool selectedTopic7 = false;
final myTopic = Hive.box('topicColor');
TopicColor db = TopicColor();

class _TopicPageState extends State<TopicPage> {
  @override
  Widget build(BuildContext context) {
    double? width = MediaQuery.of(context).size.width;
    double? height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text('Chủ đề'),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  print('color index:' + myTopic.get('index').toString());
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text(
                    'ÁP DỤNG',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Colors.blue[400],
                  ),
                ),
              ),
            ),
          ],
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              Center(
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'lib/assets/images/topic-color${myTopic.get('index') + 1}.png',
                      width: width * 70 / 100,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 30, bottom: 15),
                child: Text(
                  'Nhấn để chọn chủ đề',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    //màu 1
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                          // myBox.get(key)!.isCompleted = !myBox.get(key)!.isCompleted!;
                          // selectedTopic = true;

                          // selectedTopic1 = false;

                          // selectedTopic2 = false;

                          // selectedTopic3 = false;

                          // selectedTopic4 = false;

                          // selectedTopic5 = false;

                          // selectedTopic6 = false;

                          // selectedTopic7 = false;
                          db.picked = 0;
                          db.updatePicked();
                          // myTopic.get(0)!.colorIndexPicked = 0;
                          // myTopic.put(0, myTopic.get(0)!);
                          // print('selectedTopic: $selectedTopic');
                        }),
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: width * 16 / 100,
                            height: width * 16 / 100,
                            child: Text(''),
                            decoration: BoxDecoration(
                                color: Color(0XFF1C997F),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          if (myTopic.get('index') == 0)
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: Image.asset(
                                  'lib/assets/icons/choose.png',
                                  width: 30,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    //màu 2
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                          // myBox.get(key)!.isCompleted = !myBox.get(key)!.isCompleted!;
                          // selectedTopic = false;

                          // selectedTopic1 = true;

                          // selectedTopic2 = false;

                          // selectedTopic3 = false;

                          // selectedTopic4 = false;

                          // selectedTopic5 = false;

                          // selectedTopic6 = false;

                          // selectedTopic7 = false;
                          db.picked = 1;
                          db.updatePicked();
                          // myTopic.get(0)?.colorIndexPicked = 1;
                          // myTopic.put(0, myTopic.get(0)!);
                        }),
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: width * 16 / 100,
                            height: width * 16 / 100,
                            child: Text(''),
                            decoration: BoxDecoration(
                                color: Color(0XFFEF89AA),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          // if (selectedTopic1 == true)
                          if (myTopic.get('index') == 1)
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: Image.asset(
                                  'lib/assets/icons/choose.png',
                                  width: 30,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    //màu 3
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                          // myBox.get(key)!.isCompleted = !myBox.get(key)!.isCompleted!;
                          // selectedTopic = false;

                          // selectedTopic1 = false;

                          // selectedTopic2 = true;

                          // selectedTopic3 = false;

                          // selectedTopic4 = false;

                          // selectedTopic5 = false;

                          // selectedTopic6 = false;

                          // selectedTopic7 = false;

                          db.picked = 2;
                          db.updatePicked();
                          // myTopic.get(0)!.colorIndexPicked = 2;
                          // myTopic.put(0, myTopic.get(0)!);
                        }),
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: width * 16 / 100,
                            height: width * 16 / 100,
                            child: Text(''),
                            decoration: BoxDecoration(
                                color: Color(0XFF7DABF6),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          // if (selectedTopic2 == true)
                          if (myTopic.get('index') == 2)
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: Image.asset(
                                  'lib/assets/icons/choose.png',
                                  width: 30,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    //màu 4
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                          // myBox.get(key)!.isCompleted = !myBox.get(key)!.isCompleted!;
                          // selectedTopic = false;

                          // selectedTopic1 = false;

                          // selectedTopic2 = false;

                          // selectedTopic3 = true;

                          // selectedTopic4 = false;

                          // selectedTopic5 = false;

                          // selectedTopic6 = false;

                          // selectedTopic7 = false;
                          db.picked = 3;
                          db.updatePicked();
                        }),
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: width * 16 / 100,
                            height: width * 16 / 100,
                            child: Text(''),
                            decoration: BoxDecoration(
                                color: Color(0XFFDE6768),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          // if (selectedTopic3 == true)
                          if (myTopic.get('index') == 3)
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: Image.asset(
                                  'lib/assets/icons/choose.png',
                                  width: 30,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    //màu 5
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                          // myBox.get(key)!.isCompleted = !myBox.get(key)!.isCompleted!;
                          // selectedTopic = false;

                          // selectedTopic1 = false;

                          // selectedTopic2 = false;

                          // selectedTopic3 = false;

                          // selectedTopic4 = true;

                          // selectedTopic5 = false;

                          // selectedTopic6 = false;

                          // selectedTopic7 = false;
                          db.picked = 4;
                          db.updatePicked();
                        }),
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: width * 16 / 100,
                            height: width * 16 / 100,
                            child: Text(''),
                            decoration: BoxDecoration(
                                color: Color(0XFFF9C93A),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          // if (selectedTopic4 == true)
                          if (myTopic.get('index') == 4)
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: Image.asset(
                                  'lib/assets/icons/choose.png',
                                  width: 30,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    //màu 6
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                          // myBox.get(key)!.isCompleted = !myBox.get(key)!.isCompleted!;
                          // selectedTopic = false;

                          // selectedTopic1 = false;

                          // selectedTopic2 = false;

                          // selectedTopic3 = false;

                          // selectedTopic4 = false;

                          // selectedTopic5 = true;

                          // selectedTopic6 = false;

                          // selectedTopic7 = false;

                          db.picked = 5;
                          db.updatePicked();
                        }),
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: width * 16 / 100,
                            height: width * 16 / 100,
                            child: Text(''),
                            decoration: BoxDecoration(
                                color: Color(0XFF4DA8A3),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          // if (selectedTopic5 == true)
                          if (myTopic.get('index') == 5)
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: Image.asset(
                                  'lib/assets/icons/choose.png',
                                  width: 30,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    //màu 7
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                          // myBox.get(key)!.isCompleted = !myBox.get(key)!.isCompleted!;
                          // selectedTopic = false;

                          // selectedTopic1 = false;

                          // selectedTopic2 = false;

                          // selectedTopic3 = false;

                          // selectedTopic4 = false;

                          // selectedTopic5 = false;

                          // selectedTopic6 = true;

                          // selectedTopic7 = false;

                          db.picked = 6;
                          db.updatePicked();
                        }),
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: width * 16 / 100,
                            height: width * 16 / 100,
                            child: Text(''),
                            decoration: BoxDecoration(
                                color: Color(0XFFF59058),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          // if (selectedTopic6 == true)
                          if (myTopic.get('index') == 6)
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: Image.asset(
                                  'lib/assets/icons/choose.png',
                                  width: 30,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    //màu 8
                    GestureDetector(
                      onTap: () => {
                        setState(() {
                          // myBox.get(key)!.isCompleted = !myBox.get(key)!.isCompleted!;
                          // selectedTopic = false;

                          // selectedTopic1 = false;

                          // selectedTopic2 = false;

                          // selectedTopic3 = false;

                          // selectedTopic4 = false;

                          // selectedTopic5 = false;

                          // selectedTopic6 = false;

                          // selectedTopic7 = true;
                          db.picked = 7;
                          db.updatePicked();
                        }),
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: width * 16 / 100,
                            height: width * 16 / 100,
                            child: Text(''),
                            decoration: BoxDecoration(
                                color: Color(0XFF9556DD),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          // if (selectedTopic7 == true)
                          if (myTopic.get('index') == 7)
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: Image.asset(
                                  'lib/assets/icons/choose.png',
                                  width: 30,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

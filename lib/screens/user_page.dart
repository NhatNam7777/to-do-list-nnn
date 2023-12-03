// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:to_do_list_nhatnam/constants.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_list_nhatnam/services/gg_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/data/local_database.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  GlobalKey<_UserPageState> userPageKey = GlobalKey<_UserPageState>();
  Box<ToDoDataBase> myBox = Hive.box<ToDoDataBase>('myBox');

  Box<ToDoDataBase> myBoxP = Hive.box<ToDoDataBase>('myBoxP');
  Box<ToDoDataBase> myBoxF = Hive.box<ToDoDataBase>('myBoxF');
  final myTopic = Hive.box('topicColor');

  int demNow = 0;
  int demPast = 0;
  int demNowNot = 0;
  int demPastNot = 0;
  int demNotDoned = 0;
  int demDoned = 0;
  int totalNTaskNum() {
    return myBox.length;
  }

  void countDonedTaskAndNotInNow() {
    List<int> allKeys = myBox.keys.map<int>((key) => key as int).toList();
    for (int i = 0; i < allKeys.length; i++) {
      final int key = allKeys[i];
      final ToDoDataBase? toDoTask = myBox.get(key);
      if (toDoTask!.isCompleted!) demNow++;
      if (toDoTask.isCompleted! == false) demNowNot++;
    }
    demDoned += demNow;
    demNotDoned += demNowNot;
  }

  void countDonedTaskAndNotInPast() {
    List<int> allKeys = myBoxP.keys.map<int>((key) => key as int).toList();
    for (int i = 0; i < allKeys.length; i++) {
      final int key = allKeys[i];
      final ToDoDataBase? toDoTask = myBoxP.get(key);
      if (toDoTask!.isCompleted!) demPast++;
      if (toDoTask.isCompleted! == false) demPastNot++;
    }
    demDoned += demPast;
    demNotDoned += demPastNot;
  }

  int finishedTaskNum() {
    int dem = 0;
    for (int i = 0; i < myBox.length; i++) {
      if (myBox.get(i)?.isCompleted == true) dem++;
    }
    return dem;
  }

  int unfinishedTaskNum() {
    int dem = 0;
    for (int i = 0; i < myBox.length; i++) {
      if (myBox.get(i)?.isCompleted == false) dem++;
    }
    return dem;
  }

  // Box<List<ToDoDataBase>> myBoxNow = Hive.box<List<ToDoDataBase>>('myBoxNow');

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<Color> colorChart = [
      //change topic
      // kMainOrange,
      // Color.fromARGB(255, 253, 188, 89)
      listColor[myTopic.get('index')][0],
      listColor[myTopic.get('index')][2]
    ];
    countDonedTaskAndNotInNow();
    countDonedTaskAndNotInPast();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        //User Picture
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                          child: GestureDetector(
                            onTap: () => AuthService().signInWithGoogle(),
                            child: ClipOval(
                              child: Container(
                                height: 65,
                                width: 65,
                                child: CircleAvatar(
                                    child: StreamBuilder<User?>(
                                  stream:
                                      FirebaseAuth.instance.authStateChanges(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<User?> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // Trạng thái kết nối đang chờ
                                      return CircularProgressIndicator();
                                    } else {
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        // Người dùng đã đăng nhập và có dữ liệu
                                        final user = snapshot.data!;
                                        if (user.photoURL != null) {
                                          // Tên người dùng có sẵn
                                          return Image.network(
                                              FirebaseAuth.instance.currentUser!
                                                      .photoURL ??
                                                  '',
                                              height: 65,
                                              width: 65);
                                        } else {
                                          // Tên người dùng không có sẵn
                                          return Container(
                                            height: 65,
                                            width: 65,
                                            child: Image.asset(
                                              'lib/assets/icons/user-page.png',
                                            ),
                                          );
                                        }
                                      } else {
                                        // Người dùng chưa đăng nhập hoặc không có dữ liệu
                                        return Container(
                                          height: 65,
                                          width: 65,
                                          color: listColor[myTopic.get('index')]
                                              [1],
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 0,
                                                bottom: 0,
                                                right: 0,
                                                left: 0,
                                                child: Transform.scale(
                                                  scale:
                                                      0.5, // Tỷ lệ thu nhỏ hình ảnh
                                                  child: Image.asset(
                                                    'lib/assets/icons/user-page.png',
                                                    color: kSubColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  },
                                )
                                    // Image.asset(
                                    //   // 'lib/assets/icons/task-icon.png',
                                    //   'lib/assets/icons/me.jpg',
                                    //   // scale: 1,
                                    // ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        //User Greeting
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chào ngày mới',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),

                              StreamBuilder<User?>(
                                stream:
                                    FirebaseAuth.instance.authStateChanges(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<User?> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Trạng thái kết nối đang chờ
                                    return CircularProgressIndicator();
                                  } else {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      // Người dùng đã đăng nhập và có dữ liệu
                                      final user = snapshot.data!;
                                      if (user.displayName != null) {
                                        // Tên người dùng có sẵn
                                        // setState(() {
                                        //   fd.getSignInStatus(true);
                                        // });
                                        return Text(
                                          user.displayName!,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        );
                                      } else {
                                        // Tên người dùng không có sẵn
                                        return Text(
                                          'Tên người dùng không có sẵn',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        );
                                      }
                                    } else {
                                      // Người dùng chưa đăng nhập hoặc không có dữ liệu
                                      // setState(() {
                                      //   fd.getSignInStatus(false);
                                      // });
                                      return Text(
                                        'Người dùng',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      );
                                    }
                                  }
                                },
                              )

                              // if (FirebaseAuth.instance.currentUser != null &&
                              //     FirebaseAuth.instance.currentUser!.displayName !=
                              //         null)
                              //   Text(
                              //     FirebaseAuth.instance.currentUser!.displayName!,
                              //     style: TextStyle(
                              //       fontSize: 22,
                              //       color: Colors.black,
                              //     ),
                              //   )
                              // else
                              //   Text(
                              //     'Người dùng',
                              //     style: TextStyle(
                              //       fontSize: 22,
                              //       color: Colors.black,
                              //     ),
                              //   ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Upgrade vip
                    Container(
                      height: 90,
                      decoration: BoxDecoration(
                        // color: Color(0xf5FB1AB),
                        //change topic
                        // color: Color(0XFF5FB1AB),
                        // color: kUpPinkLight,
                        color: listColor[myTopic.get('index')][4],
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Nâng cấp lên Pro',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Mở khóa tất cả các tính năng',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Container(
                                width: 85,
                                height: 32,
                                decoration: BoxDecoration(
                                  //change topic

                                  color: listColor[myTopic.get('index')][1],

                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'lib/assets/icons/crown-pro.png',
                                            width: 24,
                                            height: 24,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text('PRO',
                                              style: TextStyle(
                                                fontSize: 14,
                                                //change topic
                                                // color: Color.fromARGB(
                                                //     255, 34, 140, 135),
                                                // color: kMainPink,
                                                color: listColor[
                                                    myTopic.get('index')][0],
                                                fontWeight: FontWeight.w600,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(bottom: 0, top: 20),
                      child: Text(
                        'Tổng quan về Nhiệm vụ',
                        style: kHeaderTaskOverview,
                      ),
                    ),

                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 8, 5, 10),
                                // child: ValueListenableBuilder(
                                //   valueListenable: myBox.listenable(),
                                //   builder: (context, Box<ToDoDataBase> box, _) {
                                //     List<int> allKeys = box.keys
                                //         .map<int>((key) => key as int)
                                //         .toList();
                                //     for (int i = 0; i < allKeys.length; i++) {
                                //       final int key = allKeys[i];
                                //       final ToDoDataBase? toDoTask =
                                //           box.get(key);
                                //       if (toDoTask!.isCompleted!) demNow++;
                                //     }
                                //     demDoned += demNow;
                                //     return ValueListenableBuilder(
                                //         valueListenable: myBoxP.listenable(),
                                //         builder: (context,
                                //             Box<ToDoDataBase> boxP, _) {
                                //           List<int> allKeys = box.keys
                                //               .map<int>((key) => key as int)
                                //               .toList();
                                //           for (int i = 0;
                                //               i < allKeys.length;
                                //               i++) {
                                //             final int key = allKeys[i];
                                //             final ToDoDataBase? toDoTask =
                                //                 boxP.get(key);
                                //             if (toDoTask!.isCompleted!)
                                //               demNow++;
                                //           }
                                //           demDoned += demPast;
                                //           return BoxContentText(
                                //             // numTask: unfinishedTaskNum(),
                                //             numTask: demDoned,
                                //             category:
                                //                 'nhiệm vụ đã \nhoàn thành',
                                //           );
                                //         });
                                //   },
                                // ),
                                child: BoxContentText(
                                  // numTask: unfinishedTaskNum(),
                                  numTask: demDoned,
                                  category: 'nhiệm vụ đã \nhoàn thành',
                                ),
                              )),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(5, 10, 0, 10),
                                child: BoxContentText(
                                  // numTask: unfinishedTaskNum(),
                                  numTask: demNotDoned,
                                  // numTask: 14,
                                  category: 'nhiệm vụ chưa \nhoàn thành',
                                ),
                              )),
                        ],
                      ),
                    ),
                    //Chart
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        height: screenHeight * 0.45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          //change topic
                          color: listColor[myTopic.get('index')][1],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                top: 30,
                                child: Text(
                                  'Biểu đồ đánh giá',
                                  textAlign: TextAlign.center,
                                  style: kHeaderTaskChart,
                                )),
                            Positioned(
                              left: 0,
                              right: 0,
                              // bottom: 0,
                              top: 90,
                              child: PieChart(
                                dataMap: {
                                  "Nhiệm vụ đã hoàn thành":
                                      // finishedTaskNum().toDouble(),
                                      demDoned.toDouble(),
                                  // 183,
                                  "Nhiệm vụ chưa hoàn thành":
                                      demNotDoned.toDouble(),
                                  // 14
                                  // unfinishedTaskNum().toDouble(),
                                },
                                animationDuration: Duration(milliseconds: 800),
                                chartLegendSpacing: 35,
                                chartRadius: 100,
                                colorList: colorChart,
                                initialAngleInDegree: 270,
                                chartType: ChartType.ring,
                                ringStrokeWidth: 40,

                                // centerText: 'Tổng\n' + numberOfBills,
                                legendOptions: LegendOptions(
                                  showLegendsInRow: false,
                                  legendPosition: LegendPosition.bottom,
                                  showLegends: true,
                                  legendShape: BoxShape.rectangle,
                                  legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                                chartValuesOptions: ChartValuesOptions(
                                  showChartValueBackground: false,
                                  showChartValues: false,
                                  showChartValuesInPercentage: false,
                                  showChartValuesOutside: true,
                                  decimalPlaces: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class BoxContentText extends StatelessWidget {
  // const BoxContentText({
  //   Key? key,
  // }) : super(key: key);
  final int numTask;
  // final int? taskNotCompleted;
  final Widget? childContent;
  final String? category;
  BoxContentText({
    super.key,
    required this.numTask,
    this.category,
    this.childContent,
  });
  final myTopic = Hive.box('topicColor');
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),

        //change topic
        color: listColor[myTopic.get('index')][1],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          numTask.toString(),
          style: kNumTask,
        ),
        Text(
          category!,
          textAlign: TextAlign.center,
          style: kNumTaskCategory,
        ),
      ]),
      // Other properties for the widget
    );
  }
}

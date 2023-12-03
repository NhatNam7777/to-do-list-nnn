// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:to_do_list_nhatnam/constants.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/screens/home_page.dart';

class SortDialog extends StatefulWidget {
  final ValueSetter<String> onValueSelected;

  SortDialog({required this.onValueSelected});

  @override
  State<SortDialog> createState() => _SortDialogState();
}

bool isSelectedOption1 = false;
bool isSelectedOption2 = false;
List<String> options = ['Option 1', 'Option 2', 'Option 3'];
final myTopic = Hive.box('topicColor');

class _SortDialogState extends State<SortDialog> {
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
          Radius.circular(20.0),
        ),
      ),

      content: Container(
        height: height * 25 / 100,
        width: width - 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //title
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 30, top: 20),
                child: Text(
                  'Các nhiệm vụ được sắp xếp theo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30),
                    child: GestureDetector(
                      onTap: () {
                        // setState(() {
                        isSelectedOption1 = true;
                        isSelectedOption2 = false;
                        // });
                        widget.onValueSelected('1');
                        Navigator.pop(context);
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomePage()));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isSelectedOption1 == true
                              ? Image.asset(
                                  'lib/assets/icons/circle-button.png',
                                  width: 24,
                                  color: listColor[myTopic.get('index')][0],
                                )
                              : Image.asset(
                                  'lib/assets/icons/rec.png',
                                  width: 24,
                                  color: kGreyTextOptionLoop,
                                ),
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: isSelectedOption1
                          //         ? Colors.blue
                          //         : Colors.transparent,
                          //   ),
                          // ),
                          SizedBox(width: 8),
                          Text('Thời gian tạo tác vụ (Mới nhất ở \ndưới cùng)'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelectedOption1 = false;
                          isSelectedOption2 = true;
                        });
                        widget.onValueSelected('2');
                        Navigator.pop(context);
                        //   Navigator.pushReplacement(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => HomePage()));
                      },
                      child: Row(
                        children: [
                          isSelectedOption1 == false
                              ? Image.asset(
                                  'lib/assets/icons/circle-button.png',
                                  width: 24,
                                  color: listColor[myTopic.get('index')][0],
                                )
                              : Image.asset(
                                  'lib/assets/icons/rec.png',
                                  width: 24,
                                  color: kGreyTextOptionLoop,
                                ),
                          SizedBox(width: 8),
                          Text('Thời gian tạo tác vụ (Mới nhất ở \ntrên cùng)'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: Container(
            //     margin: EdgeInsets.only(right: 15, bottom: 15),
            //     child: TextButton(
            //         onPressed: () => {
            //               Navigator.pop(context),
            //             },
            //         child: Text(
            //           'CHỌN',
            //           style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.w700,
            //             color: kMainGreen,
            //           ),
            //         )),
            //   ),
            // )
          ],
        ),
      ),

      //     ],
      //   ),
      // ),
    );
  }
}

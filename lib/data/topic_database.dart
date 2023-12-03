import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/constants.dart';
import 'package:to_do_list_nhatnam/screens/calendar_page.dart';
import 'package:flutter/material.dart';
// part 'topic_database.g.dart';

// @HiveType(typeId: 20)
class TopicColor extends HiveObject {
  int picked = 0;
  final topicColor = Hive.box('topicColor');
  // Box<int> _myTopic = Hive.box<int>('topicColor');

  // @HiveField(0)
  // int? colorIndexPicked = 0;

  void updatePicked() {
    topicColor.put('index', picked);
  }
}

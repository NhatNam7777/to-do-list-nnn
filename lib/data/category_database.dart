import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/screens/calendar_page.dart';
import 'package:flutter/material.dart';

part 'category_database.g.dart';

@HiveType(typeId: 10)
class Category extends HiveObject {
  @HiveField(0)
  int? key;
  @HiveField(1)
  String? cateName;
  @HiveField(2)
  int? numTask = 0;

  Category({
    this.key,
    this.cateName,
    this.numTask,
  });
}

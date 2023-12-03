// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class reusableListTitleInDrawer extends StatelessWidget {
  reusableListTitleInDrawer({
    @required this.title,
    this.tail,
    @required this.iconName,
    @required this.onTap,
    @required this.color,
  });
  final String? title;
  final Widget? tail;
  final Function()? onTap;
  final Color? color;
  // final IconData? icon;
  // final Color? color;
  final String? iconName;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: ListTile(
          leading: Image.asset(
            'lib/assets/icons/$iconName.png',
            width: 25,
            // height: 25,
            color: color,
          ),
          title: Text(
            title ?? '',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          trailing: tail,
        ),
      ),
    );
  }
}

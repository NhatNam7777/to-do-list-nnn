import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_list_nhatnam/screens/home_page.dart';
import 'package:to_do_list_nhatnam/screens/task_page.dart';
import 'package:to_do_list_nhatnam/screens/user_page.dart';
import 'package:to_do_list_nhatnam/services/gg_auth.dart';

class SettingPage extends StatelessWidget {
  // const SettingPage({super.key, required this.homePage});
  const SettingPage({Key? key}) : super(key: key);
  // final Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('CÀI ĐẶT'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                AuthService().signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: Container(
                width: screenWidth - 30,
                height: 70,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 1,
                  color: Colors.black,
                )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Đăng xuất'),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:to_do_list_nhatnam/constants.dart';
import 'package:to_do_list_nhatnam/data/topic_database.dart';
import 'calendar_page.dart';
import 'user_page.dart';
import 'task_page.dart';
import 'package:to_do_list_nhatnam/constants.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

final myTopic = Hive.box('topicColor');
TopicColor db = TopicColor();

class HomePage extends StatefulWidget {
  String? payLoad;
  HomePage({this.payLoad});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? payLoad = 'a';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _buildBody = [TasksPage(), CalendarPage(), UserPage()];
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: School',
      style: optionStyle,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (myTopic.get('index') == null) {
      myTopic.put('index', 1);
    }
    String? payLoad = widget.payLoad;
    print('Hompage init');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          // ignore: prefer_const_constructors
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.white, // Set your desired status bar color
            statusBarBrightness:
                Brightness.light, // Set the brightness of status bar icons
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor:
                Colors.black, // Set your desired navigation bar color
            systemNavigationBarDividerColor:
                Colors.black, // Set your desired navigation bar divider color
            systemNavigationBarIconBrightness:
                Brightness.light, // Set the brightness of navigation bar icons
          ),
          child: _buildBody[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        // selectedItemColor: Color.fromARGB(255, 34, 140, 135),
        // selectedItemColor: kMainPink,
        selectedItemColor: listColor[myTopic.get('index')][0],
        unselectedItemColor: kSubColor,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Image.asset(
                    'lib/assets/icons/list.png',
                    color: listColor[myTopic.get('index')][0],
                    height: 30,
                  )
                : Image.asset(
                    'lib/assets/icons/list.png',
                    height: 30,
                    color: kSubColor,
                  ),
            label: 'Nhiệm vụ',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Image.asset(
                    'lib/assets/icons/thirty.png',
                    height: 30,
                    color: listColor[myTopic.get('index')][0],
                  )
                : Image.asset(
                    'lib/assets/icons/thirty.png',
                    height: 30,
                    color: kSubColor,
                  ),
            label: 'Lịch',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? Image.asset(
                    'lib/assets/icons/user.png',
                    height: 30,
                    color: listColor[myTopic.get('index')][0],
                  )
                : Image.asset(
                    'lib/assets/icons/user.png',
                    height: 30,
                    color: kSubColor,
                  ),
            label: 'Của tôi',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

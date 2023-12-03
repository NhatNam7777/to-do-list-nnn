// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_nhatnam/data/topic_database.dart';
import 'package:to_do_list_nhatnam/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:to_do_list_nhatnam/services/gg_auth.dart';
import 'package:to_do_list_nhatnam/services/adapter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/data/local_database.dart';
import 'package:to_do_list_nhatnam/data/category_database.dart';

import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:to_do_list_nhatnam/services/notifi_service.dart';
import 'package:provider/provider.dart';
import 'services/data_to_everywhere.dart';

const String todoBoxName = "myBox";
const String todoBoxNameP = "myBoxP";
const String todoBoxNameF = "myBoxF";
// void creatData() {
//   Box<ToDoDataBase> myBox = Hive.box<ToDoDataBase>('myBox');

//   ToDoDataBase newTask = ToDoDataBase(
//     taskName: '',
//     isCompleted: false,
//     taskDate: '',
//     taskTime: '',
//     index: 0,
//     flgTime: false,
//     note: '',
//     isStar: false,
//     isPast: false,
//     isFuture: false,
//     isNow: true,
//   );
//   // myBox.add(newTask);
//   // Thêm task mới vào Hive Box
//   myBox.put(0, newTask);
// }
// TopicColor dbColor = TopicColor();
// final topicColor = Hive.box('topicColor');
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  print(document.path); // Đường dẫn thư mục tài liệu
  await Firebase.initializeApp();
  // init the hive
  await Hive.initFlutter();

  // open a box
  // var box = await Hive.openBox<ToDoDataBase>('myBox');
  Hive.registerAdapter(ToDoDataBaseAdapter());
  Hive.registerAdapter(CategoryAdapter());
  // Hive.registerAdapter(TopicColorAdapter());
  await Hive.openBox<ToDoDataBase>('myBox');

  // await Hive.openBox<List<ToDoDataBase>>('myBox');
  await Hive.openBox<ToDoDataBase>(todoBoxNameP);
  await Hive.openBox<ToDoDataBase>(todoBoxNameF);
  await Hive.openBox<Category>('category');
  await Hive.openBox('topicColor');
  await Hive.openBox('cateList');

  // await Hive.openBox('topicColor');
  // dbColor.asignKeyToColorList();
  tz.initializeTimeZones();

  WidgetsFlutterBinding.ensureInitialized();
  // NotificationService().initNotification();
  initializeDateFormatting().then(
    (_) => runApp(MyApp()),

    //  (_) => runApp(ChangeNotifierProvider(
    //     create: (_) => WantTakeDataFrDetail(), child: MyApp())),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0; // Khởi tạo selectedIndex với giá trị mặc định là 0

  void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var authService = AuthService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WantTakeDataFrDetail()),
        ChangeNotifierProvider(
            create: (context) => DelCurrentTaskAndReplaceByNextTask()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        // home: authService.handleAuthState(),
        home: HomePage(),
      ),
    );
  }
}

import 'package:hive/hive.dart';
import 'package:to_do_list_nhatnam/screens/calendar_page.dart';
part 'local_database.g.dart';

@HiveType(typeId: 0)
class ToDoDataBase extends HiveObject {
  @HiveField(0)
  String? taskName;
  @HiveField(1)
  bool? isCompleted;
  @HiveField(2)
  String? taskDate;
  @HiveField(3)
  String? taskTime;
  @HiveField(4)
  int? index;
  @HiveField(5)
  bool? isStar;
  @HiveField(6)
  String? note;
  @HiveField(7)
  bool? flgTime;
  @HiveField(8)
  bool? isPast;
  @HiveField(9)
  bool? isNow;
  @HiveField(10)
  bool? isFuture;
  @HiveField(11)
  bool? isSetTime;
  @HiveField(12)
  bool? isSetLoop;
  @HiveField(13)
  bool? isHaveNote;
  @HiveField(14)
  String? category;
  ToDoDataBase({
    this.taskName,
    this.isCompleted,
    this.taskDate,
    this.taskTime,
    this.index,
    this.isStar,
    this.note,
    this.flgTime,
    this.isPast,
    this.isNow,
    this.isFuture,
    this.isSetTime,
    this.isSetLoop,
    this.isHaveNote,
    this.category,
  });
}

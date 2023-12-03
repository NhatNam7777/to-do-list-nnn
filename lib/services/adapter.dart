import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_nhatnam/data/local_database.dart';
import 'package:flutter/material.dart';

class ToDoDataBaseAdapter1 extends TypeAdapter<ToDoDataBase> {
  // // Thêm tham số box vào adapters
  // final Box<ToDoDataBase> box;

  // ToDoDataBaseAdapter(this.box);
  @override
  final typeId = 1;
  @override
  ToDoDataBase read(BinaryReader reader) {
    final taskName = reader.read();
    final isCompleted = reader.read();
    final taskDate = DateFormat('dd/MM/yyyy').parse(reader.read());
    final isShowDate = reader.read();
    final reminderTime = DateFormat('HH:mm').parse(reader.read());
    final hasReminder = reader.read();
    final taskNote = reader.read();
    final hasNote = reader.read();
    final repeatedState = reader.read();
    return ToDoDataBase(
      taskName: taskName,
      isCompleted: isCompleted,
      // taskDate: taskDate,
      // isShowDate: isShowDate,
      // reminderTime: TimeOfDay.fromDateTime(reminderTime),
      // hasReminder: hasReminder,
      // taskNote: taskNote,
      // hasNote: hasNote,
      // repeatedState: repeatedState,
    );
  }

  @override
  void write(BinaryWriter writer, ToDoDataBase obj) {
    writer.write(obj.taskName);
    writer.write(obj.isCompleted);
    // writer.write(DateFormat('dd/MM/yyyy').format(obj.taskDate!));
    // writer.write(obj.isShowDate);
    // writer
    //     .write(DateFormat('HH:mm').format(obj.reminderTime!.toDateTimeToday()));
    // writer.write(obj.hasReminder);
    // writer.write(obj.taskNote);
    // writer.write(obj.hasNote);
    // writer.write(obj.repeatedState);
  }
}

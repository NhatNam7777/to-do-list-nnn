// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToDoDataBaseAdapter extends TypeAdapter<ToDoDataBase> {
  @override
  final int typeId = 0;

  @override
  ToDoDataBase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToDoDataBase(
      taskName: fields[0] as String?,
      isCompleted: fields[1] as bool?,
      taskDate: fields[2] as String?,
      taskTime: fields[3] as String?,
      index: fields[4] as int?,
      isStar: fields[5] as bool?,
      note: fields[6] as String?,
      flgTime: fields[7] as bool?,
      isPast: fields[8] as bool?,
      isNow: fields[9] as bool?,
      isFuture: fields[10] as bool?,
      isSetTime: fields[11] as bool?,
      isSetLoop: fields[12] as bool?,
      isHaveNote: fields[13] as bool?,
      category: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ToDoDataBase obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.taskName)
      ..writeByte(1)
      ..write(obj.isCompleted)
      ..writeByte(2)
      ..write(obj.taskDate)
      ..writeByte(3)
      ..write(obj.taskTime)
      ..writeByte(4)
      ..write(obj.index)
      ..writeByte(5)
      ..write(obj.isStar)
      ..writeByte(6)
      ..write(obj.note)
      ..writeByte(7)
      ..write(obj.flgTime)
      ..writeByte(8)
      ..write(obj.isPast)
      ..writeByte(9)
      ..write(obj.isNow)
      ..writeByte(10)
      ..write(obj.isFuture)
      ..writeByte(11)
      ..write(obj.isSetTime)
      ..writeByte(12)
      ..write(obj.isSetLoop)
      ..writeByte(13)
      ..write(obj.isHaveNote)
      ..writeByte(14)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToDoDataBaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

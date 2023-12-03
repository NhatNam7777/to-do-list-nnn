// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'topic_database.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************

// class TopicColorAdapter extends TypeAdapter<TopicColor> {
//   @override
//   final int typeId = 20;

//   @override
//   TopicColor read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return TopicColor()..colorIndexPicked = fields[0] as int? ?? 0;
//   }

//   @override
//   void write(BinaryWriter writer, TopicColor obj) {
//     writer
//       ..writeByte(1)
//       ..writeByte(0)
//       ..write(obj.colorIndexPicked);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is TopicColorAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }

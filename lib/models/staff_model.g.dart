// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StaffModelAdapter extends TypeAdapter<StaffModel> {
  @override
  final int typeId = 0;

  @override
  StaffModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StaffModel(
      uid: fields[0] as String,
      name: fields[1] as String,
      department: fields[3] as String,
      email: fields[2] as String,
      profilePic: fields[4] as String,
      dob: fields[5]??0 as int,
      phoneNumber: fields[7] ??0as int,
      uniqueId: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StaffModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.department)
      ..writeByte(4)
      ..write(obj.profilePic)
      ..writeByte(5)
      ..write(obj.dob)
      ..writeByte(6)
      ..write(obj.uniqueId)
      ..writeByte(7)
      ..write(obj.phoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaffModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

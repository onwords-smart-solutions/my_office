// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitModelAdapter extends TypeAdapter<VisitModel> {
  @override
  final int typeId = 1;

  @override
  VisitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisitModel(
      dateTime: fields[0] as DateTime,
      customerPhoneNumber: fields[1] as String,
      customerName: fields[2] as String,
      stage: fields[9] as String,
      startKm: fields[5] as int?,
      prDetails: (fields[3] as List?)
          ?.map((dynamic e) => (e as Map).map(
              (dynamic k, dynamic v) => MapEntry(k as String, v as Uint8List)))
          .toList(),
      startKmImage: fields[4] as Uint8List?,
      productName: (fields[6] as List?)?.cast<String>(),
      productImage: (fields[7] as List?)?.cast<Uint8List>(),
      quotationInvoiceNumber: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VisitModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.customerPhoneNumber)
      ..writeByte(2)
      ..write(obj.customerName)
      ..writeByte(3)
      ..write(obj.prDetails)
      ..writeByte(4)
      ..write(obj.startKmImage)
      ..writeByte(5)
      ..write(obj.startKm)
      ..writeByte(6)
      ..write(obj.productName)
      ..writeByte(7)
      ..write(obj.productImage)
      ..writeByte(8)
      ..write(obj.quotationInvoiceNumber)
      ..writeByte(9)
      ..write(obj.stage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      stage: fields[11] as String,
      startKm: fields[7] as int?,
      inChargeDetail: (fields[3] as Map?)?.cast<String, String>(),
      supportCrewNames: (fields[4] as List?)?.cast<String>(),
      supportCrewImageLinks: (fields[5] as List?)?.cast<String>(),
      productImageLinks: (fields[9] as List?)?.cast<String>(),
      startKmImageLink: fields[6] as String?,
      productName: (fields[8] as List?)?.cast<String>(),
      quotationInvoiceNumber: fields[10] as String?,
      storagePath: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VisitModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.customerPhoneNumber)
      ..writeByte(2)
      ..write(obj.customerName)
      ..writeByte(3)
      ..write(obj.inChargeDetail)
      ..writeByte(4)
      ..write(obj.supportCrewNames)
      ..writeByte(5)
      ..write(obj.supportCrewImageLinks)
      ..writeByte(6)
      ..write(obj.startKmImageLink)
      ..writeByte(7)
      ..write(obj.startKm)
      ..writeByte(8)
      ..write(obj.productName)
      ..writeByte(9)
      ..write(obj.productImageLinks)
      ..writeByte(10)
      ..write(obj.quotationInvoiceNumber)
      ..writeByte(11)
      ..write(obj.stage)
      ..writeByte(12)
      ..write(obj.storagePath);
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

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
      date: fields[0] as String,
      time: fields[1] as String,
      customerPhoneNumber: fields[2] as String,
      customerName: fields[3] as String,
      stage: fields[14] as String,
      prDetails: (fields[4] as List?)
          ?.map((dynamic e) => (e as Map).map((dynamic k, dynamic v) =>
              MapEntry(k as String, (v as List).cast<Uint8List>())))
          .toList(),
      startKmImage: fields[5] as Uint8List?,
      endKmImage: fields[6] as Uint8List?,
      totalKm: fields[7] as String?,
      productName: (fields[8] as List?)?.cast<String>(),
      productImage: fields[9] as Uint8List?,
      invoiceNumber: fields[11] as String?,
      quotationNumber: fields[10] as String?,
      dateOfInstallation: fields[13] as String?,
      note: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VisitModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.customerPhoneNumber)
      ..writeByte(3)
      ..write(obj.customerName)
      ..writeByte(4)
      ..write(obj.prDetails)
      ..writeByte(5)
      ..write(obj.startKmImage)
      ..writeByte(6)
      ..write(obj.endKmImage)
      ..writeByte(7)
      ..write(obj.totalKm)
      ..writeByte(8)
      ..write(obj.productName)
      ..writeByte(9)
      ..write(obj.productImage)
      ..writeByte(10)
      ..write(obj.quotationNumber)
      ..writeByte(11)
      ..write(obj.invoiceNumber)
      ..writeByte(12)
      ..write(obj.note)
      ..writeByte(13)
      ..write(obj.dateOfInstallation)
      ..writeByte(14)
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

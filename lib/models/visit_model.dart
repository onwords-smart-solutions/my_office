import 'dart:typed_data';
import 'package:hive_flutter/adapters.dart';
part 'visit_model.g.dart';

@HiveType(typeId: 1)
class VisitModel {
  @HiveField(0)
  late String date;
  @HiveField(1)
  late String time;
  @HiveField(2)
  late String customerPhoneNumber;
  @HiveField(3)
  late List<Map<String, List<Uint8List>>>? prDetails;
  @HiveField(4)
  late Uint8List? startKmImage;
  @HiveField(5)
  late Uint8List? endKmImage;
  @HiveField(6)
  late String? totalKm;
  @HiveField(7)
  late List<String>? productName;
  @HiveField(8)
  late Uint8List? productImage;
  @HiveField(9)
  late String? quotationNumber;
  @HiveField(10)
  late String? invoiceNumber;
  @HiveField(11)
  late String? note;
  @HiveField(12)
  late String? dateOfInstallation;

  VisitModel(
      {required this.date,
      required this.time,
      required this.customerPhoneNumber,
      this.prDetails,
      this.startKmImage,
      this.endKmImage,
      this.totalKm,
      this.productName,
      this.productImage,
      this.invoiceNumber,
      this.quotationNumber,
      this.dateOfInstallation,
      this.note});
}

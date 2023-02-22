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
  late String customerName;
  @HiveField(4)
  late List<Map<String, List<Uint8List>>>? prDetails;
  @HiveField(5)
  late Uint8List? startKmImage;
  @HiveField(6)
  late Uint8List? endKmImage;
  @HiveField(7)
  late String? totalKm;
  @HiveField(8)
  late List<String>? productName;
  @HiveField(9)
  late Uint8List? productImage;
  @HiveField(10)
  late String? quotationNumber;
  @HiveField(11)
  late String? invoiceNumber;
  @HiveField(12)
  late String? note;
  @HiveField(13)
  late String? dateOfInstallation;
  @HiveField(14)
  late String stage;

  VisitModel(
      {required this.date,
      required this.time,
      required this.customerPhoneNumber,
        required this.customerName,
        required this.stage,
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

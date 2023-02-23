import 'dart:typed_data';
import 'package:hive_flutter/adapters.dart';

part 'visit_model.g.dart';

@HiveType(typeId: 1)
class VisitModel {
  @HiveField(0)
  late DateTime dateTime;
  @HiveField(1)
  late String customerPhoneNumber;
  @HiveField(2)
  late String customerName;
  @HiveField(3)
  late List<Map<String, Uint8List>>? prDetails;
  @HiveField(4)
  late Uint8List? startKmImage;
  @HiveField(5)
  late int? startKm;
  @HiveField(6)
  late List<String>? productName;
  @HiveField(7)
  late List<Uint8List>? productImage;
  @HiveField(8)
  late String? quotationInvoiceNumber;
  @HiveField(9)
  late String stage;

  VisitModel({
    required this.dateTime,
    required this.customerPhoneNumber,
    required this.customerName,
    required this.stage,
    this.startKm,
    this.prDetails,
    this.startKmImage,
    this.productName,
    this.productImage,
    this.quotationInvoiceNumber
  });
}

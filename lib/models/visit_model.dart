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
  late Map<String, String>? inChargeDetail;
  @HiveField(4)
  late List<String>? supportCrewNames;
  @HiveField(5)
  late List<String>? supportCrewImageLinks;
  @HiveField(6)
  late String? startKmImageLink;
  @HiveField(7)
  late int? startKm;
  @HiveField(8)
  late List<String>? productName;
  @HiveField(9)
  late List<String>? productImageLinks;
  @HiveField(10)
  late String? quotationInvoiceNumber;
  @HiveField(11)
  late String stage;
  @HiveField(12)
  late String? storagePath;

  VisitModel({
    required this.dateTime,
    required this.customerPhoneNumber,
    required this.customerName,
    required this.stage,
    this.startKm,
    this.inChargeDetail,
    this.supportCrewNames,
    this.supportCrewImageLinks,
    this.productImageLinks,
    this.startKmImageLink,
    this.productName,
    this.quotationInvoiceNumber,
    this.storagePath,
  });
}

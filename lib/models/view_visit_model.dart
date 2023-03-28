class VisitViewModel {

  final DateTime dateTime;
  final String customerPhoneNumber;
  final String customerName;
  final Map<String, String> inChargeDetail;
  final List<Object?> supportCrewNames;
  final List<Object?> supportCrewImageLinks;
  final String startKmImageLink;
  final int startKm;
  final List<Object?> productName;
  final List<Object?> productImageLinks;
  final String quotationInvoiceNumber;
  final int endKm;
  final int totalKm;
  final String note;
  final String endKmImage;
  final String dateOfInstallation;
  final String visitTime;

  VisitViewModel({
    required this.visitTime,
    required this.note,
    required this.dateTime,
    required this.customerPhoneNumber,
    required this.customerName,
    required this.endKm,
    required this.totalKm,
    required this.endKmImage,
    required this.startKm,
    required this.inChargeDetail,
    required this.supportCrewNames,
    required this.supportCrewImageLinks,
    required this.productImageLinks,
    required this.startKmImageLink,
    required this.productName,
    required this.quotationInvoiceNumber,
    required this.dateOfInstallation,
  });
}

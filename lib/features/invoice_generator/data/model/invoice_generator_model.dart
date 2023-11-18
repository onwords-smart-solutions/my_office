class InvoiceGeneratorModel {
  final String name;
  final String street;
  final String address;
  final int phone;
  final String docType;
  final String docCategory;
  final String? gst;

  const InvoiceGeneratorModel({
    required this.name,
    required this.street,
    required this.address,
    required this.phone,
    required this.docType,
    required this.docCategory,
    this.gst,
  });
}
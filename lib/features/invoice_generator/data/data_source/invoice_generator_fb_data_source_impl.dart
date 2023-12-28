import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_office/features/invoice_generator/data/data_source/invoice_generator_fb_data_source.dart';

import '../../../../core/utilities/custom_widgets/custom_pdf_utils.dart';
import '../model/invoice_generator_model.dart';

class InvoiceGeneratorFbDataSourceImpl implements InvoiceGeneratorFbDataSource{
  final ref = FirebaseDatabase.instance.ref();
  final storageRef = FirebaseStorage.instance.ref();

  @override
  Future<DatabaseEvent> getInventory() {
    return ref.child('inventory_management').once();
  }

  @override
  Future<DatabaseEvent> getDocLengthSnapshot() {
    return ref.child('QuotationAndInvoice').once();
  }

  @override
  Future<DatabaseEvent> getIdSnapshot() {
    return ref.child('QuotationAndInvoice/PROFORMA_INVOICE').once();
  }

  @override
  Future<String> uploadFileAndRetrieveUrl({required String path, required File file}) async {
    var snapshot = await storageRef.child(path).putFile(file, SettableMetadata(contentType: 'application/pdf'));
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Future<String> uploadInstallationInvoice(File installationPdfFile, String docCategory, DateTime date, int docLen) async {
    var snapshot = await storageRef
        .child('INSTALLATION-INVOICE/INV$docCategory-${Utils.formatDummyDate(date)}$docLen')
        .putFile(installationPdfFile, SettableMetadata(contentType: 'application/pdf'));
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Future<void> setDocument(InvoiceGeneratorModel clientModel, DateTime date, dynamic document, int docLen) async {
    String docTypePath = clientModel.docType == 'INVOICE' ? 'INVOICE' : 'PROFORMA_INVOICE';
    String docPrefix = clientModel.docType == 'INVOICE' ? 'INV_' : 'PRO_INV_';
    String docPath = '$docTypePath/${Utils.formatYear(date)}/${Utils.formatMonth(date)}/$docPrefix${clientModel.docCategory}-${Utils.formatDummyDate(date)}$docLen';

    await ref
        .child('QuotationAndInvoice')
        .child(docPath)
        .set(document);
  }

  @override
  Future<String> uploadQuotationFile(File pdfFile, String docCategory, DateTime date, int docLen) async {
    var snapshot = await storageRef
        .child('QUOTATION/EST$docCategory-${Utils.formatDummyDate(date)}$docLen')
        .putFile(pdfFile, SettableMetadata(contentType: 'application/pdf'));
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Future<void> setQuotation(DateTime date, InvoiceGeneratorModel clientModel, dynamic quotation, int docLen) async {
    await ref
        .child('QuotationAndInvoice')
        .child('QUOTATION')
        .child('${Utils.formatYear(date)}')
        .child('${Utils.formatMonth(date)}')
        .child('EST${clientModel.docCategory}-${Utils.formatDummyDate(date)}${docLen.toString()}')
        .set(quotation);
  }
}
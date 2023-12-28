import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/invoice_generator/data/model/invoice_generator_model.dart';
abstract class InvoiceGeneratorFbDataSource {
  Future<DatabaseEvent> getInventory();

  Future<DatabaseEvent> getDocLengthSnapshot();

  Future<DatabaseEvent> getIdSnapshot();

  Future<String> uploadFileAndRetrieveUrl({required String path,required File file});

  Future<String> uploadInstallationInvoice(File installationPdfFile, String docCategory, DateTime date, int docLen);

  Future<void> setDocument(InvoiceGeneratorModel clientModel, DateTime date, dynamic document, int docLen);

  Future<String> uploadQuotationFile(File pdfFile, String docCategory, DateTime date, int docLen);

  Future<void> setQuotation(DateTime date, InvoiceGeneratorModel clientModel, dynamic quotation, int docLen);

}

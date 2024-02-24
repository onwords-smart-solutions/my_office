import 'dart:io';

import 'package:my_office/features/invoice_generator/data/model/invoice_generator_products_model.dart';

import '../../data/model/invoice_generator_model.dart';

abstract class InvoiceGeneratorRepository {
  Future<List<InvoiceGeneratorProducts>> getProducts();

  Future<InvoiceGeneratorProductDetails> getProductDetails(String productName);

  Future<List<String>> getDocumentLengths(String docType, DateTime date);

  Future<List<String>> getGeneratedIds();

  Future<String> uploadDocumentAndGetUrl({required String path, required File file});

  Future<String> uploadInstallationInvoice(File installationPdfFile, String docCategory, DateTime date, int docLen);

  Future<void> setDocument(InvoiceGeneratorModel clientModel, DateTime date, dynamic document, int docLen);

  Future<String> uploadQuotation(File pdfFile, String docCategory, DateTime date, int docLen);

  Future<void> saveQuotation(DateTime date, InvoiceGeneratorModel clientModel, dynamic quotation, int docLen);

}

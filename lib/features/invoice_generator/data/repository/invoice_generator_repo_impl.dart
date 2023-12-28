import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/invoice_generator/data/data_source/invoice_generator_fb_data_source.dart';
import 'package:my_office/features/invoice_generator/data/model/invoice_generator_products_model.dart';
import 'package:my_office/features/invoice_generator/domain/repository/invoice_generator_repository.dart';
import 'package:pdf/pdf.dart';

import '../../../../core/utilities/custom_widgets/custom_pdf_utils.dart';
import '../model/invoice_generator_model.dart';

class InvoiceGeneratorRepoImpl implements InvoiceGeneratorRepository {
  final InvoiceGeneratorFbDataSource invoiceGeneratorFbDataSource;

  InvoiceGeneratorRepoImpl(this.invoiceGeneratorFbDataSource);

  @override
  Future<InvoiceGeneratorProductDetails> getProductDetails(
    String productName,
  ) async {
    final DatabaseEvent event =
        await invoiceGeneratorFbDataSource.getInventory();
    for (var child in event.snapshot.children) {
      var value = child.value as Map<dynamic, dynamic>;
      if (value['name'].toString().toUpperCase() == productName.toUpperCase()) {
        return InvoiceGeneratorProductDetails.fromMap(value);
      }
    }
    throw Exception("Product not found");
  }

  @override
  Future<List<InvoiceGeneratorProducts>> getProducts() async {
    final DatabaseEvent event =
        await invoiceGeneratorFbDataSource.getInventory();
    return event.snapshot.children.map((child) {
      var value = child.value as Map<dynamic, dynamic>;
      return InvoiceGeneratorProducts.fromMap(value);
    }).toList();
  }

  @override
  Future<List<String>> getDocumentLengths(String docType, DateTime date) async {
    List<String> documentLengths = [];
    try {
      DatabaseEvent event =
          await invoiceGeneratorFbDataSource.getDocLengthSnapshot();
      for (var element in event.snapshot.children) {
        if (docType == element.key) {
          for (var element1 in element.children) {
            for (var element2 in element1.children) {
              if (element2.key == Utils.formatMonth(date)) {
                for (var element3 in element2.children) {
                  documentLengths.add(element3.key!);
                }
              }
            }
          }
        }
      }
      return documentLengths;
    } catch (e) {
      print('Error fetching document lengths: $e');
      return [];
    }
  }

  @override
  Future<List<String>> getGeneratedIds() async {
    List<String> generatedIds = [];
    try {
      DatabaseEvent event = await invoiceGeneratorFbDataSource.getIdSnapshot();
      for (var val1 in event.snapshot.children) {
        for (var val2 in val1.children) {
          for (var val3 in val2.children) {
            final data = val3.value as Map<dynamic, dynamic>;
            final id = data['id'].toString();
            generatedIds.add(id);
          }
        }
      }
      return generatedIds;
    } catch (e) {
      print('Error fetching generated IDs: $e');
      return [];
    }
  }

  @override
  Future<String> uploadDocumentAndGetUrl({required String path, required File file}) {
    return invoiceGeneratorFbDataSource.uploadFileAndRetrieveUrl(path: path, file: file);
  }

  @override
  Future<String> uploadInstallationInvoice(
      File installationPdfFile,
    String docCategory,
    DateTime date,
    int docLen,
  ) {
    return invoiceGeneratorFbDataSource.uploadInstallationInvoice(
      installationPdfFile,
      docCategory,
      date,
      docLen,
    );
  }

  @override
  Future<void> setDocument(InvoiceGeneratorModel clientModel, DateTime date, dynamic document, int docLen) {
    return invoiceGeneratorFbDataSource.setDocument(clientModel, date, document, docLen);
  }

  @override
  Future<String> uploadQuotation(File pdfFile, String docCategory, DateTime date, int docLen) {
    return invoiceGeneratorFbDataSource.uploadQuotationFile(pdfFile, docCategory, date, docLen);
  }

  @override
  Future<void> saveQuotation(DateTime date, InvoiceGeneratorModel clientModel, dynamic quotation, int docLen) async {
    await invoiceGeneratorFbDataSource.setQuotation(date, clientModel, quotation, docLen);
  }
}

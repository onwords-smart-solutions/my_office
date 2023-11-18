import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/features/invoice_generator/data/data_source/invoice_generator_fb_data_source.dart';
import 'package:my_office/features/invoice_generator/data/model/invoice_generator_products_model.dart';
import 'package:my_office/features/invoice_generator/domain/repository/invoice_generator_repository.dart';

class InvoiceGeneratorRepoImpl implements InvoiceGeneratorRepository{
  final InvoiceGeneratorFbDataSource invoiceGeneratorFbDataSource;

  InvoiceGeneratorRepoImpl(this.invoiceGeneratorFbDataSource);

  @override
  Future<InvoiceGeneratorProductDetails> getProductDetails(String productName) async {
    final DatabaseEvent event = await invoiceGeneratorFbDataSource.getInventory();
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
    final DatabaseEvent event = await invoiceGeneratorFbDataSource.getInventory();
    return event.snapshot.children.map((child) {
      var value = child.value as Map<dynamic, dynamic>;
      return InvoiceGeneratorProducts.fromMap(value);
    }).toList();
  }


}
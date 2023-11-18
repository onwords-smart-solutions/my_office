import 'package:my_office/features/invoice_generator/data/model/invoice_generator_products_model.dart';

abstract class InvoiceGeneratorRepository {
  Future<List<InvoiceGeneratorProducts>> getProducts();

  Future<InvoiceGeneratorProductDetails> getProductDetails(String productName);
}

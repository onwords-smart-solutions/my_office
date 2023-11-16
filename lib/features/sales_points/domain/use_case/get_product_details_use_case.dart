import 'package:my_office/features/sales_points/domain/repository/sales_point_repository.dart';

import '../../data/model/sales_point_model.dart';

class GetProductDetailsCase{
  final SalesPointRepository salesPointRepository;

  GetProductDetailsCase(this.salesPointRepository);

  Future<ProductDetails> execute (String productName) async {
    return salesPointRepository.getProductDetails(productName);
  }
}
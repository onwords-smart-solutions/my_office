import 'package:my_office/features/sales_points/domain/repository/sales_point_repository.dart';

import '../../data/model/sales_point_model.dart';

class GetProductsCase{
  final SalesPointRepository salesPointRepository;

  GetProductsCase(this.salesPointRepository);

  Future<List<Product>> execute() async {
    return salesPointRepository.getProducts();
  }
}
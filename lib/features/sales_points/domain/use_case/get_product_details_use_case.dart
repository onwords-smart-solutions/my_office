import 'package:my_office/features/sales_points/domain/repository/sales_point_repository.dart';

class GetProductDetailsCase{
  final SalesPointRepository salesPointRepository;

  GetProductDetailsCase(this.salesPointRepository);

  Future<Map<String, dynamic>> execute(String productName) async {
    return await salesPointRepository.getProductDetails(productName);
  }
}
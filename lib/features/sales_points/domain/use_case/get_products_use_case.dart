import 'package:my_office/features/sales_points/domain/repository/sales_point_repository.dart';

import '../../data/model/sales_point_drop_down_model.dart';

class GetProductsCase{
  final SalesPointRepository salesPointRepository;

  GetProductsCase(this.salesPointRepository);

  Future<List<DropDownValueModel>> execute() async {
    return await salesPointRepository.getProducts();
  }
}
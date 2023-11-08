
import 'package:either_dart/either.dart';
import 'package:my_office/features/create_product/domain/entity/create_product_entity.dart';

import '../../../../core/utilities/response/error_response.dart';

abstract class CreateProductRepository {
  Future<Either<ErrorResponse, bool>> createProduct(CreateProductEntity createProductEntity);
}

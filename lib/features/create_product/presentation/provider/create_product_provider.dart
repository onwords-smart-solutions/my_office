
import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/create_product/domain/entity/create_product_entity.dart';

import '../../domain/use_case/create_product_use_case.dart';

class CreateProductProvider with ChangeNotifier {
  final CreateProductCase createProductCase;

  CreateProductProvider(this.createProductCase);

  Future<Either<ErrorResponse, bool>> createProduct(CreateProductEntity createProductEntity) async {
    try {
      return await createProductCase.execute(createProductEntity);
    } catch (e) {
      return Left(
          ErrorResponse(
            metaInfo: 'Catch triggered while creating products',
            error: 'Error caught while creating new products $e',
          ),
      );
    }
  }
}

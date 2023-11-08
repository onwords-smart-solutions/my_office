
import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/create_product/domain/entity/create_product_entity.dart';
import 'package:my_office/features/create_product/domain/repository/create_product_repository.dart';

class CreateProductRepoImpl implements CreateProductRepository {
  final ref = FirebaseDatabase.instance.ref();

  @override
  Future<Either<ErrorResponse, bool>> createProduct(CreateProductEntity createProductEntity) async {
      try {
        await ref.child('inventory_management/${createProductEntity.id}').set({
        "id": createProductEntity.id,
        "name": createProductEntity.name,
        "max_price": createProductEntity.maxPrice,
        "min_price": createProductEntity.minPrice,
        "obc": createProductEntity.obc,
        "stock": createProductEntity.stock,
    });
        return const Right(true);
      } catch (e) {
        return Left(
          ErrorResponse(
            error: 'Error while creating products $e',
            metaInfo: 'Catch triggered while creating products',
          ),
        );
      }
  }
}

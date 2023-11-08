
import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/create_product/domain/entity/create_product_entity.dart';
import 'package:my_office/features/create_product/domain/repository/create_product_repository.dart';

class CreateProductCase {
  final CreateProductRepository createProductRepository;

  CreateProductCase({required this.createProductRepository});

  Future<Either<ErrorResponse, bool>> execute(CreateProductEntity createProductEntity) async {
    if (createProductEntity.name.isEmpty) {
      throw Exception('Product name should not be empty');
    }else if(createProductEntity.id.isEmpty){
      throw Exception('Product id should not be empty');
    }else if(createProductEntity.maxPrice.isEmpty){
      throw Exception('Max price should not be empty');
    }else if(createProductEntity.minPrice.isEmpty){
      throw Exception('Min price should not be empty');
    }else if(createProductEntity.obc.isEmpty){
      throw Exception('Obc field should be filled');
    }else if(createProductEntity.stock.isEmpty){
      throw Exception('Stock should be filled');
    }else{
      return await createProductRepository.createProduct(createProductEntity);
    }
  }
}

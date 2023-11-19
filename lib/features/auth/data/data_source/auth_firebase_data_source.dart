import 'package:either_dart/either.dart';

import '../../../../core/utilities/response/error_response.dart';
import '../../../user/data/model/user_model.dart';
import '../../../user/domain/entity/user_entity.dart';

abstract class AuthFbDataSource{
  Future<Either<ErrorResponse, UserEntity>> login(
      {required String email, required String password,required String uniqueId
      });

  Future<Either<ErrorResponse, UserModel>> getUserInfo(String userId, String uniqueId);

  Future<Either<ErrorResponse, bool>> resetPassword({required String email});

  Future<Either<ErrorResponse, void>> updatePhoneNumber();

  Future<Either<ErrorResponse, void>> updateBirthday();
}
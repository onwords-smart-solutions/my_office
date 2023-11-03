import 'package:either_dart/either.dart';
import 'package:my_office/features/auth/data/models/user_model.dart';

import '../../../../core/utilities/response/error_response.dart';
import '../../../user/domain/entity/user_entity.dart';

abstract class AuthFbDataSource{
  Future<Either<ErrorResponse, UserEntity>> login(
      {required String email, required String password,
      });

  Future<Either<ErrorResponse, UserModel>> getUserInfo(String userId);


  Future<Either<ErrorResponse, bool>> resetPassword({required String email});

  Future<Either<ErrorResponse, bool>> signOut();

  Future<String> getDeviceInfo();

  Future<void> storeFcmToken({required String userId});

  Future<List<String>> getFcmTokens({required String userId});

  Future<void> removeFcmToken({required String userId});
}
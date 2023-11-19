import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/auth/data/data_source/auth_firebase_data_source.dart';
import 'package:my_office/features/auth/domain/repository/auth_repository.dart';
import 'package:my_office/features/user/data/model/user_model.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';

import '../data_source/auth_local_data_source.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthFbDataSource _authFbDataSource;
  final AuthLocalDataSourceImpl _authLocalDataSourceImpl;

  AuthRepoImpl(this._authFbDataSource, this._authLocalDataSourceImpl);

  @override
  Future<Either<ErrorResponse, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    return await _authFbDataSource.login(
      email: email,
      password: password,
      uniqueId: await _authLocalDataSourceImpl.getUniqueID(),
    );
  }

  @override
  Future<Either<ErrorResponse, bool>> resetPassword({
    required String email,
  }) async {
    return await _authFbDataSource.resetPassword(email: email);
  }

  @override
  Future<Either<ErrorResponse, void>> updateBirthday() {
    // TODO: implement updateBirthday
    throw UnimplementedError();
  }

  @override
  Future<Either<ErrorResponse, void>> updatePhoneNumber() {
    // TODO: implement updatePhoneNumber
    throw UnimplementedError();
  }

  @override
  Future<Either<ErrorResponse, UserModel>> getUserInfo(String userId) async {
    return await _authFbDataSource.getUserInfo(
      userId,
      await _authLocalDataSourceImpl.getUniqueID(),
    );
  }
}

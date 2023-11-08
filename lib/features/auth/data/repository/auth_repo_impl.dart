import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/auth/data/data_source/auth_firebase_data_source.dart';
import 'package:my_office/features/auth/domain/repository/auth_repository.dart';
import 'package:my_office/features/user/data/model/user_model.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthFbDataSource _authFbDataSource;

  AuthRepoImpl(this._authFbDataSource);

  @override
  Future<String> getDeviceInfo() {
    // TODO: implement getDeviceInfo
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getFcmTokens({required String userId}) {
    // TODO: implement getFcmTokens
    throw UnimplementedError();
  }

  @override
  Future<Either<ErrorResponse, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    return await _authFbDataSource.login(email: email, password: password);
  }

  @override
  Future<void> removeFcmToken({required String userId}) {
    // TODO: implement removeFcmToken
    throw UnimplementedError();
  }

  @override
  Future<Either<ErrorResponse, bool>> resetPassword({
    required String email,
  }) async {
    return await _authFbDataSource.resetPassword(email: email);
  }

  @override
  Future<Either<ErrorResponse, bool>> signOut() async {
   await _authFbDataSource.onClearData();
   return await _authFbDataSource.signOut();
  }

  @override
  Future<void> storeFcmToken({required String userId}) {
    // TODO: implement storeFcmToken
    throw UnimplementedError();
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
  Future<Either<ErrorResponse, UserModel>> getUserInfo(String userId) async{
    return await _authFbDataSource.getUserInfo(userId);
  }
}

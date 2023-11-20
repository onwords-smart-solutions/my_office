import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/auth/data/data_source/auth_fb_data_source.dart';
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
  Future<Either<ErrorResponse, UserModel>> getUserInfo(String userId) async {
    return await _authFbDataSource.getUserInfo(
      userId,
      await _authLocalDataSourceImpl.getUniqueID(),
    );
  }

  @override
  Future<void> updateUserDOB(String userId, DateTime dob) async {
    await _authFbDataSource.updateDateOfBirth(userId, dob);
  }

  @override
  Future<void> updateStaffMobile(String uid, int mobile) async {
    await _authFbDataSource.updateStaffMobile(uid, mobile);
  }

  @override
  Future<UserCredential> signIn(
      {required String email, required String password}) async {
    return _authFbDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() {
    return _authFbDataSource.signOut();
  }

  @override
  Future<UserEntity?> getStaff(String uid, String uniqueId) async {
    final data = await _authFbDataSource.getStaffDetails(uid);
    if (data != null) {
      return UserModel(
        dob: data['dob'] != null ? int.parse(data['dob'].toString()) : 0,
        mobile:
            data['mobile'] != null ? int.parse(data['mobile'].toString()) : 0,
        name: data['name']?.toString() ?? '',
        uid: uid,
        email: data['email']?.toString() ?? '',
        dep: data['department']?.toString() ?? '',
        url: data['profileImage']?.toString() ?? '',
        uniqueId: uniqueId,
      );
    }
    return null;
  }
}

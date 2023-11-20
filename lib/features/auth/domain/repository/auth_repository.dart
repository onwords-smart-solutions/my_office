import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utilities/response/error_response.dart';
import '../../../user/data/model/user_model.dart';
import '../../../user/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<ErrorResponse, UserEntity>> login(
      {required String email, required String password,
      });

  Future<Either<ErrorResponse, bool>> resetPassword({required String email});

  Future<Either<ErrorResponse, UserModel>> getUserInfo(String userId);

  Future<void> updateUserDOB(String userId, DateTime dob);

  Future<void> updateStaffMobile(String uid, int mobile);

  Future<UserCredential> signIn({required String email, required String password});
  Future<void> signOut();
  Future<UserEntity?> getStaff(String uid,String uniqueId);
}

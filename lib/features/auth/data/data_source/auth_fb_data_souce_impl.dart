
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/auth/data/data_source/auth_firebase_data_source.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../user/data/model/user_model.dart';

class AuthFbDataSourceImpl implements AuthFbDataSource {
  final FirebaseDatabase _firebaseDatabase;
  final FirebaseAuth _firebaseAuth;

  AuthFbDataSourceImpl(this._firebaseDatabase, this._firebaseAuth);

  @override
  Future<Either<ErrorResponse, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await getUserInfo(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      return Left(
        ErrorResponse(
          error: e.message.toString(),
          metaInfo: 'Catch triggered while log in user',
        ),
      );
    }
  }

  @override
  Future<Either<ErrorResponse, bool>> resetPassword({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(
        ErrorResponse(
          error: e.message.toString(),
          metaInfo: 'Catch triggered while sending reset email',
        ),
      );
    }
  }

  @override
  Future<Either<ErrorResponse, UserModel>> getUserInfo(String userId) async {
    try {
      UserModel? userModel;
      await _firebaseDatabase.ref('staff/$userId').once().then((value) {
        if (value.snapshot.exists) {
          userModel = UserModel.fromRealtimeDb(value.snapshot);
        }
      });
      if (userModel != null) {
        return Right(userModel!);
      } else {
        return Left(
          ErrorResponse(
            error: 'No user data found with this user Id',
            metaInfo: '',
          ),
        );
      }
    } catch (e) {
      return Left(
        ErrorResponse(
          error: 'No user data associated with this user Id',
          metaInfo: '',
        ),
      );
    }
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
}

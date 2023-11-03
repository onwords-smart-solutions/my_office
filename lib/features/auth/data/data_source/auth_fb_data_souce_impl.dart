import 'package:either_dart/src/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/auth/data/data_source/auth_firebase_data_source.dart';
import 'package:my_office/features/auth/data/models/user_model.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';

class AuthFbDataSourceImpl implements AuthFbDataSource {
  final FirebaseDatabase _firebaseDatabase;
  final FirebaseAuth _firebaseAuth;

  AuthFbDataSourceImpl(this._firebaseDatabase, this._firebaseAuth);

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
  Future<void> removeFcmToken({required String userId}) {
    // TODO: implement removeFcmToken
    throw UnimplementedError();
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
  Future<Either<ErrorResponse, bool>> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<void> storeFcmToken({required String userId}) {
    // TODO: implement storeFcmToken
    throw UnimplementedError();
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
}

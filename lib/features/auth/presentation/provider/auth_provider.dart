
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_office/features/auth/domain/use_case/reset_password_case.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../notifications/presentation/notification_view_model.dart';
import '../../data/data_source/auth_fb_data_souce_impl.dart';
import '../../data/data_source/auth_fb_data_source.dart';
import '../../data/data_source/auth_local_data_source.dart';
import '../../data/repository/auth_repo_impl.dart';
import '../../domain/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final ResetPasswordCase _resetPasswordCase;
  final AuthLocalDataSourceImpl _authLocalDataSourceImpl;

  AuthProvider(
    this._resetPasswordCase,
      this._authLocalDataSourceImpl,
  );

  UserEntity? _userEntity;

  UserEntity? get user => _userEntity;

  set user(UserEntity? userEntity) {
    _userEntity = userEntity;
    notifyListeners();
  }

  Future<String?> onLogin({
    required String email,
    required String password,
  }) async {
    late FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    late  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    late  AuthFbDataSource authFbDataSource = AuthFbDataSourceImpl(firebaseDatabase, firebaseAuth);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    late AuthLocalDataSourceImpl authLocalDataSourceImpl = AuthLocalDataSourceImpl(sharedPreferences);
    late AuthRepository authRepository = AuthRepoImpl(authFbDataSource, authLocalDataSourceImpl);
    final response = await authRepository.login(email: email, password: password);
    if (response.isLeft) return response.left.error;
    if (response.isRight) user = response.right;
    return null;
  }

  Future<String?> resetPassword({
    required String email,
  }) async {
    final response = await _resetPasswordCase.execute(email: email);
    if (response.isLeft) return response.left.error;
    if (response.isRight) {}
    return null;
  }

  Future<void> clearUser() async {
    if (user != null) {
      await NotificationService()
          .removeFCM(userId: user!.uid, uniqueId: user!.uniqueId);
    }
    await _authLocalDataSourceImpl.clearCache();
    user = null;
    notifyListeners();
  }

  Future<void> updateDOB(DateTime dob) async {

    late FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    late  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    late  AuthFbDataSource authFbDataSource = AuthFbDataSourceImpl(firebaseDatabase, firebaseAuth);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    late AuthLocalDataSourceImpl authLocalDataSourceImpl = AuthLocalDataSourceImpl(sharedPreferences);
    late AuthRepository authRepository = AuthRepoImpl(authFbDataSource, authLocalDataSourceImpl);

    if(user != null){
      int dobTimestamp = dob.millisecondsSinceEpoch;
      DateTime dobAsDateTime = DateTime.fromMillisecondsSinceEpoch(dobTimestamp); // Convert back to DateTime
      await authRepository.updateUserDOB(user!.uid, dobAsDateTime);
      user!.dob = dobTimestamp;
      notifyListeners();
    }
  }

  Future<void> updateMobile(int phoneNumber) async{
    late FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    late  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    late  AuthFbDataSource authFbDataSource = AuthFbDataSourceImpl(firebaseDatabase, firebaseAuth);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    late AuthLocalDataSourceImpl authLocalDataSourceImpl = AuthLocalDataSourceImpl(sharedPreferences);
    late AuthRepository authRepository = AuthRepoImpl(authFbDataSource, authLocalDataSourceImpl);

    if(user != null){
      int mobile = phoneNumber;
      await authRepository.updateStaffMobile(user!.uid, phoneNumber);
      user!.mobile = mobile;
      notifyListeners();
    }
  }
}

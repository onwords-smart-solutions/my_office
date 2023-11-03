import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/auth/domain/use_case/get_fcm_tokens_case.dart';
import 'package:my_office/features/auth/domain/use_case/login_case.dart';
import 'package:my_office/features/auth/domain/use_case/remove_fcm_tokens_case.dart';
import 'package:my_office/features/auth/domain/use_case/reset_password_case.dart';
import 'package:my_office/features/auth/domain/use_case/sign_out_case.dart';
import 'package:my_office/features/auth/domain/use_case/store_fcm_tokens_case.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';

import '../../domain/use_case/get_device_info_case.dart';

class AuthProvider extends ChangeNotifier {
  final LoginCase _loginCase;
  final ResetPasswordCase _resetPasswordCase;
  final SignOutCase _signOutCase;
  final GetFcmTokensCase _getFcmTokensCase;
  final StoreFcmCase _storeFcmCase;
  final RemoveFcmCase _removeFcmCase;
  final GetDeviceInfoCase _getDeviceInfoCase;

  AuthProvider(
    this._loginCase,
    this._resetPasswordCase,
    this._signOutCase,
    this._getFcmTokensCase,
    this._storeFcmCase,
    this._removeFcmCase,
    this._getDeviceInfoCase,
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
    final response = await _loginCase.execute(email: email, password: password);
    if (response.isLeft) return response.left.error;
    if (response.isRight) user = response.right;
    return null;
  }

  Future<String?> resetPassword({
    required String email,
  }) async {
    final response = await _resetPasswordCase.execute(email: email);
    if (response.isLeft) return response.left.error;
    if(response.isRight) response.right;
    return null;
  }

  Future<List<String>> getFcmTokens(String userId) async =>
      await _getFcmTokensCase.execute(userId: userId);

  Future<void> storeFcmTokens(String userId) async =>
      await _storeFcmCase.execute(userId: userId);

  /// INITIAL SETUP DATA
  String _deviceId = '';

  String get deviceId => _deviceId;

  Future<void> getData() async {
    final info = await _getDeviceInfoCase.execute();
    _deviceId = info;
    notifyListeners();
  }

  Future<void> onSignOut(String userId) async {
    await _removeFcmCase.execute(userId: userId);
    await _signOutCase.execute();
    _deviceId = '';
  }
}

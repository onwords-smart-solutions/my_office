import 'dart:math';

import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/auth/domain/use_case/login_case.dart';
import 'package:my_office/features/auth/domain/use_case/reset_password_case.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';
import '../../../notifications/presentation/notification_view_model.dart';
import '../../domain/use_case/get_staff_info_use_case.dart';

class AuthProvider extends ChangeNotifier {
  final LoginCase _loginCase;
  final ResetPasswordCase _resetPasswordCase;
  final GetStaffInfoCase _getUserInfoCase;

  AuthProvider(
    this._loginCase,
    this._resetPasswordCase,
    this._getUserInfoCase,
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
    if (response.isRight) {}
    return null;
  }

  Future<Either<ErrorResponse, UserEntity>> getStaffInfo(
    String userId,
  ) async =>
      await _getUserInfoCase.execute(userId);

  Future<void> clearUser() async {
    if (user != null) {
      await NotificationService()
          .removeFCM(userId: user!.uid, uniqueId: user!.uniqueId);
    }
    user = null;
    notifyListeners();
  }

  Future<void> initiateUser() async {
    final staff = await getStaffInfo(user!.uid);
    if (staff.right.uniqueId.isEmpty) {
      final id = generateRandomString(20);
      staff.right.uniqueId = id;
    }
      user = staff.right;
    notifyListeners();
  }

  String generateRandomString(int length) {
    const charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final buffer = StringBuffer();

    for (var i = 0; i < length; i++) {
      buffer.write(charset[random.nextInt(charset.length)]);
    }
    return buffer.toString();
  }
}

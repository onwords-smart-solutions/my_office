import 'package:either_dart/either.dart';
import 'package:my_office/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/utilities/response/error_response.dart';
import '../../../user/domain/entity/user_entity.dart';

class LoginCase {
  final AuthRepository authRepository;

  LoginCase({required this.authRepository});

  Future<Either<ErrorResponse, UserEntity>> execute({
    required String email,
    required String password,
  }) async =>
      await authRepository.login(
        email: email,
        password: password,
      );
}

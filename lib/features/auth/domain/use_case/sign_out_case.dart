import 'package:either_dart/either.dart';
import 'package:my_office/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/utilities/response/error_response.dart';

class SignOutCase {
  final AuthRepository authRepository;

  SignOutCase({required this.authRepository});

  Future<Either<ErrorResponse, bool>> execute() async =>
      await authRepository.signOut();
}

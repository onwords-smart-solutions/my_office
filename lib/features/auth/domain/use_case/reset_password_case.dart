import 'package:either_dart/either.dart';
import 'package:my_office/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/utilities/response/error_response.dart';

class ResetPasswordCase {
  final AuthRepository authRepository;

  ResetPasswordCase({required this.authRepository});

  Future<Either<ErrorResponse, bool>> execute({required String email}) async =>
      await authRepository.resetPassword(email: email);
}

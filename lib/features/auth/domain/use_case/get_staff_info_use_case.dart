import 'package:either_dart/src/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/user/data/model/user_model.dart';
import '../repository/auth_repository.dart';

class GetStaffInfoCase {
  final AuthRepository authRepository;

  GetStaffInfoCase({required this.authRepository});

  Future<Either<ErrorResponse, UserModel>> execute(String userId) async =>
      await authRepository.getUserInfo(userId);
}

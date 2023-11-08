import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/home/domain/repository/home_repository.dart';

import '../../../user/domain/entity/user_entity.dart';

class GetAllBirthdayCase {
  final HomeRepository homeRepository;

  GetAllBirthdayCase({required this.homeRepository});

  Future<Either<ErrorResponse, List<UserEntity>>> execute() async =>
      await homeRepository.getAllBirthday();
}
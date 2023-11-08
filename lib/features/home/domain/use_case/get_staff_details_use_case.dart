import 'package:either_dart/either.dart';
import 'package:my_office/features/home/domain/repository/home_repository.dart';

import '../../../../core/utilities/response/error_response.dart';
import '../../../user/domain/entity/user_entity.dart';

class GetStaffDetailsCase{
  final HomeRepository homeRepository;

  GetStaffDetailsCase({required this.homeRepository});

  Future<Either<ErrorResponse, List<UserEntity>>> execute() async =>
      await homeRepository.getStaffDetails();
}
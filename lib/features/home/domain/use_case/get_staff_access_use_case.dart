import 'package:either_dart/either.dart';
import 'package:my_office/features/home/domain/repository/home_repository.dart';

import '../../../../core/utilities/response/error_response.dart';
import '../../../user/domain/entity/user_entity.dart';
import '../../data/model/staff_access_model.dart';

class GetStaffAccessCase{
  final HomeRepository homeRepository;

  GetStaffAccessCase({required this.homeRepository});

  Future<Either<ErrorResponse, List<StaffAccessModel>>> execute({
    required UserEntity staff,
}) async => await homeRepository.getStaffAccess(staff: staff);
}
import 'package:either_dart/either.dart';
import 'package:my_office/features/home/domain/repository/home_repository.dart';

import '../../../../core/utilities/response/error_response.dart';
import '../../presentation/view_model/custom_punch_model.dart';

class GetPunchingTimeCase {
  final HomeRepository homeRepository;

  GetPunchingTimeCase({required this.homeRepository});

  Future<Either<ErrorResponse, CustomPunchModel?>> execute(
    String staffId,
    String name,
    String department,
  ) async =>
      await homeRepository.getPunchingTime(staffId, name, department);
}
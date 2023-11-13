import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/staff_details/domain/repository/staff_detail_repository.dart';

class RemoveStaffDetailCase{
  final StaffDetailRepository staffDetailRepository;

  RemoveStaffDetailCase({required this.staffDetailRepository});

  Future<Either<ErrorResponse, bool>> execute(String uid) async{
    return await staffDetailRepository.removeStaffDetails(uid);
  }
}
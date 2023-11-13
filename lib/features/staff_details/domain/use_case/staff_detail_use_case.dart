import 'package:either_dart/either.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/staff_details/data/model/staff_detail_model.dart';
import 'package:my_office/features/staff_details/domain/repository/staff_detail_repository.dart';

class StaffDetailCase{
  final StaffDetailRepository staffDetailRepository;

  StaffDetailCase({required this.staffDetailRepository});

  Future<List<StaffDetailModel>> execute() async{
    return staffDetailRepository.staffNames();
  }

}
import 'package:my_office/features/work_details/data/data_source/work_detail_fb_data_source.dart';
import 'package:my_office/features/work_details/data/model/work_detail_model.dart';
import 'package:my_office/features/work_details/domain/repository/work_detail_repository.dart';

class WorkDetailRepoImpl implements WorkDetailRepository{
  final WorkDetailFbDataSource workDetailFbDataSource;

  WorkDetailRepoImpl({required this.workDetailFbDataSource});


  @override
  Future<List<WorkDoneModel>> getWorkDetails(DateTime selectedDate)async {
    return await workDetailFbDataSource.getWorkDetails(selectedDate);
  }

}
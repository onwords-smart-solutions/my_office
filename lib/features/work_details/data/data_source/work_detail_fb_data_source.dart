import '../model/work_detail_model.dart';

abstract class WorkDetailFbDataSource{
  Future<List<WorkDoneModel>> getWorkDetails(DateTime selectedDate);
}
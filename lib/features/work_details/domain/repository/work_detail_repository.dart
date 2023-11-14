import '../../data/model/work_detail_model.dart';

abstract class WorkDetailRepository{
  Future<List<WorkDoneModel>> getWorkDetails(DateTime selectedDate);
}
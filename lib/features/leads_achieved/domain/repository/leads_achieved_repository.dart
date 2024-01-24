import 'package:my_office/features/leads_achieved/data/model/leads_achieved_model.dart';

abstract class LeadsAchievedRepository{
  Future<List<LeadsAchievedModel>> getPRStaffNames();
  Future<List<String>> getManagementList();
  Future <List<String>> allPr();
  Future<void> updateSaleTarget({
    required String uid,
    required String leadsTarget,
    required String leadsAchieved,
  });
}
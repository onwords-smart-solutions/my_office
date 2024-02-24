import '../model/leads_achieved_model.dart';

abstract class LeadsAchievedDataSource{
  Future <List<LeadsAchievedModel>> getPRStaffNames();
  Future <List<String>> allPr();
  Future <List<String>> getManagementList();
  Future<void> updateSaleTarget({
    required String uid,
    required String targetLeads,
    required String achievedLeads,
  });
}
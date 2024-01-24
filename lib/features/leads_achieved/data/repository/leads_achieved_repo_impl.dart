import 'package:my_office/features/leads_achieved/data/data_source/leads_achieved_fb_data_source.dart';
import 'package:my_office/features/leads_achieved/data/model/leads_achieved_model.dart';
import 'package:my_office/features/leads_achieved/domain/repository/leads_achieved_repository.dart';

class LeadsAchievedRepoImpl implements LeadsAchievedRepository{
  final LeadsAchievedDataSource leadsAchievedDataSource;

  LeadsAchievedRepoImpl(this.leadsAchievedDataSource);

  @override
  Future<List<LeadsAchievedModel>> getPRStaffNames() async {
    return await leadsAchievedDataSource.getPRStaffNames();
  }

  @override
  Future<List<String>> getManagementList() async {
    return await leadsAchievedDataSource.getManagementList();
  }

  @override
  Future<List<String>> allPr() async {
    return await leadsAchievedDataSource.allPr();
  }

  @override
  Future<void> updateSaleTarget({
    required String uid,
    required String leadsTarget,
    required String leadsAchieved,
  }) async {
    return await leadsAchievedDataSource.updateSaleTarget(
      uid: uid,
      targetLeads: leadsTarget,
      achievedLeads: leadsAchieved,
    );
  }
}
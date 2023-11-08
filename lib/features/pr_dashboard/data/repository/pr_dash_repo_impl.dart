import 'package:my_office/features/pr_dashboard/data/data_source/pr_dash_fb_data_source.dart';
import 'package:my_office/features/pr_dashboard/domain/entity/pr_dash_entity.dart';
import 'package:my_office/features/pr_dashboard/domain/repository/pr_dash_repository.dart';

class PrDashRepoImpl implements PrDashRepository{
  final PrDashFbDataSource _prDashFbDataSource;

  PrDashRepoImpl(this._prDashFbDataSource);

  @override
  Future<PrDashboardData> prDashboardDetails()async {
    return _prDashFbDataSource.fetchPrDashboardData();
  }

  @override
  Future<void> updatePrDashboard(context) async{
    return _prDashFbDataSource.updatePrDashboard(context);
  }

}
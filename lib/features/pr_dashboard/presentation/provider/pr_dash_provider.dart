import 'package:flutter/cupertino.dart';
import 'package:my_office/features/pr_dashboard/data/data_source/pr_dash_fb_data_source.dart';
import 'package:my_office/features/pr_dashboard/domain/use_case/pr_dashboard_details_use_case.dart';
import 'package:my_office/features/pr_dashboard/domain/use_case/update_pr_dashboard_use_case.dart';

import '../../domain/entity/pr_dash_entity.dart';

class PrDashProvider extends ChangeNotifier{
  final PrDashboardUseCase prDashboardUseCase;
  final UpdatePrDashboardCase _updatePrDashboardCase;

  PrDashProvider(this.prDashboardUseCase, this._updatePrDashboardCase);

  PrDashboardData? _prDashboardData;
  PrDashboardData? get prDashboardData => _prDashboardData;

  void fetchPrDashboardDetails() async {
    try {
      _prDashboardData = await prDashboardUseCase.fetchPrDashboardData();
      notifyListeners();
    } catch (e) {
      // Handle the error, possibly logging it or notifying the user
    }
  }
}
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:my_office/features/pr_bucket/domain/use_case/get_pr_names_case.dart';

import '../../domain/use_case/get_customer_data_case.dart';

class PrBucketProvider extends ChangeNotifier{
  final GetPrNamesCase getPrNamesCase;
  final GetCustomerDataCase getCustomerDataCase;
  List<String> _staffNames = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<String> get staffNames => _staffNames;

  PrBucketProvider(this.getPrNamesCase, this.getCustomerDataCase);

  Future<void> getPrNames() async{
    _isLoading = true;
    _staffNames = await getPrNamesCase.execute();
    _isLoading = false;
    notifyListeners();
  }

  Future<Map<String, List<Map<String, String>>>> allCustomerData(String prName)async{
    _isLoading = true;
    final getCustomerData = await getCustomerDataCase.execute(prName);
    _isLoading = false;
    notifyListeners();
    return getCustomerData;
  }
}
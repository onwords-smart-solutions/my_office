import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:my_office/features/pr_bucket/domain/use_case/bucket_values_case.dart';
import 'package:my_office/features/pr_bucket/domain/use_case/get_bucket_names_case.dart';
import 'package:my_office/features/pr_bucket/domain/use_case/get_pr_names_case.dart';

import '../../domain/use_case/get_customer_data_case.dart';

class PrBucketProvider extends ChangeNotifier{
  final GetPrNamesCase getPrNamesCase;
  final GetBucketNamesCase getBucketNamesCase;
  final BucketValuesCase bucketValuesCase;
  final GetCustomerDataCase getCustomerDataCase;
  List<String> _staffNames = [];
  List<dynamic> _bucketNames = [];
  List<dynamic> _bucketValues = [];
  List<dynamic> _getCustomerData = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<String> get staffNames => _staffNames;
  List<dynamic> get bucketNames => _bucketNames;
  List<dynamic> get bucketValues => _bucketValues;
  List<dynamic> get getCustomerData => _getCustomerData;

  PrBucketProvider(this.getPrNamesCase, this.getBucketNamesCase, this.bucketValuesCase, this.getCustomerDataCase);

  Future<void> getPrNames() async{
    _isLoading = true;
    _staffNames = await getPrNamesCase.execute();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> prBucketNames(String staffName) async {
    _isLoading = true;
    _bucketNames = await getBucketNamesCase.execute(staffName);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> bucketDataValues(String prName, String bucketName) async{
    _isLoading = true;
    _bucketValues = await bucketValuesCase.execute(prName, bucketName);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> allCustomerData(dynamic mobile)async{
    _isLoading = true;
    _getCustomerData = await getCustomerDataCase.execute(mobile);
    _isLoading = false;
    notifyListeners();
  }
}
import 'package:flutter/cupertino.dart';
import 'package:my_office/features/staff_details/data/model/staff_detail_model.dart';
import 'package:my_office/features/staff_details/domain/use_case/remove_staff_detail_use_case.dart';
import 'package:my_office/features/staff_details/domain/use_case/staff_detail_use_case.dart';

class StaffDetailProvider extends ChangeNotifier{
  final StaffDetailCase _staffDetailCase;
  final RemoveStaffDetailCase _removeStaffDetailCase;
  List<StaffDetailModel> allNames = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  StaffDetailProvider(this._staffDetailCase, this._removeStaffDetailCase);

  Future<void> getAllStaffNames()async{
    allNames = await _staffDetailCase.execute();
    notifyListeners();
    _isLoading = false;
  }

  Future<void> removeStaffDetails(String uid) async{
    _removeStaffDetailCase.execute(uid);
  }
}
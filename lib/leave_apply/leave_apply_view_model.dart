import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:my_office/home/home_view_model.dart';
import 'package:my_office/services/notification_service.dart';

import '../database/firebase_operation.dart';

class LeaveApplyViewModel {
  final HomeViewModel _homeViewModel = HomeViewModel();
  final NotificationService _firebaseNotification = NotificationService();
  final FirebaseOperation _firebaseService = FirebaseOperation();
  final _leaveRef = FirebaseDatabase.instance.ref('leave_details');

  List<String> leaveTypes = ['General', 'Sick', 'Permission'];

  Future<void> sendLeaveNotification(String title, String body, String name) async {
    List<String> members = [
      '58JIRnAbechEMJl8edlLvRzHcW52',
      'Ae6DcpP2XmbtEf88OA8oSHQVpFB2',
    ];
    final tl = await _homeViewModel.getTLList();
    final rndTl = await _homeViewModel.getManagementList();
    final mgmt = await _homeViewModel.getRNDTLList();

    List<String> names = [];
    names.addAll(tl);
    names.addAll(rndTl);
    names.addAll(mgmt);

    //removing name if applying staff contain in notification list
    names.remove(name);

    final ids = await _firebaseService.getUserId(userNames: names);
    members.addAll(ids);

    for (var id in members) {
      final tokens = await _firebaseNotification.getDeviceFcm(userId: id);
      for (var token in tokens) {
        await _firebaseNotification.sendNotification(
            type: NotificationType.leaveNotification, title: title, body: body, token: token);
      }
    }
  }

  Future<void> applyPermission({
    required DateTime date,
    required double duration,
    required String reason,
    required String uid,
    required String name,
    required String department,
    required Function refreshHistory,
  }) async {
    await _leaveRef.child('${date.year}/${_monthFormatter(date)}/${_dateFormatter(date)}/$uid/permission').set({
      'date': _dateFormatter(date),
      'status': 'Pending',
      'reason': reason,
      'duration': duration,
      'name': name,
      'dep': department,
    });
    refreshHistory();
    sendLeaveNotification('Permission Request', 'New permission has been applied by $name', name);
  }

  Future<void> applyLeave({
    required DateTime date,
    required String mode,
    required String type,
    required String reason,
    required String uid,
    required String name,
    required String department,
    required Function refreshHistory,
  }) async {
    await _leaveRef.child('${date.year}/${_monthFormatter(date)}/${_dateFormatter(date)}/$uid/${type.toLowerCase()}').set({
      'date': _dateFormatter(date),
      'status': 'Pending',
      'reason': reason,
      'mode': mode,
      'name': name,
      'dep': department,
    });
    refreshHistory();
    sendLeaveNotification('$type Leave Request', 'New $type leave has been applied by $name', name);
  }

  String _dateFormatter(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  String _monthFormatter(DateTime date) => DateFormat('MM').format(date);
}

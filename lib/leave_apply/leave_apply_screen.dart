import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/leave_apply/leave_form.dart';
import 'package:my_office/leave_apply/leave_history.dart';
import 'package:my_office/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../models/leave_history_model.dart';
import 'leave_apply_view_model.dart';

class LeaveApplyScreen extends StatefulWidget {
  const LeaveApplyScreen({Key? key}) : super(key: key);

  @override
  State<LeaveApplyScreen> createState() => _LeaveApplyScreenState();
}

class _LeaveApplyScreenState extends State<LeaveApplyScreen> {
  final ValueNotifier<List<LeaveHistoryModel>> _history = ValueNotifier([]);
  final ValueNotifier<bool> _loading = ValueNotifier(true);

  @override
  void initState() {
    _getLeaveHistory();
    super.initState();
  }

  @override
  void dispose() {
    _history.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leave Portal'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            splashRadius: 20.0,
          ),
          bottom: TabBar(
            enableFeedback: true,
            indicatorSize: TabBarIndicatorSize.tab,
            splashBorderRadius: BorderRadius.circular(15.0),
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.deepPurple,
            tabs: const [
              Tab(icon: Icon(Icons.description_rounded), text: 'New Leave'),
              Tab(icon: Icon(Icons.pending_actions_rounded), text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //leave form
            LeaveForm(getLeaveHistory: _getLeaveHistory),
            //leave history
            ValueListenableBuilder(
              valueListenable: _loading,
              builder: (ctx, loading, child) {
                return ValueListenableBuilder(
                  valueListenable: _history,
                  builder: (ctx, history, child) {
                    return (loading && history.isEmpty)
                        ? Center(
                            child: Lottie.asset(
                                "assets/animations/new_loading.json"))
                        : LeaveHistory(history: history);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getLeaveHistory() async {
    _history.value.clear();
    _loading.value = true;
    final context = this.context;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ref = FirebaseDatabase.instance.ref('leaveDetails');
    await ref
        .child('${userProvider.user!.uid}/leaveApplied')
        .once()
        .then((leave) {
      if (leave.snapshot.exists) {
        for (var year in leave.snapshot.children) {
          for (var month in year.children) {
            for (var day in month.children) {
              final info = day.value as Map<Object?, Object?>;
              final dateFromFb = info['date'].toString().split('-');
              final reason = info['reason'].toString();
              final status = info['status'].toString();
              final updatedBy = info['updated_by'] == null
                  ? ''
                  : info['updated_by'].toString();
              final date = DateTime(int.parse(dateFromFb[0]),
                  int.parse(dateFromFb[1]), int.parse(dateFromFb[2]), 0, 0);
              _history.value.add(
                LeaveHistoryModel(
                  date: date,
                  reason: reason,
                  status: status,
                  updatedBy: updatedBy,
                ),
              );
              _history.notifyListeners();
            }
          }
        }
      }
    });
    _loading.value = false;
  }
}

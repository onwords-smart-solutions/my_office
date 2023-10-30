import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/leave_apply/leave_apply_view_model.dart';
import 'package:my_office/provider/user_provider.dart';
import 'package:my_office/util/custom_snackbar.dart';
import 'package:provider/provider.dart';

class LeaveForm extends StatefulWidget {
  final Function getLeaveHistory;

  const LeaveForm({Key? key, required this.getLeaveHistory}) : super(key: key);

  @override
  State<LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  final _formKey = GlobalKey<FormState>();
  String _reason = '';
  double _duration = 0.0;
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final LeaveApplyViewModel _leaveApplyViewModel = LeaveApplyViewModel();

  final ValueNotifier<String> _leaveType = ValueNotifier('General');

  final ValueNotifier<String> _leaveMode = ValueNotifier('Full Day');

  final ValueNotifier<DateTime?> _fromDate = ValueNotifier(null);

  final ValueNotifier<DateTime?> _toDate = ValueNotifier(null);

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void dispose() {
    _isLoading.dispose();
    _toDate.dispose();
    _fromDate.dispose();
    _leaveMode.dispose();
    _leaveType.dispose();
    _reasonController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(15.0),
          children: [
            _heading('Leave Type'),
            _leaveTypeWidget(),
            const SizedBox(height: 20.0),
            ValueListenableBuilder(
              valueListenable: _leaveType,
              builder: (ctx, leaveType, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (leaveType == 'Permission') ...[
                      _heading('Duration'),
                      _durationWidget(),
                    ] else ...[
                      _heading('Leave Mode'),
                      SizedBox(
                        width: double.infinity,
                        child: _leaveModeWidget(),
                      ),
                      const SizedBox(height: 20.0),
                      _heading('From'),
                      _fromTimeWidget(),
                      const SizedBox(height: 20.0),
                      ValueListenableBuilder(
                        valueListenable: _leaveMode,
                        builder: (ctx, mode, child) {
                          return mode == 'Half Day'
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        _heading('To'),
                                        const Text(
                                          '  (optional)',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    _toTimeWidget(),
                                  ],
                                );
                        },
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 20.0),
            _heading('Reason'),
            _reasonField(),
            const SizedBox(height: 20.0),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _leaveTypeWidget() {
    return ValueListenableBuilder(
      valueListenable: _leaveType,
      builder: (ctx, leaveType, child) {
        return CupertinoSlidingSegmentedControl<String>(
          backgroundColor: Colors.white,
          thumbColor: Colors.deepPurple,
          groupValue: leaveType,
          children: {
            for (var type in _leaveApplyViewModel.leaveTypes)
              type: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  type,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: leaveType == type ? Colors.white : Colors.grey,
                  ),
                ),
              ),
          },
          onValueChanged: (value) => _leaveType.value = value!,
        );
      },
    );
  }

  Widget _leaveModeWidget() {
    return ValueListenableBuilder(
      valueListenable: _leaveMode,
      builder: (ctx, leaveMode, child) {
        return CupertinoSlidingSegmentedControl<String>(
          backgroundColor: Colors.white,
          thumbColor: Colors.deepPurple,
          groupValue: leaveMode,
          children: {
            'Full Day': Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Full Day',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: leaveMode == 'Full Day' ? Colors.white : Colors.grey,
                ),
              ),
            ),
            'Half Day': Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Half Day',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: leaveMode == 'Half Day' ? Colors.white : Colors.grey,
                ),
              ),
            ),
          },
          onValueChanged: (value) => _leaveMode.value = value!,
        );
      },
    );
  }

  Widget _fromTimeWidget() {
    return ListTile(
      onTap: () async {
        final date = await _getDate();
        if (date != null) {
          _fromDate.value = date;
        }
      },
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: ValueListenableBuilder(
        valueListenable: _fromDate,
        builder: (ctx, fromDate, child) {
          return Text(
            fromDate == null ? 'Pick Date' : _formatDate(fromDate),
            style: TextStyle(
              fontWeight: fromDate == null ? FontWeight.w500 : FontWeight.w700,
              color: fromDate == null ? Colors.grey : Colors.black,
            ),
          );
        },
      ),
      trailing: const Icon(
        Icons.calendar_month_rounded,
        color: Colors.grey,
      ),
    );
  }

  Widget _toTimeWidget() {
    return ListTile(
      onTap: () async {
        final date = await _getDate();
        if (date != null) {
          _toDate.value = date;
        }
      },
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: ValueListenableBuilder(
        valueListenable: _toDate,
        builder: (ctx, toDate, child) {
          return Text(
            toDate == null ? 'Pick Date' : _formatDate(toDate),
            style: TextStyle(
              fontWeight: toDate == null ? FontWeight.w500 : FontWeight.w700,
              color: toDate == null ? Colors.grey : Colors.black,
            ),
          );
        },
      ),
      trailing: const Icon(
        Icons.calendar_month_rounded,
        color: Colors.grey,
      ),
    );
  }

  Widget _reasonField() {
    return TextFormField(
      controller: _reasonController,
      key: const ValueKey('reason'),
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      textCapitalization: TextCapitalization.words,
      maxLines: 5,
      minLines: 3,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10.0),
        hintText: 'e.g. To get rid of stress',
        hintStyle: const TextStyle(
          fontFamily: 'sfPro',
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value.toString().trim().isEmpty) {
          return 'Provide reason for leave';
        }
        return null;
      },
      onSaved: (value) {
        _reason = value.toString().trim();
      },
    );
  }

  Widget _durationWidget() {
    return TextFormField(
      controller: _durationController,
      key: const ValueKey('duration'),
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.number,
      maxLength: 4,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        counter: const SizedBox.shrink(),
        contentPadding: const EdgeInsets.all(10.0),
        hintText: 'Time in hours',
        hintStyle: const TextStyle(
          fontFamily: 'sfPro',
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value.toString().trim().isEmpty) {
          return 'Provide duration';
        }
        return null;
      },
      onSaved: (value) {
        _duration = double.parse(value.toString().trim());
      },
    );
  }

  Widget _submitButton() {
    return ValueListenableBuilder(
      valueListenable: _isLoading,
      builder: (ctx, loading, child) {
        return loading
            ? const Center(
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  ),
                ),
              )
            : child!;
      },
      child: FilledButton(
        onPressed: _submitForm,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(15.0),
        ),
        child: ValueListenableBuilder(
          valueListenable: _leaveType,
          builder: (ctx, leaveType, child) {
            return ValueListenableBuilder(
              valueListenable: _fromDate,
              builder: (ctx, fromDate, child) {
                return ValueListenableBuilder(
                  valueListenable: _toDate,
                  builder: (ctx, toDate, child) {
                    String text = 'Apply leave';

                    if (leaveType == 'Permission') {
                      text = 'Request permission';
                    }
                    if (fromDate != null && toDate == null) {
                      text = 'Apply leave for 1 day';
                    }

                    if (fromDate != null && toDate != null) {
                      int count = 0;
                      for (DateTime date = fromDate;
                          date.isBefore(toDate) ||
                              date.isAtSameMomentAs(toDate);
                          date = date.add(const Duration(days: 1))) {
                        if (date.weekday != DateTime.sunday) {
                          count++;
                        }
                      }
                      if (count > 1) {
                        text = 'Apply leave for $count days';
                      } else {
                        text = 'Apply leave for 1 day';
                      }
                    }
                    return Text(
                      text,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _heading(String title) => Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
          color: Colors.grey,
        ),
      );

  String _formatDate(DateTime date) => DateFormat.yMMMEd().format(date);

  Future<DateTime?> _getDate() async {
    final today = DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(2300),
    );
  }

  //Functions
  Future<void> _submitForm() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      _isLoading.value = true;

      // -- permission --
      if (_leaveType.value == 'Permission') {
        await _leaveApplyViewModel.applyPermission(
          date: DateTime.now(),
          duration: _duration,
          reason: _reason,
          uid: user!.uid,
          name: user.name,
          department: user.department,
          refreshHistory: widget.getLeaveHistory,
        );
        if (!mounted) return;
        CustomSnackBar.showSuccessSnackbar(
          message: 'Permission has been applied',
          context: context,
        );
        _resetControllers();
      } else {
        // -- half day --
        if (_leaveMode.value == 'Half Day') {
          if (_fromDate.value == null) {
            _isLoading.value = false;
            CustomSnackBar.showErrorSnackbar(
              message: 'Please select from date',
              context: context,
            );
          } else {
            await _leaveApplyViewModel.applyLeave(
              date: _fromDate.value!,
              mode: _leaveMode.value,
              type: _leaveType.value,
              reason: _reason,
              uid: user!.uid,
              name: user.name,
              department: user.department,
              refreshHistory: widget.getLeaveHistory,
            );
            if (!mounted) return;
            CustomSnackBar.showSuccessSnackbar(
              message:
                  '${_leaveType.value} leave has been applied for ${_leaveMode.value}',
              context: context,
            );
            _resetControllers();
          }
        }
        // -- full day --
        else {
          if (_fromDate.value == null) {
            _isLoading.value = false;
            CustomSnackBar.showErrorSnackbar(
              message: 'Please select from date',
              context: context,
            );
          } else {
            if (_toDate.value != null) {
              for (DateTime date = _fromDate.value!;
                  date.isBefore(_toDate.value!) ||
                      date.isAtSameMomentAs(_toDate.value!);
                  date = date.add(const Duration(days: 1))) {
                if (date.weekday != DateTime.sunday) {
                  await _leaveApplyViewModel.applyLeave(
                    date: date,
                    mode: _leaveMode.value,
                    type: _leaveType.value,
                    reason: _reason,
                    uid: user!.uid,
                    name: user.name,
                    department: user.department,
                    refreshHistory: widget.getLeaveHistory,
                  );
                }
              }
              if (!mounted) return;
              CustomSnackBar.showSuccessSnackbar(
                message: '${_leaveType.value} leave has been applied',
                context: context,
              );
              _resetControllers();
            } else {
              //single day
              await _leaveApplyViewModel.applyLeave(
                date: _fromDate.value!,
                mode: _leaveMode.value,
                type: _leaveType.value,
                reason: _reason,
                uid: user!.uid,
                name: user.name,
                department: user.department,
                refreshHistory: widget.getLeaveHistory,
              );
              if (!mounted) return;
              CustomSnackBar.showSuccessSnackbar(
                message:
                    '${_leaveType.value} leave has been applied for ${_leaveMode.value}',
                context: context,
              );
              _resetControllers();
            }
          }
        }
      }
    }
  }

  void _resetControllers() {
    _isLoading.value = false;
    _fromDate.value = null;
    _toDate.value = null;
    _formKey.currentState!.reset();
    _reasonController.clear();
    _durationController.clear();
  }
}

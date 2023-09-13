import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:my_office/installation_entry/custom_button.dart';
import 'package:my_office/installation_entry/heading_textfield.dart';
import 'package:my_office/installation_entry/submit_form.dart';
import 'package:my_office/installation_entry/view_model.dart';
import 'package:my_office/provider/user_provider.dart';
import 'package:my_office/util/custom_snackbar.dart';
import 'package:provider/provider.dart';

class ClientLocationDetail extends StatefulWidget {
  final String uniqueId;
  final DateTime date;

  const ClientLocationDetail({Key? key, required this.uniqueId, required this.date}) : super(key: key);

  @override
  State<ClientLocationDetail> createState() => _ClientLocationDetailState();
}

class _ClientLocationDetailState extends State<ClientLocationDetail> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _reachedTime;
  DateTime? _workStartTime;
  DateTime? _workCompleteTime;
  final TextEditingController _reachedTimeController = TextEditingController();
  final TextEditingController _startingTimeController = TextEditingController();
  final TextEditingController _endingTimeController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ViewModel _viewModel = ViewModel();

  @override
  void dispose() {
    _isLoading.dispose();
    _reachedTimeController.dispose();
    _startingTimeController.dispose();
    _endingTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Entry Form',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          splashRadius: 20.0,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  HeadingTextFormField(
                    title: 'Time of arrival at client location',
                    readOnly: true,
                    onTap: () => _showTimePicker('reached'),
                    validator: (value) {
                      if (value.toString().trim().isEmpty) {
                        return 'Pick arrival time';
                      }
                      return null;
                    },
                    hintText: 'Pick time',
                    onSaved: (value) {
                      final today = DateTime.now();
                      DateTime date = DateFormat.jm().parse(value.toString().trim());
                      final convertedDate = DateTime(today.year, today.month, today.day, date.hour, date.minute);
                      _reachedTime = convertedDate;
                    },
                    controller: _reachedTimeController,
                  ),
                  const SizedBox(height: 20.0),
                  HeadingTextFormField(
                    title: 'Time of work initiated',
                    readOnly: true,
                    onTap: () => _showTimePicker('started'),
                    validator: (value) {
                      if (value.toString().trim().isEmpty) {
                        return 'Pick work initiated time';
                      }
                      return null;
                    },
                    hintText: 'Pick time',
                    onSaved: (value) {
                      final today = DateTime.now();
                      DateTime date = DateFormat.jm().parse(value.toString().trim());
                      final convertedDate = DateTime(today.year, today.month, today.day, date.hour, date.minute);
                      _workStartTime = convertedDate;
                    },
                    controller: _startingTimeController,
                  ),
                  const SizedBox(height: 20.0),
                  HeadingTextFormField(
                    title: 'Time of work completed',
                    readOnly: true,
                    onTap: () => _showTimePicker('ended'),
                    validator: (value) {
                      if (value.toString().trim().isEmpty) {
                        return 'Pick work completed time';
                      }
                      return null;
                    },
                    hintText: 'Pick time',
                    onSaved: (value) {
                      final today = DateTime.now();
                      DateTime date = DateFormat.jm().parse(value.toString().trim());
                      final convertedDate = DateTime(today.year, today.month, today.day, date.hour, date.minute);
                      _workCompleteTime = convertedDate;
                    },
                    controller: _endingTimeController,
                  ),
                ],
              ),
              //submit button
              ValueListenableBuilder(
                valueListenable: _isLoading,
                builder: (ctx, isLoading, child) {
                  return isLoading
                      ? const CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: SizedBox(
                            height: 30.0,
                            width: 30.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          ),
                        )
                      : child!;
                },
                child: CustomButton(onPressed: _submitForm, label: 'Next'),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showTimePicker(String mode) async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    final today = DateTime.now();
    final dateTime = DateTime(today.year, today.month, today.day, time.hour, time.minute);

    if (mode == 'reached') {
      _reachedTimeController.text = _formatDate(dateTime);
    } else if (mode == 'started') {
      _startingTimeController.text = _formatDate(dateTime);
    } else {
      _endingTimeController.text = _formatDate(dateTime);
    }
  }

  _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      _isLoading.value = true;
      FocusScope.of(context).unfocus();
      final status = await _viewModel.handleLocationPermission(context);
      if (status) {
        final data = await _viewModel.getCurrentPosition(context);
        if (data.isEmpty) {
          _isLoading.value = false;
          CustomSnackBar.showErrorSnackbar(message: 'Something went wrong. Try again!', context: context);
        } else {
          await _storeToFirebase(data[0] as Position, data[1] as String);
          if (!mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SubmitForm(
                trackerDate: widget.date,
                uniqueId: widget.uniqueId,
              ),
            ),
          );
          _isLoading.value = false;
        }
      } else {
        _isLoading.value = false;
      }
    }
  }

  Future<void> _storeToFirebase(Position position, String address) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await FirebaseDatabase.instance
        .ref('installation_tracker/${_dateFBFormat(widget.date)}/${userProvider.user!.uid}/${widget.uniqueId}')
        .update({
      'reached': _reachedTime!.millisecondsSinceEpoch,
      'stage': 2,
      'work_started': _workStartTime!.millisecondsSinceEpoch,
      'work_completed': _workCompleteTime!.millisecondsSinceEpoch,
      'work_location': {
        'address': address,
        'latitude': position.latitude,
        'longitude': position.longitude,
      }
    });
  }

  String _formatDate(DateTime date) => DateFormat.jm().format(date);

  String _dateFBFormat(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
}

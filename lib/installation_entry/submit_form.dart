import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:my_office/installation_entry/custom_button.dart';
import 'package:my_office/installation_entry/heading_textfield.dart';
import 'package:my_office/installation_entry/view_model.dart';
import 'package:my_office/main.dart';
import 'package:my_office/provider/user_provider.dart';
import 'package:my_office/util/custom_snackbar.dart';
import 'package:provider/provider.dart';

class SubmitForm extends StatefulWidget {
  final String uniqueId;
  final DateTime trackerDate;

  const SubmitForm({Key? key, required this.trackerDate, required this.uniqueId}) : super(key: key);

  @override
  State<SubmitForm> createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startedTime;
  DateTime? _reachedTime;
  final TextEditingController _startingTimeController = TextEditingController();
  final TextEditingController _endingTimeController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ViewModel _viewModel = ViewModel();

  @override
  void dispose() {
    _isLoading.dispose();
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
                    title: 'Time of start journey from client location',
                    readOnly: true,
                    onTap: () => _showTimePicker(true),
                    validator: (value) {
                      if (value.toString().trim().isEmpty) {
                        return 'Pick time of start journey';
                      }
                      return null;
                    },
                    hintText: 'Pick time',
                    onSaved: (value) {
                      final today = DateTime.now();
                      DateTime date = DateFormat.jm().parse(value.toString().trim());
                      final convertedDate = DateTime(today.year, today.month, today.day, date.hour, date.minute);
                      _startedTime = convertedDate;
                    },
                    controller: _startingTimeController,
                  ),
                  const SizedBox(height: 20.0),
                  HeadingTextFormField(
                    title: 'Time of reached office',
                    readOnly: true,
                    onTap: () => _showTimePicker(false),
                    validator: (value) {
                      if (value.toString().trim().isEmpty) {
                        return 'Pick reached time';
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
                child: CustomButton(onPressed: _submitForm, label: 'Submit form'),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showTimePicker(bool isStart) async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    final today = DateTime.now();
    final dateTime = DateTime(today.year, today.month, today.day, time.hour, time.minute);

    if (isStart) {
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
          Navigator.of(context)
              .pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const AuthenticationScreen()), (route) => false);
        }
      } else {
        _isLoading.value = false;
      }
    }
  }

  Future<void> _storeToFirebase(Position position, String address) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await FirebaseDatabase.instance
        .ref('installation_tracker/${_dateFBFormat(widget.trackerDate)}/${userProvider.user!.uid}/${widget.uniqueId}')
        .update({
      'stage': 3,
      'started_from_client': _startedTime!.millisecondsSinceEpoch,
      'reached_office': _reachedTime!.millisecondsSinceEpoch,
      'office_location': {
        'address': address,
        'latitude': position.latitude,
        'longitude': position.longitude,
      }
    });
  }

  String _formatDate(DateTime date) => DateFormat.jm().format(date);

  String _dateFBFormat(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
}

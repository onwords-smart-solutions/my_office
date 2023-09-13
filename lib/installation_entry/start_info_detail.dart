import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:my_office/installation_entry/client_location_detail.dart';
import 'package:my_office/installation_entry/custom_button.dart';
import 'package:my_office/installation_entry/heading_textfield.dart';
import 'package:my_office/installation_entry/view_model.dart';
import 'package:my_office/provider/user_provider.dart';
import 'package:my_office/util/custom_snackbar.dart';
import 'package:provider/provider.dart';

class StartInfoDetail extends StatefulWidget {
  const StartInfoDetail({Key? key}) : super(key: key);

  @override
  State<StartInfoDetail> createState() => _StartInfoDetailState();
}

class _StartInfoDetailState extends State<StartInfoDetail> {
  final _formKey = GlobalKey<FormState>();
  String _crewName = '';
  DateTime? _startTime;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startingTimeController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ViewModel _viewModel = ViewModel();

  @override
  void dispose() {
    _isLoading.dispose();
    _nameController.dispose();
    _startingTimeController.dispose();
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
                  //support crew name
                  HeadingTextFormField(
                    textCapitalization: TextCapitalization.words,
                    title: 'Support Crew',
                    validator: (value) {
                      return null;
                    },
                    hintText: 'Crew name',
                    onSaved: (value) {
                      _crewName = value.toString().trim();
                    },
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20.0),
                  //starting time
                  HeadingTextFormField(
                    title: 'Time of starting from office',
                    readOnly: true,
                    onTap: _showTimePicker,
                    validator: (value) {
                      if (value.toString().trim().isEmpty) {
                        return 'Pick start time';
                      }
                      return null;
                    },
                    hintText: 'Pick time',
                    onSaved: (value) {
                      final today = DateTime.now();
                      DateTime date = DateFormat.jm().parse(value.toString().trim());
                      final convertedDate = DateTime(today.year, today.month, today.day, date.hour, date.minute);
                      _startTime = convertedDate;
                    },
                    controller: _startingTimeController,
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

  _showTimePicker() async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    final today = DateTime.now();
    final dateTime = DateTime(today.year, today.month, today.day, time.hour, time.minute);

    _startingTimeController.text = _formatDate(dateTime);
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
          final id = generateRandomString(20);
          await _storeToFirebase(data[0] as Position, data[1] as String, id);
          if (!mounted) return;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ClientLocationDetail(
                    date: _startTime!,
                    uniqueId: id,
                  )));
          _isLoading.value = false;
        }
      } else {
        _isLoading.value = false;
      }
    }
  }

  Future<void> _storeToFirebase(Position position, String address, String id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await FirebaseDatabase.instance
        .ref('installation_tracker/${_dateFBFormat(_startTime!)}/${userProvider.user!.uid}/$id')
        .set({
      'date': _startTime!.millisecondsSinceEpoch,
      'crew': _crewName,
      'in_charge': userProvider.user!.name,
      'stage': 1,
      'starting_location': {
        'address': address,
        'latitude': position.latitude,
        'longitude': position.longitude,
      }
    });
  }

  String _formatDate(DateTime date) => DateFormat.jm().format(date);

  String _dateFBFormat(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  String generateRandomString(int length) {
    const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final buffer = StringBuffer();

    for (var i = 0; i < length; i++) {
      buffer.write(charset[random.nextInt(charset.length)]);
    }
    return buffer.toString();
  }
}

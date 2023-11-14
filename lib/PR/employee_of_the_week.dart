import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/util/custom_snackbar.dart';

import '../Constant/colors/constant_colors.dart';
import '../models/staff_entry_model.dart';
import '../util/main_template.dart';

class BestEmployee extends StatefulWidget {
  const BestEmployee({super.key});

  @override
  State<BestEmployee> createState() => _BestEmployeeState();
}

class _BestEmployeeState extends State<BestEmployee> {
  TextEditingController employeeName = TextEditingController();
  TextEditingController reason = TextEditingController();
  List<StaffAttendanceModel> allStaffs = [];
  bool isLoading = true;
  bool showReasonField = true;
  StaffAttendanceModel? selectedStaff;
  late String prNameToUid = '';

  //Getting staff names form db
  void allStaffNames() {
    allStaffs.clear();

    allStaffs.add(
      StaffAttendanceModel(
        uid: '',
        department: '',
        name: 'None',
        profileImage: '',
        emailId: '',
      ),
    );

    var ref = FirebaseDatabase.instance.ref();
    ref.child('staff').once().then((values) {
      for (var uid in values.snapshot.children) {
        var names = uid.value as Map<Object?, Object?>;
        final staffNames = StaffAttendanceModel(
          uid: uid.key.toString(),
          department: names['department'].toString(),
          name: names['name'].toString(),
          profileImage: names['profileImage'].toString(),
          emailId: names['email'].toString(),
        );
        if (staffNames.name != 'Nikhil Deepak') {
          allStaffs.add(staffNames);
        }
      }
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  //Update PR employee of the week
  Future<void> updatePrNameReason() async {
    var employee = allStaffs.firstWhere(
      (element) => element.name == selectedStaff!.name,
    );

    log('Staff names are ${employee.uid}');

    if (employee.uid.isEmpty || employee.uid == 'None') {
        final ref = FirebaseDatabase.instance.ref();
        await ref.child('PRDashboard/employee_of_week').update({
          'person': '',
          'reason': '',
        });
        if (!mounted) return;
        CustomSnackBar.showSuccessSnackbar(
          message: 'Employee data has been set to None',
          context: context,
        );
        Navigator.pop(context);
      } else if (reason.text.isEmpty) {
        CustomSnackBar.showErrorSnackbar(
          message: 'Enter all employee details!',
          context: context,
        );
      } else {
      final ref = FirebaseDatabase.instance.ref();
      await ref.child('PRDashboard/employee_of_week').update({
        'person': employee.uid,
        'reason':  reason.text,
      });
      if(!mounted) return;
      CustomSnackBar.showSuccessSnackbar(
        message: 'Employee details has been updated',
        context: context,
      );
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    allStaffNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      templateBody: buildBestEmployeeDetail(),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget buildBestEmployeeDetail() {
    List<DropdownMenuItem<StaffAttendanceModel>> staffNames =
        <DropdownMenuItem<StaffAttendanceModel>>[];
    for (final StaffAttendanceModel names in allStaffs) {
      staffNames.add(
        DropdownMenuItem<StaffAttendanceModel>(
          value: names,
          child: Text(names.name),
          // Additional styling if needed
        ),
      );
    }

    return SafeArea(
      minimum: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Center(
            child: Text(
              'Employee of the week details'.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.deepPurple,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButtonFormField<StaffAttendanceModel>(
              hint: const Text(
                'Staff Names',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              value: selectedStaff,
              items: staffNames,
              onChanged: (StaffAttendanceModel? newValue) {
                setState(() {
                  selectedStaff = newValue;
                  showReasonField = newValue?.name != 'None';
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: CupertinoColors.systemGrey,
                    width: 2,
                  ),
                ),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: const EdgeInsets.all(15),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: CupertinoColors.systemGrey,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: CupertinoColors.systemPurple,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                errorStyle: const TextStyle(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (showReasonField)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style: const TextStyle(),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                controller: reason,
                maxLines: 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: CupertinoColors.systemGrey,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: CupertinoColors.systemPurple,
                      width: 2,
                    ),
                  ),
                  hintText: 'Reason',
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: updatePrNameReason,
            child: const Text(
              'Update',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

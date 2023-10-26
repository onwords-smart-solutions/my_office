import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  StaffAttendanceModel? selectedStaff;
  late String prNameToUid = '';

  //Getting staff names form db
  void allStaffNames() {
    allStaffs.clear();
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
        if (staffNames.name != "Nikhil Deepak") {
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
    var selectedEmployee =
        allStaffs.firstWhere((element) => element.name == employeeName.text);
    prNameToUid = selectedEmployee.uid;

    if (prNameToUid.isEmpty || reason.text.isEmpty) {
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'Enter all employee data!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final ref = FirebaseDatabase.instance.ref();
      await ref.child('PRDashboard/employee_of_week').update({
        'person': prNameToUid,
        'reason': reason.text,
      });
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'Best employee data has been updated!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    final List<DropdownMenuEntry<StaffAttendanceModel>> staffNames =
        <DropdownMenuEntry<StaffAttendanceModel>>[];
    for (final StaffAttendanceModel names in allStaffs) {
      staffNames.add(
        DropdownMenuEntry<StaffAttendanceModel>(
          value: names,
          label: names.name,
          style: ButtonStyle(
            shape: MaterialStateProperty.resolveWith((states) {
              OutlineInputBorder(borderRadius: BorderRadius.circular(10));
              return null;
            }),
            textStyle: MaterialStateProperty.resolveWith(
              (states) => const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
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
          DropdownMenu<StaffAttendanceModel>(
            width: MediaQuery.sizeOf(context).width * 0.9,
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                    color: CupertinoColors.systemGrey, width: 2,
                ),
              ),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              contentPadding: const EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                    color: CupertinoColors.systemGrey, width: 2,
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
            menuHeight: MediaQuery.sizeOf(context).height * 0.4,
            menuStyle: MenuStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Colors.purple.shade50,
              ),
              padding: MaterialStateProperty.resolveWith(
                (states) => const EdgeInsets.symmetric(horizontal: 10),
              ),
              elevation: MaterialStateProperty.resolveWith((states) => 10),
            ),
            textStyle: const TextStyle(),
            enableFilter: true,
            hintText: 'Staff name',
            controller: employeeName,
            label: Text(
              'Staff name',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ),
            dropdownMenuEntries: staffNames,
            onSelected: (StaffAttendanceModel? name) {
              FocusScope.of(context).unfocus();
              setState(() {
                selectedStaff = name;
              });
            },
          ),
          const SizedBox(height: 20),
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

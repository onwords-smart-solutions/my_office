import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/util/main_template.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import '../Constant/colors/constant_colors.dart';
import '../models/staff_entry_model.dart';

class ProxyAttendance extends StatefulWidget {
  final String uid;
  final String name;

  const ProxyAttendance({super.key, required this.uid, required this.name});

  @override
  State<ProxyAttendance> createState() => _ProxyAttendanceState();
}

class Data {
  String label;
  Color color;

  Data(this.label, this.color);
}

class _ProxyAttendanceState extends State<ProxyAttendance> {
  StaffAttendanceModel? selectedStaff;
  List<StaffAttendanceModel> allStaffs = [];
  bool isLoading = true;
  bool isMngTea = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _depController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime dateStamp = DateTime.now();
  DateTime? initialTime;

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

  int? _selectedIndex;
  final List<Data> _choiceChipsList = [
    Data('Check-in', Colors.grey.shade400),
    Data('Check-out', Colors.grey.shade400),
  ];

  //time picker for proxy
  void timePicker() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (!mounted) return;
    if (pickedTime != null) {
      DateTime parsedTime = DateTime(
        dateStamp.year,
        dateStamp.month,
        dateStamp.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      setState(() {
        initialTime = parsedTime;
      });
    }
  }

  //date picker for proxy
  void dateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        dateStamp = pickedDate;
      });
    } else {
      print('Date is not selected');
    }
  }

  @override
  void initState() {
    allStaffNames();
    _dateController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Proxy attendance for employees',
      templateBody: buildProxyAttendance(),
      bgColor: ConstantColor.background1Color,
    );
  }

  buildProxyAttendance() {
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

    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return allStaffs.isEmpty
        ? Center(
      child: Lottie.asset(
        'assets/animations/new_loading.json',
      ),
    )
        : SingleChildScrollView(
      padding: EdgeInsets.only(
        left: width * 0.05,
        right: width * 0.05,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          SizedBox(
            height: height * 0.3,
            child: const Image(
              image: AssetImage('assets/proxy_screen.png'),
            ),
          ),
          SizedBox(height: height * 0.02),
          //staff name drop down
          DropdownMenu<StaffAttendanceModel>(
            width: width * 0.9,
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.black),
              ),
              labelStyle: const TextStyle(),
              contentPadding: const EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.black),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.red),
              ),
              errorStyle: const TextStyle(),
            ),

            requestFocusOnTap: true,
            menuHeight: height * 0.4,
            menuStyle: MenuStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.purple.shade50,
              ),
              padding: MaterialStateProperty.resolveWith(
                    (states) => const EdgeInsets.symmetric(horizontal: 10),
              ),
              elevation:
              MaterialStateProperty.resolveWith((states) => 10),
            ),
            textStyle: const TextStyle(),
            enableFilter: true,
            hintText: 'Staff name',
            // errorText: 'Select a staff name',
            controller: _nameController,
            label: const Text('Staff name'),
            dropdownMenuEntries: staffNames,
            onSelected: (StaffAttendanceModel? name) {
              FocusScope.of(context).unfocus();
              setState(() {
                selectedStaff = name;
              });
            },
          ),
          SizedBox(height: height * 0.02),
          //time picker
          ListTile(
            tileColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.black),
            ),
            autofocus: false,
            onTap: timePicker,
            title: Text(
              initialTime == null
                  ? 'Select time'
                  : DateFormat('hh:mm a').format(initialTime!),
              style: TextStyle(
                color: initialTime == null ? Colors.grey : Colors.black,
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          //date picker
          ListTile(
            tileColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.black),
            ),
            autofocus: false,
            onTap: dateTime,
            trailing: IconButton(
              onPressed: dateTime,
              icon: Icon(
                Icons.date_range,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(
              DateFormat('yyyy-MM-dd').format(dateStamp),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          //reason
          SizedBox(
            width: width * 0.9,
            child: TextFormField(
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              controller: _reasonController,
              autofocus: false,
              keyboardType: TextInputType.name,
              maxLines: 2,
              style: const TextStyle(
                // height: height * 0.0025,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15),
                border: InputBorder.none,
                hintText: 'Reason for Proxy entry..',
                hintStyle: const TextStyle(
                  // height: height * 0.005,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: ConstantColor.background1Color,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: ConstantColor.blackColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          //check in and check out selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Wrap(
                spacing: 6,
                direction: Axis.horizontal,
                children: choiceChips(),
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          //confirmation slider
          ConfirmationSlider(
            height: 60,
            backgroundColor: ConstantColor.background1Color,
            foregroundColor: ConstantColor.background1Color,
            backgroundShape: BorderRadius.circular(40),
            onConfirmation: () {
              saveToDb();
            },
            textStyle: const TextStyle(
              fontSize: 16,
            ),
            text: 'SLIDE TO CONFIRM',
            sliderButtonContent: const Icon(
              CupertinoIcons.person_alt_circle,
              size: 50,
              color: Colors.purple,
            ),
          ),
          SizedBox(height: height * 0.04),
        ],
      ),
    );
  }

  List<Widget> choiceChips() {
    List<Widget> chips = [];
    for (int i = 0; i < _choiceChipsList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChoiceChip(
          label: Text(_choiceChipsList[i].label),
          labelStyle: const TextStyle(color: Colors.white),
          backgroundColor: _choiceChipsList[i].color,
          selected: _selectedIndex == i,
          selectedColor: Colors.purple,
          showCheckmark: false,
          onSelected: (bool value) {
            setState(() {
              _selectedIndex = i;
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  Future<void> saveToDb() async {
    if (selectedStaff == null) {
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'Please select a staff name',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (initialTime == null) {
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'Please select time',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (_reasonController.text.isEmpty) {
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'Please give a valid reason',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (_selectedIndex == null) {
      final snackBar = SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'Please select check-in / check-out',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final year = DateFormat('yyyy').format(dateStamp);
      final month = DateFormat('MM').format(dateStamp);
      final date = DateFormat('dd').format(dateStamp);
      final pickedTime = DateFormat('HH:mm:ss').format(initialTime!);
      final ref = FirebaseDatabase.instance.ref();

      //Proxy check_in
      if (_choiceChipsList[_selectedIndex!].label == 'Check-in') {
        ref
            .child('attendance/$year/$month/$date/${selectedStaff!.uid}')
            .update({
          'check_in': pickedTime,
        });
        await ref
            .child(
          'attendance/$year/$month/$date/${selectedStaff!.uid}/proxy_in',)
            .update({
          'reason': _reasonController.text,
          'proxy_by': widget.name,
        });
        final snackBar = SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Staff attendance for ${selectedStaff?.name} has been registered',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _reasonController.clear();
        setState(() {
          _nameController.clear();
          _depController.clear();
          _selectedIndex = null;
          initialTime = null;
          dateStamp = DateTime.now();
        });
      } else {
        //Proxy check_out
        ref
            .child('attendance/$year/$month/$date/${selectedStaff!.uid}')
            .update({
          'check_out': pickedTime,
        });
        await ref
            .child(
          'attendance/$year/$month/$date/${selectedStaff!.uid}/proxy_out',)
            .update({
          'reason': _reasonController.text,
          'proxy_by': widget.name,
        });
        final snackBar = SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Staff attendance for ${selectedStaff?.name} has been registered',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _reasonController.clear();
        setState(() {
          _nameController.clear();
          _depController.clear();
          _selectedIndex = null;
          initialTime = null;
          dateStamp = DateTime.now();
        });
      }
    }
  }
}
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/features/proxy_attendance/data/model/proxy_attendance_model.dart';
import 'package:my_office/features/proxy_attendance/presentation/provider/proxy_attendance_provider.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import '../../../../core/utilities/constants/app_main_template.dart';
import '../../../../core/utilities/custom_widgets/custom_snack_bar.dart';

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
  ProxyAttendanceModel? selectedStaff;
  List<ProxyAttendanceModel> allStaffs = [];
  bool isLoading = true;
  bool isMngTea = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _depController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime dateStamp = DateTime.now();
  DateTime? initialTime;

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

  late Future<List<ProxyAttendanceModel>> _staffFuture;

  @override
  void initState() {
    _staffFuture = Provider.of<ProxyAttendanceProvider>(context, listen: false)
        .fetchAllStaffNames();
    _dateController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Proxy attendance for employees',
      templateBody: buildProxyAttendance(),
      bgColor: AppColor.backGroundColor,
    );
  }

  buildProxyAttendance() {
    return FutureBuilder<List<ProxyAttendanceModel>>(
      future: _staffFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset(
              'assets/animations/new_loading.json',
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final staffNames = snapshot.data!
              .map(
                (staff) =>
                DropdownMenuEntry<ProxyAttendanceModel>(
                  value: staff,
                  label: staff.name,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.resolveWith((states) {
                      OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10));
                      return null;
                    }),
                    textStyle: MaterialStateProperty.resolveWith(
                          (states) =>
                      const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
          )
              .toList();

          var height = MediaQuery
              .sizeOf(context)
              .height;
          var width = MediaQuery
              .sizeOf(context)
              .width;
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: width * 0.05,
              right: width * 0.05,
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom,
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
                DropdownMenu<ProxyAttendanceModel>(
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
                          (states) =>
                      const EdgeInsets.symmetric(horizontal: 10),
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
                  onSelected: (ProxyAttendanceModel? name) {
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
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
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
                      fillColor: AppColor.backGroundColor,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
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
                  backgroundColor: AppColor.backGroundColor,
                  foregroundColor: AppColor.backGroundColor,
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
        else {
          return const Text('No staff details found');
        }
      },
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
          final proxyProvider =
              Provider.of<ProxyAttendanceProvider>(context, listen: false);
          if (selectedStaff == null) {
            CustomSnackBar.showErrorSnackbar(
              message: 'Select a staff name!!',
              context: context,
            );
          } else if (initialTime == null) {
            CustomSnackBar.showErrorSnackbar(
              message: 'Select a time for Proxy!!',
              context: context,
            );
          } else if (_reasonController.text.isEmpty) {
            CustomSnackBar.showErrorSnackbar(
              message: 'Provide a valid reason for Proxy!!',
              context: context,
            );
          } else if (_selectedIndex == null) {
            CustomSnackBar.showErrorSnackbar(
              message: 'Choose one type Check-in/Check-out!!',
              context: context,
            );
          } else {
            //Proxy check_in
            if (_choiceChipsList[_selectedIndex!].label == 'Check-in') {
             await proxyProvider.updateCheckInProxy(
               selectedStaff!.uid,
               initialTime!,
               _reasonController.text,
               widget.name,
             );
             if(!mounted) return;
              CustomSnackBar.showSuccessSnackbar(
                message:
                    'Staff attendance for ${selectedStaff?.name} has been registered',
                context: context,
              );
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
              if (_choiceChipsList[_selectedIndex!].label == 'Check-out') {
                await proxyProvider.updateCheckOutProxy(
                  selectedStaff!.uid,
                  initialTime!,
                  _reasonController.text,
                  widget.name,
                );
                if (!mounted) return;
                CustomSnackBar.showSuccessSnackbar(
                  message:
                  'Staff attendance for ${selectedStaff
                      ?.name} has been registered',
                  context: context,
                );
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
}

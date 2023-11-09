import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/features/employee_of_the_week/presentation/provider/employee_of_the_week_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/utilities/constants/app_color.dart';
import '../../../../core/utilities/constants/app_main_template.dart';
import '../../data/model/employee_model.dart';

class BestEmployee extends StatefulWidget {
  const BestEmployee({super.key});

  @override
  State<BestEmployee> createState() => _BestEmployeeState();
}

class _BestEmployeeState extends State<BestEmployee> {
  TextEditingController employeeName = TextEditingController();
  TextEditingController reason = TextEditingController();
  EmployeeModel? selectedStaff;
  late Future<List<EmployeeModel>> _staffFuture;

  @override
  void initState() {
    _staffFuture =  Provider.of<EmployeeProvider>(context, listen: false).fetchAllStaff();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      templateBody: buildBestEmployeeDetail(),
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget buildBestEmployeeDetail() {

    return FutureBuilder<List<EmployeeModel>>(
      future: _staffFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Center(
            child: Lottie.asset(
              'assets/animations/new_loading.json',
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final staffNames = snapshot.data!
              .map(
                (staff) => DropdownMenuEntry<EmployeeModel>(
                  value: staff,
                  label: staff.name,
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
              )
              .toList();

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
                DropdownMenu<EmployeeModel>(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  inputDecorationTheme: InputDecorationTheme(
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
                  menuHeight: MediaQuery.sizeOf(context).height * 0.4,
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
                  controller: employeeName,
                  label: Text(
                    'Staff name',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  dropdownMenuEntries: staffNames,
                  onSelected: (EmployeeModel? name) {
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
                  onPressed: () =>
                      Provider.of<EmployeeProvider>(context, listen: false)
                          .updatePrNameReason(context),
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
        } else {
          return const Text('No staff details found');
        }
      },
    );
  }
}

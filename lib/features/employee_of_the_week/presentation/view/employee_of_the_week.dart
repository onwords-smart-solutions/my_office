import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_snack_bar.dart';
import 'package:my_office/core/utilities/response/error_response.dart';
import 'package:my_office/features/employee_of_the_week/data/data_source/employee_fb_data_source.dart';
import 'package:my_office/features/employee_of_the_week/data/data_source/employee_fb_data_source_impl.dart';
import 'package:my_office/features/employee_of_the_week/data/repository/employee_repo_impl.dart';
import 'package:my_office/features/employee_of_the_week/domain/repository/employee_repository.dart';
import 'package:my_office/features/employee_of_the_week/domain/use_case/update_pr_name_reason_use_case.dart';
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
  late String prNameToUid = '';
  late Future<List<EmployeeModel>> _staffFuture;
  bool showReasonField = true;

  late final EmployeeFbDataSource _employeeFbDataSource =
      EmployeeFbDataSourceImpl();
  late EmployeeRepository employeeRepository =
      EmployeeRepoImpl(_employeeFbDataSource);
  late UpdatePrNameReasonCase updatePrNameReasonCase =
      UpdatePrNameReasonCase(employeeRepository: employeeRepository);

  Future<void> updatePrNameReason() async {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    var selectedEmployee = provider.staff.firstWhere((element) => element.name == selectedStaff!.name);

    if (selectedEmployee.uid.isEmpty ||selectedEmployee.uid == 'None') {
      updatePrNameReasonCase.execute('', '');
      CustomSnackBar.showSuccessSnackbar(
        message: 'Employee details has been set to None!',
        context: context,
      );
      Navigator.pop(context);
    }else if(reason.text.isEmpty){
      CustomSnackBar.showErrorSnackbar(
        message: 'Enter all employee details!',
        context: context,
      );
    }
    else {
      try{
        updatePrNameReasonCase.execute(selectedEmployee.uid, reason.text);
      }catch(e){
        ErrorResponse(
          error: 'Error caught while updating Best employee details',
          metaInfo: 'Catch triggered while updating Best employee details',
        );
      }
      if (!mounted) return;
      CustomSnackBar.showSuccessSnackbar(
        message: 'Best employee data has been updated!',
        context: context,
      );
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    _staffFuture =
        Provider.of<EmployeeProvider>(context, listen: false).fetchAllStaff();
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
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    return FutureBuilder<List<EmployeeModel>>(
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
                (staff) => DropdownMenuItem<EmployeeModel>(
                  value: staff,
                  child: Text(staff.name),
                  // Additional styling if needed
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<EmployeeModel>(
                    hint: const Text(
                      'Staff Names',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    value: selectedStaff,
                    items: staffNames,
                    onChanged: (EmployeeModel? newValue) {
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
                if(showReasonField)
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
        } else {
          return const Text('No staff details found');
        }
      },
    );
  }
}

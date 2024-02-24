import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_app_button.dart';
import 'package:my_office/features/leads_achieved/data/data_source/leads_achieved_fb_data_source.dart';
import 'package:my_office/features/leads_achieved/data/data_source/leads_achieved_fb_data_source_impl.dart';
import 'package:my_office/features/leads_achieved/data/model/leads_achieved_model.dart';
import 'package:my_office/features/leads_achieved/data/repository/leads_achieved_repo_impl.dart';
import 'package:my_office/features/leads_achieved/domain/repository/leads_achieved_repository.dart';
import 'package:my_office/features/leads_achieved/presentation/view_model/leads_achieve_view_model.dart';
import '../../../../core/utilities/constants/app_color.dart';
import '../../../../core/utilities/constants/app_main_template.dart';
import '../../../../core/utilities/custom_widgets/custom_snack_bar.dart';


class LeadsAchieved extends StatefulWidget {
  const LeadsAchieved({super.key});

  @override
  State<LeadsAchieved> createState() => _LeadsAchievedState();
}

class _LeadsAchievedState extends State<LeadsAchieved> {
  LeadsAchievedModel? selectedStaff;
  String prUid = '';
  String telecallerUid = '';
  String dropdownCategoryValue = 'Choose';
  final TextEditingController _prNames = TextEditingController();
  final TextEditingController _telecallerNames = TextEditingController();
  final TextEditingController _prSaleTarget = TextEditingController();
  final TextEditingController _prSaleAchieved = TextEditingController();
  final TextEditingController _telecallerSaleTarget = TextEditingController();
  final TextEditingController _telecallerSaleAchieved = TextEditingController();
  DateTime dateStamp = DateTime.now();
  bool isLoading = true;
  final formKey = GlobalKey<FormState>();
  final LeadsAchievedViewModel leadsAchieved = LeadsAchievedViewModel();

  late Future<List<LeadsAchievedModel>> _staffFuture;
  late Future<List<String>> _staffs;
  late LeadsAchievedDataSource leadsAchievedDataSource =
  LeadsAchievedDataSourceImpl();
  late LeadsAchievedRepository leadsAchievedRepository =
  LeadsAchievedRepoImpl(leadsAchievedDataSource);

  List<LeadsAchievedModel> staffs = [];
  List<String> category = [
    'Gate',
    'Smart home',
    'Security systems',
    'Others',
  ];

  @override
  void initState() {
    _staffFuture = leadsAchievedRepository.getPRStaffNames();
    _staffs = leadsAchievedRepository.allPr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Sale count notify',
      templateBody: buildLeadsAchieved(),
      bgColor: AppColor.backGroundColor,
    );
  }

  buildLeadsAchieved(){
    final size = MediaQuery.sizeOf(context);
    return FutureBuilder<List<LeadsAchievedModel>>(
      future: _staffFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child:  Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ?
            Lottie.asset('assets/animations/loading_light_theme.json'):
            Lottie.asset('assets/animations/loading_dark_theme.json'),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final staffNames = snapshot.data!
              .map(
                (staff) =>
                DropdownMenuEntry<LeadsAchievedModel>(
                  value: staff,
                  label: staff.name,
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.resolveWith(
                          (states) =>
                          TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
          )
              .toList();
          return   SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.3,
                    child: SvgPicture.asset(
                      'assets/images/leads_screen.svg',
                    ),
                  ),
                  DropdownMenu<LeadsAchievedModel>(
                    width: size.width * 0.93,
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color:Theme.of(context).primaryColor.withOpacity(.3),width: 2),
                      ),
                      labelStyle:  TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      hintStyle: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(.4),
                      ),
                      contentPadding: const EdgeInsets.all(15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color:Theme.of(context).primaryColor.withOpacity(.3),width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color:Theme.of(context).primaryColor.withOpacity(.3),width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    requestFocusOnTap: true,
                    menuHeight: size.height * 0.3,
                    menuStyle: MenuStyle(
                      surfaceTintColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                      backgroundColor: MaterialStateProperty.resolveWith(
                            (states) =>
                        Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.grey.shade800 : Colors.grey.shade200,
                      ),
                    ),
                    textStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    enableFilter: true,
                    hintText: 'PR name',
                    controller: _prNames,
                    label: Text('PR name', style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor.withOpacity(.6),),),
                    dropdownMenuEntries: staffNames,
                    onSelected: (LeadsAchievedModel? name) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        selectedStaff = name;
                        prUid = name!.uid;
                        _prSaleTarget.text = name.leadsTarget;
                        _prSaleAchieved.text = name.leadsAchieved;
                      });
                    },
                  ),
                  const Gap(25),
                  DropdownMenu<LeadsAchievedModel>(
                    width: size.width * 0.93,
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color:Theme.of(context).primaryColor.withOpacity(.3),width: 2),
                      ),
                      labelStyle:  TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      hintStyle: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(.4),
                      ),
                      contentPadding: const EdgeInsets.all(15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color:Theme.of(context).primaryColor.withOpacity(.3),width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color:Theme.of(context).primaryColor.withOpacity(.3),width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    requestFocusOnTap: true,
                    menuHeight: size.height * 0.3,
                    menuStyle: MenuStyle(
                      surfaceTintColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                      backgroundColor: MaterialStateProperty.resolveWith(
                            (states) =>
                        Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ? Colors.grey.shade800 : Colors.grey.shade200,
                      ),
                    ),
                    textStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    enableFilter: true,
                    hintText: 'Telecaller name',
                    controller: _telecallerNames,
                    label: Text('Telecaller name', style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor.withOpacity(.6),),),
                    dropdownMenuEntries: staffNames,
                    onSelected: (LeadsAchievedModel? name) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        selectedStaff = name;
                        telecallerUid = name!.uid;
                        _telecallerSaleTarget.text = name.leadsTarget;
                        _telecallerSaleAchieved.text = name.leadsAchieved;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Gap(25),
                          SizedBox(
                            height: size.height * .1,
                            width: size.width * .43,
                            child: DropdownButtonFormField<String>(
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                                fontFamily: "SF Pro",
                              ),
                              decoration: InputDecoration(
                                label: Text(
                                  'Category',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor.withOpacity(.6),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "SF Pro",
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                                border: myInputBorder(),
                                enabledBorder: myInputBorder(),
                                focusedBorder: myFocusBorder(),
                                errorBorder: myErrorBorder(),
                                focusedErrorBorder: myFocusBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '';
                                }
                                return null;
                              },
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownCategoryValue = newValue!;
                                });
                              },
                              items: category.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "SF Pro",
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * .07,
                        width: size.width * .43,
                        child: ListTile(
                          tileColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color:Theme.of(context).primaryColor.withOpacity(.3),width: 2),
                          ),
                          autofocus: false,
                          onTap: dateTime,
                          contentPadding: const EdgeInsets.only(bottom: 10,left: 10),
                          title: IconButton(
                            onPressed: dateTime,
                            icon: Icon(
                              Icons.date_range,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          leading: Text(
                            DateFormat('yyyy-MM-dd').format(dateStamp),
                            style:  TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: size.height * 0.07,
                        width: size.width * 0.43,
                        child: TextField(
                          controller: _prSaleTarget,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onTap: () {},
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'PR sale target',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor.withOpacity(.4),
                            ),
                            label: Text(
                              'PR sale target',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor.withOpacity(.6),
                                fontWeight: FontWeight.w500,
                                fontFamily: "SF Pro",
                              ),
                            ),
                            border: myInputBorder(),
                            enabledBorder: myInputBorder(),
                            focusedBorder: myFocusBorder(),
                            disabledBorder: myDisabledBorder(),
                            errorBorder: myErrorBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.07,
                        width: size.width * 0.43,
                        child: TextField(
                          controller: _prSaleAchieved,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onTap: () {},
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'PR sale achieved',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor.withOpacity(.5),
                            ),
                            label: Text(
                              'PR sale achieved',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor.withOpacity(.6),
                                fontWeight: FontWeight.w500,
                                fontFamily: "SF Pro",
                              ),
                            ),
                            border: myInputBorder(),
                            enabledBorder: myInputBorder(),
                            focusedBorder: myFocusBorder(),
                            disabledBorder: myDisabledBorder(),
                            errorBorder: myErrorBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: size.height * 0.07,
                        width: size.width * 0.43,
                        child: TextField(
                          controller: _telecallerSaleTarget,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onTap: () {},
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'TC sale target',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor.withOpacity(.4),
                            ),
                            label: Text(
                              'TC sale target',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor.withOpacity(.6),
                                fontWeight: FontWeight.w500,
                                fontFamily: "SF Pro",
                              ),
                            ),
                            border: myInputBorder(),
                            enabledBorder: myInputBorder(),
                            focusedBorder: myFocusBorder(),
                            disabledBorder: myDisabledBorder(),
                            errorBorder: myErrorBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.07,
                        width: size.width * 0.43,
                        child: TextField(
                          controller: _telecallerSaleAchieved,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onTap: () {},
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'TC sale achieved',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor.withOpacity(.5),
                            ),
                            label: Text(
                              'TC sale achieved',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor.withOpacity(.6),
                                fontWeight: FontWeight.w500,
                                fontFamily: "SF Pro",
                              ),
                            ),
                            border: myInputBorder(),
                            enabledBorder: myInputBorder(),
                            focusedBorder: myFocusBorder(),
                            disabledBorder: myDisabledBorder(),
                            errorBorder: myErrorBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(30),
                  AppButton(
                    onPressed: notifyPrStaffs,
                    child: Text(
                      'Notify',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        else {
          return const Text('No staff details found');
        }
      },
    );
  }

  OutlineInputBorder myInputBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor.withOpacity(0.3),
        width: 2,
      ),
    );
  }

  OutlineInputBorder myFocusBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor.withOpacity(0.3),
        width: 2,
      ),
    );
  }

  OutlineInputBorder myErrorBorder(){
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        color: Colors.red.withOpacity(0.5),
        width: 2,
      ),
    );
  }

  OutlineInputBorder myDisabledBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor.withOpacity(0.3),
        width: 2,
      ),
    );
  }

  //Date picker for proxy
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
      print('Selected date is $dateStamp');
    } else {
      print('Date is not selected');
    }
  }

  Future<void> notifyPrStaffs() async {
    if(_prNames.text.isEmpty){
      CustomSnackBar.showErrorSnackbar(
        message: 'Select a PR name',
        context: context,
      );
    }else if(_telecallerNames.text.isEmpty){
      CustomSnackBar.showErrorSnackbar(
        message: 'Select a Telecaller name',
        context: context,
      );
    }else if(!formKey.currentState!.validate()){
      CustomSnackBar.showErrorSnackbar(
        message: 'Choose one category',
        context: context,
      );
    }else if(_prSaleTarget.text.isEmpty || _prSaleTarget.text.contains('null')){
      CustomSnackBar.showErrorSnackbar(
        message: 'Set a target for PR sale',
        context: context,
      );
    }else if(_prSaleAchieved.text.isEmpty || _prSaleAchieved.text.contains('null')){
      CustomSnackBar.showErrorSnackbar(
        message: 'Fill the PR achieved sale',
        context: context,
      );
    }else if(_telecallerSaleTarget.text.isEmpty || _telecallerSaleTarget.text.contains('null')){
      CustomSnackBar.showErrorSnackbar(
          message: 'Set a target for Telecaller sale',
          context: context,
      );
    }else if(_telecallerSaleAchieved.text.isEmpty || _telecallerSaleAchieved.text.contains('null')){
      CustomSnackBar.showErrorSnackbar(
        message: 'Fill the Telecaller achieved sale',
        context: context,
      );
    }else{
      List<LeadsAchievedModel> allStaffData = await leadsAchievedRepository.getPRStaffNames();
      LeadsAchievedModel pr = allStaffData.firstWhere((staff) => staff.uid == prUid);
      LeadsAchievedModel telecaller = allStaffData.firstWhere((staff) => staff.uid == telecallerUid);

      leadsAchievedRepository.updateSaleTarget(uid: pr.uid, leadsTarget: _prSaleTarget.text, leadsAchieved: _prSaleAchieved.text);
      leadsAchievedRepository.updateSaleTarget(uid: telecaller.uid, leadsTarget: _telecallerSaleTarget.text, leadsAchieved: _telecallerSaleAchieved.text);

      leadsAchieved.sendLeadsAchievedNotification('Sale achievement', '${_prNames.text} has achieved ${_prSaleAchieved.text}/${_prSaleTarget.text} sale & ${_telecallerNames.text} has achieved ${_telecallerSaleAchieved.text}/${_telecallerSaleTarget.text} sale.', '');
      CustomSnackBar.showSuccessSnackbar(
          message: 'Notification sent successfully',
          context: context,
      );
      Navigator.pop(context);
    }
  }
}

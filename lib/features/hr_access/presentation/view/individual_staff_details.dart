import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../core/utilities/constants/app_color.dart';
import '../../../../core/utilities/custom_widgets/custom_app_button.dart';
import '../../../../core/utilities/custom_widgets/custom_snack_bar.dart';
import '../../data/data_source/hr_access_fb_data_source.dart';
import '../../data/data_source/hr_access_fb_data_source_impl.dart';
import '../../data/model/hr_access_staff_model.dart';
import '../../data/repository/hr_access_repo_impl.dart';
import '../../domain/repository/hr_access_repository.dart';
import '../../domain/use_case/update_timing_for_employees_use_case.dart';

class IndividualStaffDetail extends StatefulWidget {
  final HrAccessModel allDetail;
  final List<HrAccessModel> allStaffData;

  const IndividualStaffDetail({
    super.key,
    required this.allDetail,
    required this.allStaffData,
  });

  @override
  State<IndividualStaffDetail> createState() => _IndividualStaffDetailState();
}

class _IndividualStaffDetailState extends State<IndividualStaffDetail> {
  TextEditingController punchIn = TextEditingController();
  TextEditingController punchOut = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? initialTime;
  late HrAccessFbDataSource hrAccessFbDataSource = HrAccessFbDataSourceImpl();
  late HrAccessRepository hrAccessRepository =
      HrAccessRepoImpl(hrAccessFbDataSource);
  late UpdateTimingForEmployeesCase updateTimingForEmployeesCase =
      UpdateTimingForEmployeesCase(hrAccessRepository: hrAccessRepository);

  void hrSetTimingForEmployees() {
    setState(() {
      punchIn.text = widget.allDetail.punchIn;
      punchOut.text = widget.allDetail.punchOut;
    });
    log('Punch in time : ${widget.allDetail.punchIn}');
    log('Punch out time : ${widget.allDetail.punchOut}');
  }

  Future<void> _startTimePicker(BuildContext context) async {
    TimeOfDay startTime = TimeOfDay(
      hour: int.parse(widget.allDetail.punchIn.split(':').first),
      minute: int.parse(widget.allDetail.punchIn.split(':').last),
    );
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    if (picked != null && picked != startTime) {
      setState(() {
        startTime = picked;
        DateTime dateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          picked.hour,
          picked.minute,
        );
        String formattedTime = DateFormat.Hm().format(dateTime);
        punchIn.text = formattedTime;
      });
    }
  }

  Future<void> _endTimePicker(BuildContext context) async {
    TimeOfDay endTime = TimeOfDay(
      hour: int.parse(widget.allDetail.punchOut.split(':').first),
      minute: int.parse(widget.allDetail.punchOut.split(':').last),
    );

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (picked != null && picked != endTime) {
      setState(() {
        endTime = picked;DateTime dateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          picked.hour,
          picked.minute,
        );
        String formattedTime = DateFormat.Hm().format(dateTime);
        punchOut.text = formattedTime;
      });
    }
  }

  Future<void> setTimingForStaffs() async {
    await updateTimingForEmployeesCase.execute(
      uid: widget.allDetail.uid,
      punchIn: punchIn.text,
      punchOut: punchOut.text,
    );
    final data = widget.allStaffData
        .firstWhere((element) => element.uid == widget.allDetail.uid);
    data.punchIn = punchIn.text;
    data.punchOut = punchOut.text;
    if (!mounted) return;
    CustomSnackBar.showSuccessSnackbar(
      message:
          'Timing for ${widget.allDetail.name} Punch in : ${punchIn.text} & Punch out : ${punchOut.text}',
      context: context,
    );
  }

  @override
  void initState() {
    hrSetTimingForEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var date = DateTime.fromMillisecondsSinceEpoch(widget.allDetail.dob!);
    var d24 = DateFormat('dd/MM/yyyy').format(date);

    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.chevron_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Staff detail',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  height: size.height * 0.3,
                  width: size.width * 0.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: widget.allDetail.profilePic!,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (
                        context,
                        url,
                        downloadProgress,
                      ) =>
                          CircularProgressIndicator(
                        color: AppColor.primaryColor,
                        strokeWidth: 2,
                        value: downloadProgress.progress,
                      ),
                      errorWidget: (context, url, error) => const Image(
                        image: AssetImage(
                          'assets/profile_pic.png',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(60),
              Row(
                children: [
                  SizedBox(width: size.width * 0.06),
                  const Text(
                    'Name  ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(width: size.width * 0.18),
                  SelectableText(
                    widget.allDetail.name,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xff7D7C7C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  SizedBox(width: size.width * 0.06),
                  const Text(
                    'Department  ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(width: size.width * 0.05),
                  SelectableText(
                    widget.allDetail.department,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xff7D7C7C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  SizedBox(width: size.width * 0.06),
                  const Text(
                    'Email id ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(width: size.width * 0.14),
                  Flexible(
                    child: SelectableText(
                      widget.allDetail.email,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xff7D7C7C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  SizedBox(width: size.width * 0.06),
                  const Text(
                    'Mobile   ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(width: size.width * 0.14),
                  Flexible(
                    child: SelectableText(
                      widget.allDetail.mobile.toString(),
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xff7D7C7C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  SizedBox(width: size.width * 0.06),
                  const Text(
                    'DOB       ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(width: size.width * 0.14),
                  Flexible(
                    child: SelectableText(
                      d24,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xff7D7C7C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  SizedBox(width: size.width * 0.06),
                  const Text(
                    'Punch in ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(width: size.width * 0.12),
                  SizedBox(
                    height: size.height * 0.04,
                    width: size.width * 0.15,
                    child: TextFormField(
                      controller: punchIn,
                      readOnly: true,
                      onTap: () => _startTimePicker(context),
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: Colors.black,
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
              const Gap(14),
              Row(
                children: [
                  SizedBox(width: size.width * 0.06),
                  const Text(
                    'Punch out',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(width: size.width * 0.10),
                  SizedBox(
                    height: size.height * 0.04,
                    width: size.width * 0.15,
                    child: TextField(
                      controller: punchOut,
                      readOnly: true,
                      onTap: () => _endTimePicker(context),
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: Colors.black,
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
              const Gap(60),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.06,
                width: MediaQuery.sizeOf(context).width * 0.6,
                child: AppButton(
                  onPressed: setTimingForStaffs,
                  child: const Text(
                    'Update time',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  UnderlineInputBorder myInputBorder() {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.3),
        width: 2,
      ),
    );
  }

  UnderlineInputBorder myFocusBorder() {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.3),
        width: 2,
      ),
    );
  }

  UnderlineInputBorder myDisabledBorder() {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.3),
        width: 2,
      ),
    );
  }

  UnderlineInputBorder myErrorBorder() {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red.withOpacity(0.5),
        width: 2,
      ),
    );
  }
}

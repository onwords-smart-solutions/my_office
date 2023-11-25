import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../core/utilities/constants/app_color.dart';
import '../../../../core/utilities/custom_widgets/custom_app_button.dart';
import '../../../../core/utilities/custom_widgets/custom_snack_bar.dart';
import '../../data/model/hr_access_staff_model.dart';

class IndividualStaffDetail extends StatefulWidget {
  final HrAccessModel allDetail;

  const IndividualStaffDetail({super.key, required this.allDetail});

  @override
  State<IndividualStaffDetail> createState() => _IndividualStaffDetailState();
}

class _IndividualStaffDetailState extends State<IndividualStaffDetail> {
  TextEditingController punchIn = TextEditingController();
  TextEditingController punchOut = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? initialTime;

  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 00);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 00);

  void regularTime(){
    setState(() {
      punchIn.text = startTime.format(context);
      punchOut.text = endTime.format(context);
    });
  }


  Future<void> _startTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    if (picked != null && picked != startTime) {
      setState(() {
        startTime = picked;
        punchIn.text = startTime.format(context);
      });
    }
  }

  Future<void> _endTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (picked != null && picked != endTime) {
      setState(() {
        endTime = picked;
        punchOut.text = endTime.format(context);
      });
    }
  }
  
  void setTimingForStaffs(){
    final ref = FirebaseDatabase.instance.ref();
   ref.child('staff/${widget.allDetail.uid}').update({
     'punch_in': punchIn.text,
     'punch_out': punchOut.text,
   });
    CustomSnackBar.showSuccessSnackbar(
      message: 'Timing has been updated for ${widget.allDetail.name}',
      context: context,
    );
  }

 @override
  void didChangeDependencies() {
    regularTime();
    super.didChangeDependencies();
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
              const Gap(10),
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
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const Gap(5),
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
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const Gap(5),
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
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(5),
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
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(5),
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
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(5),
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
                    height: size.height * 0.07,
                    width: size.width * 0.3,
                    child: TextFormField(
                      controller: punchIn,
                      readOnly: true,
                      onTap: ()=>_startTimePicker(context),
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
              const Gap(10),
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
                    height: size.height * 0.07,
                    width: size.width * 0.3,
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
              const Gap(20),
              AppButton(
                onPressed: setTimingForStaffs,
                child: const Text(
                  'Update time',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder myInputBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.3),
        width: 2,
      ),
    );
  }

  OutlineInputBorder myFocusBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.3),
        width: 2,
      ),
    );
  }

  OutlineInputBorder myDisabledBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.3),
        width: 2,
      ),
    );
  }

  OutlineInputBorder myErrorBorder(){
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      borderSide: BorderSide(
        color: Colors.red.withOpacity(0.5),
        width: 2,
      ),
    );
  }
}

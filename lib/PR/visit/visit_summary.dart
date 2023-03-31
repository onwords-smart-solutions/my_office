import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/PR/visit/visit_submit_screen.dart';
import 'package:my_office/models/visit_model.dart';
import 'package:image/image.dart' as ImageLib;
import '../../Constant/fonts/constant_font.dart';
import '../../util/screen_template.dart';

class VisitSummaryScreen extends StatefulWidget {
  final VisitModel visitData;

  const VisitSummaryScreen({Key? key, required this.visitData})
      : super(key: key);

  @override
  State<VisitSummaryScreen> createState() => _VisitSummaryScreenState();
}

class _VisitSummaryScreenState extends State<VisitSummaryScreen> {
  final TextEditingController _endKmController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _summaryNoteController = TextEditingController();

  File? endKmImage;

  int currentStep = 0;
  String step1Error = '';
  String step2Error = '';
  String step3Error = '';

  @override
  void dispose() {
    _dateController.dispose();
    _endKmController.dispose();
    _summaryNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
        bodyTemplate: buildMainScreen(), title: 'Visit Summary');
  }

  Widget buildMainScreen() {
    return Stepper(
        currentStep: currentStep > 3 ? 3 : currentStep,
        physics: const BouncingScrollPhysics(),
        onStepContinue: onStepContinue,
        onStepCancel: () {
          setState(() {
            currentStep = currentStep - 1;
          });
        },
        controlsBuilder: (BuildContext ctx, ControlsDetails details) {
          final buttonText = currentStep == 3 ? 'Continue' : 'Next';
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (currentStep > 0)
                CupertinoButton(
                    onPressed: details.onStepCancel,
                    child: Text(
                      'Back',
                      style: TextStyle(
                          fontFamily: ConstantFonts.poppinsMedium,
                          fontSize: 15.0,
                          color: Colors.grey),
                    )),
              ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff8355B7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  child: Text(buttonText,
                      style: TextStyle(
                        fontFamily: ConstantFonts.poppinsMedium,
                        fontSize: 15.0,
                      ))),
            ],
          );
        },
        steps: [
          visitSummaryNoteStep(),
          dateStep(),
          endKmStep(),
          summaryStep(),
        ]);
  }

  Step visitSummaryNoteStep() {
    final textStyle = currentStep == 0
        ? ConstantFonts.poppinsBold
        : ConstantFonts.poppinsMedium;
    final textColor = currentStep == 0 ? Colors.purple : Colors.black;

    return Step(
      title: Text(
        'Visit Summary Notes',
        style: TextStyle(fontFamily: textStyle, color: textColor),
      ),
      content: buildSummaryNote(),
      isActive: currentStep >= 0,
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
    );
  }

  Step dateStep() {
    final textStyle = currentStep == 1
        ? ConstantFonts.poppinsBold
        : ConstantFonts.poppinsMedium;
    final textColor = currentStep == 1 ? Colors.purple : Colors.black;

    return Step(
      title: Text(
        'Expected Date of Installation',
        style: TextStyle(fontFamily: textStyle, color: textColor),
      ),
      content: buildDateOfInstallation(),
      isActive: currentStep >= 1,
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
    );
  }

  Step endKmStep() {
    final textStyle = currentStep == 2
        ? ConstantFonts.poppinsBold
        : ConstantFonts.poppinsMedium;
    final textColor = currentStep == 2 ? Colors.purple : Colors.black;

    return Step(
      title: Text(
        'Travel Detail',
        style: TextStyle(fontFamily: textStyle, color: textColor),
      ),
      content: buildKmSection(),
      isActive: currentStep >= 2,
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
    );
  }

  Step summaryStep() {
    final textStyle = currentStep == 3
        ? ConstantFonts.poppinsBold
        : ConstantFonts.poppinsMedium;
    final textColor = currentStep == 3 ? Colors.purple : Colors.black;

    return Step(
      title: Text(
        'Summary',
        style: TextStyle(fontFamily: textStyle, color: textColor),
      ),
      content: buildSummary(),
      isActive: currentStep >= 3,
      state: currentStep > 3 ? StepState.complete : StepState.indexed,
    );
  }

  //on next button clicks in stepper
  void onStepContinue() {
    if (currentStep == 0) {
      if (_summaryNoteController.text.trim().isEmpty) {
        setState(() {
          step1Error = 'Add summary note';
        });
      } else {
        setState(() {
          step1Error = '';
          currentStep += 1;
        });
      }
    } else if (currentStep == 1) {
      if (_dateController.text.trim().isEmpty) {
        setState(() {
          step2Error = 'Choose a date';
        });
      } else {
        setState(() {
          step2Error = '';
          currentStep += 1;
        });
      }
    } else if (currentStep == 2) {
      if (_endKmController.text.trim().isEmpty) {
        setState(() {
          step3Error = 'Enter meter reading';
        });
      } else if (_endKmController.text.trim().length<6) {
        setState(() {
          step3Error = 'Enter a valid meter reading';
        });
      }else if (int.parse(_endKmController.text.trim())<=int.parse(widget.visitData.startKm.toString())){
        setState(() {
          step3Error = 'End Km should be greater than Start Km';
        });
      }

      else if (endKmImage == null) {
        setState(() {
          step3Error = 'Upload meter image';
        });
      } else {
        setState(() {
          step3Error = '';
          currentStep += 1;
        });
      }
    } else if (currentStep == 3) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => VisitSubmitScreen(
              visitData: widget.visitData,
              dateOfInstallation: _dateController.text.trim(),
              endKmImage: endKmImage!,
              endKm: int.parse(_endKmController.text.trim()),
              summaryNotes: _summaryNoteController.text.trim())));
    }
  }

  Widget buildSummaryNote() {
    return Column(
      children: [
        TextField(
          controller: _summaryNoteController,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 15.0,
              color: Colors.black),
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          maxLines: 6,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10.0),
            hintText: 'Add visit summary notes here',
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 1.5,
                color: Color(0xff8355B7),
              ),
            ),
          ),
        ),
        if (step1Error.isNotEmpty) showError(message: step1Error)
      ],
    );
  }

  Widget buildDateOfInstallation() {
    return Column(
      children: [
        TextField(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('dd-MM-yyyy').format(pickedDate);
              setState(() {
                _dateController.text =
                    formattedDate; //set output date to TextField value.
              });
            }
          },
          readOnly: true,
          controller: _dateController,
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 15.0,
              color: Colors.black),
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10.0),
            hintText: 'Pick Date',
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 1.5,
                color: Color(0xff8355B7),
              ),
            ),
          ),
        ),
        if (step2Error.isNotEmpty) showError(message: step2Error)
      ],
    );
  }

  Widget buildKmSection() {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        //meter reading
        TextField(
          controller: _endKmController,
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 15.0,
              color: Colors.black),
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.route_rounded,
                size: 30.0, color: Color(0xff8355B7)),
            counter: const SizedBox.shrink(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            hintText: 'Enter Meter reading',
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey.withOpacity(.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 1.5,
                color: Color(0xff8355B7),
              ),
            ),
          ),
        ),

        //image picker
        Container(
          width: size.width * .5,
          height: size.height * .3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                width: 1.5,
                color: const Color(0xff8355B7).withOpacity(.8),
              )),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: endKmImage != null
                ? GestureDetector(
                    onTap: () async {
                      final image = await takeImage();
                      if (image != null) {
                        if (!mounted) return;
                        setState(() {
                          endKmImage = image;
                        });
                      }
                    },
                    child: Image.file(endKmImage!, fit: BoxFit.cover))
                : TextButton.icon(
                    onPressed: () async {
                      final image = await takeImage();
                      if (image != null) {
                        if (!mounted) return;
                        setState(() {
                          endKmImage = image;
                        });
                      }
                    },
                    icon: const Icon(Icons.camera_alt_rounded),
                    style: TextButton.styleFrom(
                        foregroundColor: const Color(0xff8355B7)),
                    label: Text(
                      'Take Photo',
                      style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
                    )),
          ),
        ),

        //Error message section
        if (step3Error.isNotEmpty) showError(message: step3Error),
      ],
    );
  }

  Widget buildSummary() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1, color: Colors.grey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visit Summary Notes',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsBold,
              fontSize: 15.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '  ${_summaryNoteController.text.trim()}',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 15.0,
            ),
          ),
          const SizedBox(height: 15.0),
          Text(
            'Expected Date of Installation',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsBold,
              fontSize: 15.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '  ${_dateController.text.trim()}',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 15.0,
            ),
          ),
          const SizedBox(height: 15.0),
          Text(
            'End KM Reading',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsBold,
              fontSize: 15.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '  ${_endKmController.text.trim()}',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingAnimation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/cloud_animation.json', height: 80.0),
        const SizedBox(height: 10.0),
        Text(
          'Uploading data, please wait',
          style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
        ),
        Text(
          'Don\'t press back button or close this app',
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 12.0,
              color: Colors.grey),
        ),
      ],
    );
  }

  //for showing error message on each steps
  Widget showError({required String message}) {
    return Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: Colors.red),
        const SizedBox(width: 5.0),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium, color: Colors.red),
          ),
        ),
      ],
    );
  }

  void showSnackBar({required String message, required Color color}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        padding: const EdgeInsets.all(0.0),
        content: Container(
          height: 50.0,
          color: color,
          child: Center(
            child: Text(
              message,
              style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
            ),
          ),
        ),
      ),
    );
  }

  //Image picking function
  Future<File?> takeImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return null;
    return File(image.path);
  }
}

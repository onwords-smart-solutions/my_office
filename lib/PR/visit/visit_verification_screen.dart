import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as ImageLib;
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/PR/visit/product_detail_screen.dart';
import 'package:my_office/PR/visit/support_crew_item.dart';
import 'package:my_office/models/visit_model.dart';
import 'package:my_office/util/screen_template.dart';
import '../../database/hive_operations.dart';

class VisitVerificationScreen extends StatefulWidget {
  final VisitModel customerData;

  const VisitVerificationScreen({Key? key, required this.customerData})
      : super(key: key);

  @override
  State<VisitVerificationScreen> createState() =>
      _VisitVerificationScreenState();
}

class _VisitVerificationScreenState extends State<VisitVerificationScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _kmEditingController = TextEditingController();

  int currentStep = 0;
  String step1Error = '';
  String step3Error = '';
  List<String> staffs = [];
  VisitModel? visitDataStored;
  bool isUploading = false;

  //MAIN VARIABLES
  String inChargeName = '';
  File? inChargeImage;
  List<File> supportCrewImages = [];
  List<String> supportCrewNames = [];
  File? startKmImage;

  //Fetching PR Staff Names from firebase database
  void getPRStaffNames() {
    final ref = FirebaseDatabase.instance.ref();
    ref.child('staff').once().then((staffSnapshot) {
      for (var data in staffSnapshot.snapshot.children) {
        var fbData = data.value as Map<Object?, Object?>;
        if (fbData['department'] == 'PR') {
          final name = fbData['name'].toString();
          staffs.add(name);
        }
      }

      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void initState() {
    getPRStaffNames();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _kmEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
        bodyTemplate: buildMainScreen(), title: 'Verification');
  }

  Widget buildMainScreen() {
    return Stepper(
        currentStep: currentStep > 3 ? 3 : currentStep,
        physics: const BouncingScrollPhysics(),
        onStepContinue: onStepContinue,
        onStepCancel: () {
          if (currentStep == 0) {
            print('cant cancel');
          } else {
            setState(() {
              currentStep = currentStep - 1;
            });
          }
        },
        controlsBuilder: (BuildContext ctx, ControlsDetails details) {
          final buttonText = currentStep == 3 ? 'Continue' : 'Next';
          return isUploading
              ? loadingAnimation()
              : Row(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
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
          inChargeStep(),
          addSupport(),
          kmStartDetail(),
          summary(),
        ]);
  }

  Step inChargeStep() {
    final textStyle = currentStep == 0
        ? ConstantFonts.poppinsBold
        : ConstantFonts.poppinsMedium;
    final textColor = currentStep == 0 ? Colors.purple : Colors.black;

    return Step(
      title: Text(
        'InCharge Details',
        style: TextStyle(fontFamily: textStyle, color: textColor),
      ),
      content: buildInChargeDetailSection(),
      isActive: currentStep >= 0,
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
    );
  }

  Widget buildInChargeDetailSection() {
    final size = MediaQuery.of(context).size;
    return staffs.isNotEmpty
        ? Column(
            children: [
              //inCharge names
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xff8355B7).withOpacity(.8),
                      width: 1.5),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: DropdownButton(
                      value: inChargeName.isEmpty ? null : inChargeName,
                      borderRadius: BorderRadius.circular(15.0),
                      style: TextStyle(
                          fontFamily: ConstantFonts.poppinsMedium,
                          color: Colors.black),
                      iconSize: 30.0,
                      menuMaxHeight: size.height * .4,
                      underline: const SizedBox.shrink(),
                      enableFeedback: true,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.person_pin,
                        color: Color(0xff8355B7),
                      ),
                      // value: inChargeName,
                      hint: Text('Select inCharge name',
                          style: TextStyle(
                              fontFamily: ConstantFonts.poppinsMedium,
                              color: Colors.grey)),
                      items: staffs.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (!mounted) return;
                        setState(() {
                          inChargeName = newValue!;
                        });
                      }),
                ),
              ),
              const SizedBox(height: 20.0),
              //image picking
              if (inChargeName.isNotEmpty)
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
                    child: inChargeImage != null
                        ? GestureDetector(
                            onTap: () async {
                              final image = await takeImage();
                              if (image != null) {
                                if (!mounted) return;
                                setState(() {
                                  inChargeImage = image;
                                });
                              }
                            },
                            child:
                                Image.file(inChargeImage!, fit: BoxFit.cover))
                        : TextButton.icon(
                            onPressed: () async {
                              final image = await takeImage();
                              if (image != null) {
                                if (!mounted) return;
                                setState(() {
                                  inChargeImage = image;
                                });
                              }
                            },
                            icon: const Icon(Icons.camera_alt_rounded),
                            style: TextButton.styleFrom(
                                foregroundColor: const Color(0xff8355B7)),
                            label: Text(
                              'Take Photo',
                              style: TextStyle(
                                  fontFamily: ConstantFonts.poppinsMedium),
                            )),
                  ),
                ),

              //Error message section
              if (step1Error.isNotEmpty) showError(message: step1Error),
            ],
          )
        : Container(
            width: 30.0,
            height: 30.0,
            padding: const EdgeInsets.all(5.0),
            child: const CircularProgressIndicator(
                color: Color(0xff8355B7), strokeWidth: 1.5));
  }

  //Support section
  Step addSupport() {
    final textStyle = currentStep == 1
        ? ConstantFonts.poppinsBold
        : ConstantFonts.poppinsMedium;
    final textColor = currentStep == 1 ? Colors.purple : Colors.black;
    return Step(
      title: Text(
        'Support Details',
        style: TextStyle(fontFamily: textStyle, color: textColor),
      ),
      content: buildAddSupportSection(),
      isActive: currentStep >= 1,
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
    );
  }

  Widget buildAddSupportSection() {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: supportCrewNames.length,
            itemBuilder: (ctx, i) {
              return Dismissible(
                  key: ValueKey(supportCrewNames[i]),
                  background: background(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      supportCrewImages.removeAt(i);
                      supportCrewNames.removeAt(i);
                    });

                    showSnackBar(
                        message: 'Support crew removed', color: Colors.green);
                  },
                  child: SupportCrewItem(
                      name: supportCrewNames[i], image: supportCrewImages[i]));
            }),
        TextButton.icon(
            onPressed: () async {
              final result = await showBottomDialog();

              if (result == 'success') {
                setState(() {
                  //for updating values in body
                });
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xff8355B7),
            ),
            icon: const Icon(Icons.add_circle_rounded),
            label: Text("Add support crew",
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium, fontSize: 15.0))),
      ],
    );
  }

  Widget background() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), color: Colors.red),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Remove',
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium, color: Colors.white),
          ),
          const Icon(Icons.delete_rounded, color: Colors.white),
        ],
      ),
    );
  }

  //Travel section
  Step kmStartDetail() {
    final textStyle = currentStep == 2
        ? ConstantFonts.poppinsBold
        : ConstantFonts.poppinsMedium;
    final textColor = currentStep == 2 ? Colors.purple : Colors.black;
    return Step(
      title: Text(
        'Travel Details',
        style: TextStyle(fontFamily: textStyle, color: textColor),
      ),
      content: buildKmSection(),
      isActive: currentStep >= 2,
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
    );
  }

  Widget buildKmSection() {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        //meter reading
        TextField(
          controller: _kmEditingController,
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
            child: startKmImage != null
                ? GestureDetector(
                    onTap: () async {
                      final image = await takeImage();
                      if (image != null) {
                        if (!mounted) return;
                        setState(() {
                          startKmImage = image;
                        });
                      }
                    },
                    child: Image.file(startKmImage!, fit: BoxFit.cover))
                : TextButton.icon(
                    onPressed: () async {
                      final image = await takeImage();
                      if (image != null) {
                        if (!mounted) return;
                        setState(() {
                          startKmImage = image;
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

  //Summary
  Step summary() {
    final textStyle = currentStep == 3
        ? ConstantFonts.poppinsBold
        : ConstantFonts.poppinsMedium;
    final textColor = currentStep == 3 ? Colors.purple : Colors.black;
    return Step(
      title: Text(
        'Summary',
        style: TextStyle(fontFamily: textStyle, color: textColor),
      ),
      content: buildSummarySection(),
      isActive: currentStep >= 3,
      state: currentStep > 3 ? StepState.complete : StepState.indexed,
    );
  }

  Widget buildSummarySection() {
    List<Widget> supportMembers = [];
    for (int i = 0; i < supportCrewNames.length; i++) {
      final widget =
          Row(children: [Text('Support ${i + 1}'), Text(supportCrewNames[i])]);

      supportMembers.add(widget);
    }
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1, color: Colors.grey)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Incharge Name',
                style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
              ),
              Text(
                inChargeName,
                style: TextStyle(fontFamily: ConstantFonts.poppinsBold),
              )
            ],
          ),

          //support members
          ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              itemCount: supportCrewNames.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (c, i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Support  ${i + 1}',
                      style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
                    ),
                    Text(
                      supportCrewNames[i],
                      style: TextStyle(fontFamily: ConstantFonts.poppinsBold),
                    )
                  ],
                );
              }),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Start KM Reading',
                style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
              ),
              Text(
                _kmEditingController.text,
                style: TextStyle(fontFamily: ConstantFonts.poppinsBold),
              )
            ],
          ),
        ],
      ),
    );
  }

  //Image picking function
  Future<File?> takeImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return null;
    return File(image.path);
  }

  //on next button clicks in stepper
  void onStepContinue() {
    //Validating for step 1
    if (currentStep == 0) {
      String error = '';
      if (inChargeName.isEmpty) {
        error = 'Select inCharge name';
      } else if (inChargeImage == null) {
        error = 'Upload inCharge image';
      }
      setState(() {
        if (error.isEmpty) {
          step1Error = '';
          currentStep = currentStep + 1;
        } else {
          step1Error = error;
        }
      });
    } else if (currentStep == 1) {
      setState(() {
        currentStep = currentStep + 1;
      });
    } else if (currentStep == 2) {
      String error = '';
      if (_kmEditingController.text.trim().isEmpty) {
        error = 'Enter KM start reading';
      } else if (_kmEditingController.text.trim().length < 6) {
        error = 'Provide valid KM reading';
      } else if (startKmImage == null) {
        error = 'Upload KM reading image';
      }

      setState(() {
        if (error.isEmpty) {
          step3Error = '';
          currentStep = currentStep + 1;
        } else {
          step3Error = error;
        }
      });
    } else if (currentStep == 3) {
      if (visitDataStored != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ProductDetailScreen(visitData: visitDataStored!)));
      } else {
        submitCurrentSection();
      }
    }
  }

  //for showing error message on each steps
  Widget showError({required String message}) {
    return Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: Colors.red),
        const SizedBox(width: 5.0),
        Text(
          message,
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium, color: Colors.red),
        ),
      ],
    );
  }

  //For adding support details
  Future showBottomDialog() {
    final size = MediaQuery.of(context).size;
    File image = File('');
    String error = '';
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (ctx) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height*.7,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Support Crew Name',
                        style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            fontSize: 12.0,
                            color: Colors.grey),
                      ),

                      //support name
                      Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: _textEditingController,
                            style: TextStyle(
                                fontFamily: ConstantFonts.poppinsMedium,
                                fontSize: 15.0,
                                color: Colors.black),
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              hintText: 'Type Name',
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
                          )),
                          PopupMenuButton(
                            enableFeedback: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            constraints:
                                BoxConstraints(maxHeight: size.height * .4),
                            icon: const Icon(
                              Icons.person_pin,
                              color: Color(0xff8355B7),
                            ),
                            iconSize: 30.0,
                            onSelected: (newValue) {
                              setState(() {
                                _textEditingController.text = newValue;
                              });
                            },
                            itemBuilder: (BuildContext c) {
                              return staffs.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice,
                                      style: TextStyle(
                                          fontFamily:
                                              ConstantFonts.poppinsMedium,
                                          color: Colors.black)),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Upload Support Crew Image',
                        style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            fontSize: 12.0,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 8.0),
                      //support image
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Container(
                          width: size.width * .35,
                          height: size.height * .25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                width: 1.5,
                                color: const Color(0xff8355B7).withOpacity(.8),
                              )),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: image.path != ''
                                ? GestureDetector(
                                    onTap: () async {
                                      final pic = await takeImage();
                                      if (pic != null) {
                                        if (!mounted) return;
                                        setState(() {
                                          image = pic;
                                        });
                                      }
                                    },
                                    child:
                                        Image.file(image!, fit: BoxFit.cover))
                                : TextButton.icon(
                                    onPressed: () async {
                                      final pic = await takeImage();
                                      if (pic != null) {
                                        if (!mounted) return;
                                        setState(() {
                                          image = pic;
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.camera_alt_rounded),
                                    style: TextButton.styleFrom(
                                        foregroundColor:
                                            const Color(0xff8355B7)),
                                    label: Text(
                                      'Take Photo',
                                      style: TextStyle(
                                          fontFamily:
                                              ConstantFonts.poppinsMedium),
                                    )),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      if (error.isNotEmpty) showError(message: error),
                      const SizedBox(height: 8.0),
                      //submit button
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                String e = '';
                                if (_textEditingController.text
                                    .trim()
                                    .isEmpty) {
                                  e = 'Enter support crew name';
                                } else if (image.path == '') {
                                  e = 'Upload support crew image';
                                } else {
                                  e = '';
                                }

                                setState(() {
                                  error = e;
                                  if (e.isEmpty) {
                                    //Success validation
                                    supportCrewNames.add(
                                        _textEditingController.text.trim());
                                    supportCrewImages.add(image!);
                                    _textEditingController.clear();
                                    Navigator.of(ctx).pop('success');
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                              child: Text('Add',
                                  style: TextStyle(
                                      fontFamily:
                                          ConstantFonts.poppinsMedium)))),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  //submitting current section
  void submitCurrentSection() async {
    setState(() {
      isUploading = true;
    });
    final nav = Navigator.of(context);
    String inChargeUrl = '';
    String startKmUrl = '';
    List<String> supportImageLinks = [];

    final today = DateTime.now();
    final storePath =
        'VISIT/${today.year}/${today.month}/${today.day}/${widget.customerData.customerPhoneNumber}';
    final storageRef = FirebaseStorage.instance.ref().child(storePath);

    //Uploading In-Charge image
    try {
      //compressing image
      var sourceImage = ImageLib.decodeImage(inChargeImage!.readAsBytesSync());
      var compressedImage = ImageLib.copyResize(sourceImage!, width: 800);

      UploadTask uploadTask = storageRef
          .child('VERIFICATION/PR/${inChargeName}_incharge.jpg')
          .putData(ImageLib.encodeJpg(compressedImage));
      await uploadTask.whenComplete(() async {
        inChargeUrl = await storageRef
            .child('VERIFICATION/PR/${inChargeName}_incharge.jpg')
            .getDownloadURL();
      });
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      showSnackBar(
          message: 'Error while uploading inCharge image. Try again',
          color: Colors.red);
    }

    //Uploading support crew images
    if (supportCrewNames.isNotEmpty) {
      List<Map<String, File>> support = [];
      final supportDetail =
          Map.fromIterables(supportCrewNames, supportCrewImages);
      supportDetail.forEach((name, image) => support.add({name: image}));

      supportImageLinks = await Future.wait(support.map((crewDetail) =>
          uploadSupportCrewImages(detail: crewDetail, ref: storageRef)));
    }

//uploading start KM image
    try {
      //compressing image
      var sourceImage = ImageLib.decodeImage(startKmImage!.readAsBytesSync());
      var compressedImage = ImageLib.copyResize(sourceImage!, width: 800);

      UploadTask uploadTask = storageRef
          .child('VERIFICATION/TRAVEL/startKM.jpg')
          .putData(ImageLib.encodeJpg(compressedImage));
      await uploadTask.whenComplete(() async {
        startKmUrl = await storageRef
            .child('VERIFICATION/TRAVEL/startKM.jpg')
            .getDownloadURL();
      });
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      showSnackBar(
          message: 'Error while uploading Meter reading image. Try again',
          color: Colors.red);
    }

//Work only if no error occurred
    if (isUploading) {
      final data = VisitModel(
        dateTime: today,
        customerPhoneNumber: widget.customerData.customerPhoneNumber,
        customerName: widget.customerData.customerName,
        stage: 'verification',
        inChargeDetail: {inChargeName: inChargeUrl},
        startKm: int.parse(_kmEditingController.text.trim()),
        storagePath: storePath,
        supportCrewNames: supportCrewNames,
        supportCrewImageLinks: supportImageLinks,
        startKmImageLink: startKmUrl,
      );

      await HiveOperations().updateVisitEntry(newVisitEntry: data);
      setState(() {
        isUploading = false;
        visitDataStored = data;
      });
      nav.push(MaterialPageRoute(
          builder: (context) => ProductDetailScreen(visitData: data)));
    }
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

  Future<String> uploadSupportCrewImages(
      {required Map<String, File> detail, required Reference ref}) async {
    String url = '';
    try {
      //compressing image
      var sourceImage =
          ImageLib.decodeImage(detail.values.first.readAsBytesSync());
      var compressedImage = ImageLib.copyResize(sourceImage!, width: 800);

      String fileName = detail.keys.first;
      final path = ref.child('VERIFICATION/PR/$fileName.jpg');
      UploadTask uploadTask = path.putData(ImageLib.encodeJpg(compressedImage));
      await uploadTask.whenComplete(() async {
        url = await path.getDownloadURL();
      });
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      showSnackBar(
          message: 'Error while uploading Support crew images. Try again',
          color: Colors.red);
    }
    return url;
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
}

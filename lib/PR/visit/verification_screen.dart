import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_office/PR/visit/product_detail_screen.dart';
import 'package:my_office/database/hive_operations.dart';
import 'package:my_office/models/visit_model.dart';
import 'package:my_office/util/screen_template.dart';

import '../../Constant/colors/constant_colors.dart';
import '../../Constant/fonts/constant_font.dart';

class VerificationScreen extends StatefulWidget {
  final String name;
  final String phone;

  const VerificationScreen({Key? key, required this.name, required this.phone})
      : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  File? inChargeImage;
  File? startKmImage;
  List<File> supportPrImage = [];

  TextEditingController inChargeController = TextEditingController();
  TextEditingController supportPrController = TextEditingController();
  TextEditingController startKmController = TextEditingController();

  Future picImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        inChargeImage = imageTemporary;
      });
    } on PlatformException catch (e) {
      e;
    }
  }

  List supportPrNames = [];
  List<String> supportPrNamesString = [];
  bool isViewList = false;
  bool isViewAddButton = true;
  bool txt = false;
  double containerHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ScreenTemplate(
        bodyTemplate: bodyContent(height, width), title: 'Verification');
  }

  Widget bodyContent(double height, double width) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          nameAndPicWidget(
            height,
            width,
          ),
          addSupportPrWidget(height, width),
          GestureDetector(
            onTap: () {
              setState(() {
                isViewAddButton = false;
                containerHeight = height * 0.4;
              });
            },
            child: isViewAddButton
                ? Container(
                    margin: EdgeInsets.only(top: height * 0.03),
                    height: height * 0.05,
                    width: width * 0.3,
                    decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffD136D4),
                          Color(0xff7652B2),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(),
          ),
          AnimatedContainer(
            height: containerHeight,
            duration: const Duration(milliseconds: 400),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  supportPrAndPicWidget(height, width),
                  supportPrController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              if (supportPrController.text.isNotEmpty) {
                                supportPrNamesString.add(supportPrController.text.toString());
                                supportPrNames.add(
                                    Text(supportPrController.text.toString()));
                                supportPrController.clear();
                                isViewAddButton = true;
                                isViewList = true;
                                containerHeight = 0;
                                txt = false;
                              } else {
                                showSnackBar(
                                    message: 'Please Fill All Filed',
                                    color: Colors.redAccent);
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: height * 0.01),
                            height: height * 0.05,
                            width: width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xffD136D4),
                                  Color(0xff7652B2),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Add',
                                style: TextStyle(),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          starKkmAndPicWidget(height, width),
          submitButtonWidget(height, width)
        ],
      ),
    );
  }

  Widget addSupportPrWidget(double height, double width) {
    return Container(
      height: isViewList ? height * 0.25 : height * 0.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12, width: width * 0.003),
      ),
      child: supportPrNames.isNotEmpty && supportPrImage.isNotEmpty
          ? ListView.builder(
              itemCount: supportPrNames.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = supportPrNames[index];
                return Dismissible(
                  key: ValueKey(item),
                  direction: DismissDirection.endToStart,
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    setState(() {
                      supportPrNamesString.removeAt(index);
                      supportPrNames.removeAt(index);
                      supportPrImage.removeAt(index);
                    });
                    showSnackBar(
                        message: 'Successfully Deleted', color: Colors.green);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    margin: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.01),
                    height: height * 0.08,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.black12, width: width * 0.003)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        supportPrNames[index],
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: height * 0.007),
                          height: height * 0.08,
                          width: width * 0.3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.black12, width: width * 0.003)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                supportPrImage[index],
                                fit: BoxFit.cover,
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text('Add Support PR Names'),
            ),
    );
  }

  Widget nameAndPicWidget(
    double height,
    double width,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.02),
      // padding: const EdgeInsets.all(10),
      // height: height*0.1,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textInputFiled(height, width, inChargeController, TextInputType.text,
              'In-charge Name', 20, 'Enter Name'),
          uploadInChargePic(height, width),
        ],
      ),
    );
  }

  Widget starKkmAndPicWidget(
    double height,
    double width,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.02),
      // padding: const EdgeInsets.all(10),
      // height: height*0.1,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textInputFiled(height, width, startKmController, TextInputType.number,
              'Start Km', 6, 'Enter KM'),
          uploadKmPic(height, width),
        ],
      ),
    );
  }

  Widget supportPrAndPicWidget(double height, double width) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.02),
      // padding: const EdgeInsets.all(10),
      // height: height*0.1,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            uploadSupportPRPic(height, width),
            SizedBox(
              height: height * 0.02,
            ),
            txt
                ? textInputFiled(height, width, supportPrController,
                    TextInputType.text, 'Support PR Name', 20, 'Enter Name')
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget textInputFiled(
    double height,
    double width,
    TextEditingController controller,
    TextInputType textInputType,
    String title,
    int max,
    String hintText,
  ) {
    return Container(
        height: height * 0.13,
        width: width * 0.55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12, width: width * 0.003)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.done,
                  maxLength: max,
                  keyboardType: textInputType,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontSize: 13,
                      fontFamily: ConstantFonts.poppinsMedium,
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
                        color: Colors.purple,
                      ),
                    ),
                  )),
            ),
          ],
        ));
  }

  /// InCharge Image
  Widget uploadInChargePic(double height, double width) {
    return Container(
      height: height * 0.13,
      width: width * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12, width: width * 0.003),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          inChargeImage != null
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      inChargeImage!,
                      fit: BoxFit.cover,
                      height: height * 0.08,
                      width: width * 0.3,
                    ),
                  ),
                )
              : CircleAvatar(
                  backgroundColor: ConstantColor.backgroundColor,
                  radius: 20.0,
                  child: IconButton(
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      picImage();
                    },
                    icon: const Icon(
                      Icons.photo_camera_rounded,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                ),
          Center(
            child: Text(
              'Upload In-charge Pic',
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium, fontSize: 10.0),
            ),
          ),
        ],
      ),
    );
  }

  /// Support PR Image
  Widget uploadSupportPRPic(double height, double width) {
    return Container(
      height: height * 0.13,
      width: width * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12, width: width * 0.003),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundColor: ConstantColor.backgroundColor,
            radius: 20.0,
            child: IconButton(
              onPressed: () async {
                HapticFeedback.heavyImpact();
                await ImagePicker()
                    .pickImage(source: ImageSource.camera)
                    .then((pickedImage) {
                  if (pickedImage == null) return;
                  setState(() {
                    txt = true;
                    supportPrImage.add(File(pickedImage.path));
                  });
                });
              },
              icon: const Icon(
                Icons.photo_camera_rounded,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
          Center(
            child: Text(
              'Upload PR Pic',
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium, fontSize: 10.0),
            ),
          ),
        ],
      ),
    );
  }

  /// Start KM Image
  Widget uploadKmPic(double height, double width) {
    return Container(
      height: height * 0.13,
      width: width * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12, width: width * 0.003),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          startKmImage != null
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      startKmImage!,
                      fit: BoxFit.cover,
                      height: height * 0.08,
                      width: width * 0.3,
                    ),
                  ),
                )
              : CircleAvatar(
                  backgroundColor: ConstantColor.backgroundColor,
                  radius: 20.0,
                  child: IconButton(
                    onPressed: () async {
                      HapticFeedback.heavyImpact();
                      await ImagePicker()
                          .pickImage(source: ImageSource.camera)
                          .then((pickedImage) {
                        if (pickedImage == null) return;
                        setState(() {
                          startKmImage = File(pickedImage.path);
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.photo_camera_rounded,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                ),
          Center(
            child: Text(
              'Upload Km Pic',
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium, fontSize: 10.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget submitButtonWidget(double height, double width) {
    return GestureDetector(
      onTap: () async {
        List<Map<String, Uint8List>> prDetails = [];

        if (inChargeController.text.isNotEmpty &&
            startKmController.text.isNotEmpty &&
            inChargeImage != null &&
            startKmImage != null) {
          //converting start km pic into uint8list
          final image = startKmImage?.readAsBytesSync();

          final prImage = inChargeImage!.readAsBytesSync();
          final prDetail = {'${inChargeController.value.text} /incharge': prImage};
          prDetails.add(prDetail);

          if (supportPrNamesString.isNotEmpty) {
            for (int i = 0; i < supportPrNamesString.length; i++) {
              final image = supportPrImage[i].readAsBytesSync();
              prDetails.add({supportPrNamesString[i].toString(): image});
            }
          }

          final data = VisitModel(
              dateTime: DateTime.now(),
              customerPhoneNumber: widget.phone,
              customerName: widget.name,
              prDetails: prDetails,
              startKm: int.parse(startKmController.text),
              startKmImage: image,
              stage: 'verificationScreen');

          await HiveOperations().updateVisitEntry(newVisitEntry: data);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(visiData: data)));
        } else {
          showSnackBar(message: 'Fill All Filled', color: Colors.redAccent);
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: height * 0.05),
        height: height * 0.07,
        width: width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color(0xffD136D4),
              Color(0xff7652B2),
            ],
          ),
        ),
        child: Center(
          child: Text(
            'Next',
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                fontSize: height * 0.025,
                color: Colors.white),
          ),
        ),
      ),
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
}

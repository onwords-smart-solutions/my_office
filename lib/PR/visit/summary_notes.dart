import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/database/hive_operations.dart';
import 'package:my_office/home/user_home_screen.dart';
import 'package:my_office/models/visit_model.dart';
import 'package:my_office/util/screen_template.dart';

import '../../Constant/fonts/constant_font.dart';

class SummaryAndNotes extends StatefulWidget {
  final VisitModel visitInfo;

  const SummaryAndNotes({Key? key, required this.visitInfo}) : super(key: key);

  @override
  State<SummaryAndNotes> createState() => _SummaryAndNotesState();
}

class _SummaryAndNotesState extends State<SummaryAndNotes> {
  File? image;
  int totalKm = 0;
  int startKm = 300;
  bool isLoading = false;
  TextEditingController summaryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController totalKMController = TextEditingController();

  Future picImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      e;
    }
  }

  Future picImageFromCamara() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      e;
    }
  }

  void uploadKMImage(double height, double width) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: width * 0.01),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    picImageFromGallery();
                    Navigator.of(ctx).pop();
                  },
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: SizedBox(
                    height: height * 0.09,
                    child: Row(
                      children: [
                        SizedBox(width: width * 0.05),
                        const Icon(Icons.photo_library_rounded,
                            color: Color(0xff8355B7)),
                        SizedBox(width: width * 0.05),
                        Text(
                          "Choose from library",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: ConstantFonts.poppinsMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    picImageFromCamara();
                    Navigator.of(ctx).pop();
                  },
                  child: SizedBox(
                    height: height * 0.09,
                    child: Row(
                      children: [
                        SizedBox(width: width * 0.05),
                        const Icon(Icons.camera_alt_rounded,
                            color: Color(0xff8355B7)),
                        SizedBox(width: width * 0.05),
                        Text(
                          "Take photo",
                          style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ScreenTemplate(
        bodyTemplate: bodyContent(height, width), title: 'Summary And Notes');
  }

  Widget bodyContent(double height, double width) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          summaryFiled(height, width),
          dateFiled(height, width),
          kmAndImagePicWidget(height, width),
          totalKmFiled(height, width),
          submitButtonWidget(height, width),
        ],
      ),
    );
  }

  Widget summaryFiled(double height, double width) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
      height: height * 0.25,
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        children: [
          TextField(
              controller: summaryController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              maxLines: 8,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: 'Add Summary',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    width: width * 0.003,
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
        ],
      ),
    );
  }

  Widget dateFiled(double height, double width) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      height: height * 0.08,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12, width: width * 0.003)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Estimate Date\nof Installation',
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium, fontSize: 10),
          ),
          Text(
            ':',
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium, fontSize: 18),
          ),
          SizedBox(
            width: width * 0.6,
            child: TextFormField(
              controller: dateController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.datetime,
              textAlign: TextAlign.center,
              readOnly: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: 'Enter Date',
                hintStyle: TextStyle(
                  fontSize: 13,
                  fontFamily: ConstantFonts.poppinsMedium,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    width: width * 0.003,
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
              ),
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
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    dateController.text =
                        formattedDate; //set output date to TextField value.
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget submitButtonWidget(double height, double width) {
    return GestureDetector(
      onTap: isLoading ? null : submitVisitToFirebase,
      child: Container(
        margin: EdgeInsets.only(top: height * 0.10),
        height: height * 0.07,
        width: width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: const LinearGradient(
            colors: [
              Color(0xffD136D4),
              Color(0xff7652B2),
            ],
          ),
        ),
        child: Center(
          child: isLoading
              ? Lottie.asset(
                  "assets/animations/loading.json",
                )
              : Text(
                  'Submit',
                  style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      fontSize: height * 0.025,
                      color: Colors.white),
                ),
        ),
      ),
    );
  }

  Widget kmAndImagePicWidget(double height, double width) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.02),
      // padding: const EdgeInsets.all(10),
      // height: height*0.1,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          endKmFiled(height, width),
          uploadImageWidget(height, width),
        ],
      ),
    );
  }

  Widget endKmFiled(double height, double width) {
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
              'End KM',
              style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: totalKMController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 3,
                  onChanged: (value) {
                    final end = int.parse(value);
                    setState(() {
                      if (end > startKm) {
                        totalKm = end - startKm;
                      } else {
                        totalKm = 0;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    hintText: 'Enter End of Km',
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

  Widget uploadImageWidget(double height, double width) {
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
          image != null
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image.file(
                    image!,
                    height: height * 0.08,
                    width: width * 0.25,
                    fit: BoxFit.cover,
                  ),
                )
              : CircleAvatar(
                  backgroundColor: ConstantColor.backgroundColor,
                  radius: 20.0,
                  child: IconButton(
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      uploadKMImage(height, width);
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
              'Upload End Km Pic',
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium, fontSize: 10.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget totalKmFiled(double height, double width) {
    return Container(
        margin: EdgeInsets.only(top: height * 0.01),
        height: height * 0.05,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12, width: width * 0.003)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Total Km is  :',
              style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
            ),
            Text(
              '$totalKm KM',
              style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
            ),
          ],
        ));
  }

  Future<void> submitVisitToFirebase() async {
    final nav = Navigator.of(context);
    if (summaryController.text.isEmpty) {
      showSnackBar(message: 'Please add notes to submit', color: Colors.red);
    } else if (dateController.text.isEmpty) {
      showSnackBar(
          message: 'Please select estimated date for installation',
          color: Colors.red);
    } else if (totalKMController.text.isEmpty) {
      showSnackBar(message: 'Please add you end KM reading', color: Colors.red);
    } else if (totalKm < 1) {
      showSnackBar(message: 'Please check your KM readings', color: Colors.red);
    } else if (image == null) {
      showSnackBar(
          message: 'Please upload your KM readings', color: Colors.red);
    } else {
      //Enabling loading indication

      setState(() {
        isLoading = true;
      });

      //adding all details into firebase
      await uploadToFirebase();

      //delete visit from local db
      if (isLoading) {
        showSnackBar(message: "Visit entry submitted successfully", color: Colors.green);
        await HiveOperations().deleteVisitEntry(
            phoneNumber: widget.visitInfo.customerPhoneNumber);
        nav.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const UserHomeScreen()),
            (route) => false);
      }
    }
  }

  Future<void> uploadToFirebase() async {
    List<String> travelImageUrls = [];
    String inChargeImageLink = '';
    String supportImageLink = '';
    List<String> productImageUrls = [];

    final today = DateTime.now();
    final ref = FirebaseDatabase.instance.ref();
    final dbPath = ref.child(
        'visit/${today.year}/${today.month}/${today.day}/${widget.visitInfo.customerPhoneNumber}/');
    final storageRef = FirebaseStorage.instance.ref().child(
        'VISIT/${today.year}/${today.month}/${today.day}/${widget.visitInfo.customerPhoneNumber}/$today');

    //uploading travel images
    travelImageUrls = await uploadTravelImages(storageRef: storageRef);

    //uploading product images
    productImageUrls = await uploadProductImages(
        storageRef: storageRef, images: widget.visitInfo.productImage!);

    /** ADDING DATA INTO DATABASE ,CHECKING NO ERROR OCCURRED
        WHILE UPLOADING IMAGES BY CHECKING isLoading VALUE */

    if (isLoading) {
      dbPath.set({
        'verification': {
          'startKM': startKm,
          'endKM': totalKMController.text,
          'MeterReadings': travelImageUrls,
          'totalKM': totalKm,
        },
        'productDetails': {
          'products': widget.visitInfo.productName,
          'productImages': productImageUrls,
        },
        'summary': {
          'note': summaryController.text,
          'ETI': dateController.text,
        }
      });
    }
  }

  //UPLOADING TRAVEL KM IMAGES
  Future<List<String>> uploadTravelImages({required dynamic storageRef}) async {
    List<String> imageUrls = [];

    try {
      //START KM IMAGE
      storageRef
          .child('TRAVEL/startKM.jpeg')
          .putFile(image!)
          .whenComplete(() async {
        final endKmUrl =
            await storageRef.child('TRAVEL/startKM.jpeg').getDownloadURL();
        imageUrls.add(endKmUrl);
      });

      //END KM IMAGE
      storageRef
          .child('TRAVEL/endKM.jpeg')
          .putFile(image!)
          .whenComplete(() async {
        final endKmUrl =
            await storageRef.child('TRAVEL/endKM.jpeg').getDownloadURL();
        imageUrls.add(endKmUrl);
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      showSnackBar(
          message: 'Something went wrong. Unable to submit visit entry',
          color: Colors.red);
    }

    return imageUrls;
  }

  //UPLOADING PRODUCT IMAGES
  Future<List<String>> uploadProductImages(
      {required dynamic storageRef, required List<Uint8List> images}) async {
    List<String> imageUrls = [];
    List<Map<int, Uint8List>> indexImages = [];

    for (int i = 0; i < images.length; i++) {
      indexImages.add({i + 1: images[i]});
    }
    imageUrls = await Future.wait(indexImages
        .map((image) => uploadImages(image: image, ref: storageRef)));
    return imageUrls;
  }

  Future<String> uploadImages(
      {required Map<int, Uint8List> image, required dynamic ref}) async {
    String url = '';

    try {
      final path = ref.child('PRODUCTS/Product_${image.keys.first}.jpeg');
      UploadTask uploadTask = path.putData(image.values.first);
      await uploadTask.whenComplete(() async {
        url = await path.getDownloadURL();
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      showSnackBar(
          message: 'Something went wrong. Unable to submit visit entry',
          color: Colors.red);
    }
    return url;
  }

  //-----------SNACK BAR---------------//
  void showSnackBar({required String message, required Color color}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
            )))));
  }
}

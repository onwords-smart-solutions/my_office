import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as ImageLib;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/PR/visit/visit_form_screen.dart';
import 'package:my_office/home/user_home_screen.dart';

import '../../Constant/colors/constant_colors.dart';
import '../../Constant/fonts/constant_font.dart';
import '../../database/hive_operations.dart';
import '../../models/visit_model.dart';
import '../../util/custom_rect_tween.dart';

class LoadingScreen extends StatefulWidget {
  final VisitModel visitData;
  final int endKm;
  final String summaryNotes;
  final File endKmImage;
  final String dateOfInstallation;

  const LoadingScreen(
      {Key? key,
      required this.visitData,
      required this.dateOfInstallation,
      required this.endKmImage,
      required this.endKm,
      required this.summaryNotes})
      : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String status = 'uploading';

  Future<void> submitVisit() async {
    setState(() {
      status = 'uploading';
    });

    final startKm = widget.visitData.startKm ?? 0;
    final totalKm = widget.endKm - startKm;
    final path = widget.visitData.storagePath ?? 'prVisit/Error/';
    final storageRef = FirebaseStorage.instance.ref().child(path);
    final ref = FirebaseDatabase.instance.ref();
    final dbPath = ref.child(path.toLowerCase());
    final endKmUrl =
        await uploadImage(image: widget.endKmImage, ref: storageRef);

    if (status == 'uploading') {
      dbPath.set({
        'verification': {
          'startKM': widget.visitData.startKm,
          'startMeterReading': widget.visitData.startKmImageLink,
          'endKM': widget.endKm,
          'endMeterReading': endKmUrl,
          'totalKM': totalKm,
        },
        'prDetails': {
          'incharge': widget.visitData.inChargeDetail!.keys.first,
          'inchargeImage': widget.visitData.inChargeDetail!.values.first,
          'supports': widget.visitData.supportCrewNames,
          'supportImages': widget.visitData.supportCrewImageLinks,
        },
        'productDetails': {
          'products': widget.visitData.productName,
          'productImages': widget.visitData.productImageLinks,
          'quotationInvoiceNumber': widget.visitData.quotationInvoiceNumber,
        },
        'summary': {
          'note': widget.summaryNotes,
          'dateOfInstallation': widget.dateOfInstallation,
          'customerName': widget.visitData.customerName,
          'visitTime': DateFormat.jm().format(
            DateTime.now(),
          ),
        }
      });

      await HiveOperations()
          .deleteVisitEntry(phoneNumber: widget.visitData.customerPhoneNumber);
      setState(() {
        status = 'success';
      });
    }
  }

  Future<String> uploadImage(
      {required File image, required dynamic ref}) async {
    String url = '';

    try {
      //compressing image
      var sourceImage = ImageLib.decodeImage(image.readAsBytesSync());
      var compressedImage = ImageLib.copyResize(sourceImage!, width: 800);

      final path = ref.child('VERIFICATION/TRAVEL/endKM.jpg');
      UploadTask uploadTask = path.putData(ImageLib.encodeJpg(compressedImage));
      await uploadTask.whenComplete(() async {
        url = await path.getDownloadURL();
      });
    } catch (e) {
      print(e);
      setState(() {
        status = 'error';
      });
      showSnackBar(
          message: 'Unable to upload travel image. Try again',
          color: Colors.red);
    }
    return url;
  }

  @override
  void initState() {
    submitVisit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Hero(
      transitionOnUserGestures: true,
      tag: 'visitFrom',
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: height * 0.95,
                  width: width,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewPadding.top * 1.5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                    child: status == 'uploading'
                        ? buildUploading()
                        : status == 'error'
                            ? buildError()
                            : buildSuccess(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUploading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/form_submitting.json'),
        const SizedBox(height: 15.0),
        Text(
          'Please wait form is submitting',
          style: TextStyle(
            fontFamily: ConstantFonts.sfProRegular,
            color: ConstantColor.backgroundColor,
            fontSize: 15.0,
          ),
        ),
      ],
    );
  }

  Widget buildError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/error.json',
            height: 100.0, repeat: false),
        const SizedBox(height: 15.0),
        Text(
          'Failed to submit form',
          style: TextStyle(
            fontFamily: ConstantFonts.sfProRegular,
            color: Colors.red,
            fontSize: 15.0,
          ),
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: ConstantColor.backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0))),
            onPressed: submitVisit,
            child: Text(
              'Try again',
              style: TextStyle(
                fontFamily: ConstantFonts.sfProRegular,
              ),
            )),
        CupertinoButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontFamily: ConstantFonts.sfProRegular,
                  fontSize: 14.0,
                  color: Colors.grey),
            ),
            onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }

  Widget buildSuccess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/success.json',
            height: 150.0, repeat: false),
        Text(
          'Visit form submitted successfully',
          style: TextStyle(
            fontFamily: ConstantFonts.sfProRegular,
            color: const Color(0xff2cda94),
            fontSize: 15.0,
          ),
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: ConstantColor.backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0))),
            child: Text(
              'Go Home',
              style: TextStyle(
                fontFamily: ConstantFonts.sfProRegular,
              ),
            ),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const UserHomeScreen()),
                (route) => false)),
        CupertinoButton(
          child: Text(
            'Add another visit entry',
            style: TextStyle(
                fontFamily: ConstantFonts.sfProRegular,
                fontSize: 14.0,
                color: Colors.grey),
          ),
          onPressed: () => Navigator.of(context)
              .popUntil(ModalRoute.withName('/visitResume')),
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
              style: TextStyle(fontFamily: ConstantFonts.sfProRegular),
            ),
          ),
        ),
      ),
    );
  }
}

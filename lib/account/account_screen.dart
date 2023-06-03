import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/app_version/version.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';
import '../database/hive_operations.dart';
import '../login/login_screen.dart';

class AccountScreen extends StatefulWidget {
  final StaffModel staffDetails;

  const AccountScreen({Key? key, required this.staffDetails}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final staff = FirebaseDatabase.instance.ref().child("staff");
  final firebaseStorage = FirebaseStorage.instance;

  String imageUrl = '';
  final picker = ImagePicker();

  Future pickerGalleryImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      pickUploadImage(File(pickedFile.path));
    }
  }

  Future pickerCameraImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      pickUploadImage(File(pickedFile.path));
    }
  }

  Future<void> pickUploadImage(File image) async {
    var profileImage = firebaseStorage
        .ref()
        .child('PROFILE IMAGE/${widget.staffDetails.uid}/');
    profileImage.putFile(File(image.path)).whenComplete(() async {
      final url = await profileImage.getDownloadURL();
      FirebaseDatabase.instance
          .ref()
          .child('staff/${widget.staffDetails.uid}/')
          .update({
        'profileImage': url,
      });

      if (!mounted) return;
      setState(() {
        imageUrl = url;
      });
    });
  }

  //
  void pickImage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: ConstantColor.background1Color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.135,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      pickerCameraImage(context);
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.camera_alt_rounded,
                        color: ConstantColor.backgroundColor),
                    title: Text(
                      'Camera',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          fontFamily: ConstantFonts.poppinsRegular),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      pickerGalleryImage(context);
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.photo_size_select_actual_rounded,
                        color: ConstantColor.backgroundColor),
                    title: Text(
                      'Gallery',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          fontFamily: ConstantFonts.poppinsRegular),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    getImageUrl();
    super.initState();
  }

  Future<void> getImageUrl() async {
    await FirebaseDatabase.instance
        .ref('staff/${widget.staffDetails.uid}/')
        .once()
        .then((value) {
      if (value.snapshot.exists) {
        final data = value.snapshot.value as Map<Object?, Object?>;
        final url = data['profileImage'];
        if (url != null) {
          if (!mounted) return;
          setState(() {
            imageUrl = url.toString();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // print(imageUrl);
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xffEEF0FE),
          Color(0xffEEF0FE),
          Color(0xffEEF0FE),
        ], end: Alignment.bottomRight, begin: Alignment.topLeft),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: height * 0.05,
                  left: width * 0.2,
                  right: width * 0.2,
                  child: Column(
                    children: [
                      DelayedDisplay(
                        delay: 0.6.seconds,
                        child: WidgetCircularAnimator(
                          innerColor: Colors.orange,
                          outerColor: Colors.black,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: imageUrl.isEmpty
                                      ? const Image(
                                          image: AssetImage(
                                              'assets/profile_icon.jpg'))
                                      : CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                color: ConstantColor.backgroundColor,
                                                  value: downloadProgress
                                                      .progress),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        )),
                            ),
                          ),
                        ),
                      ),
                      DelayedDisplay(
                        delay: 1.seconds,
                        child: GestureDetector(
                          onTap: () {
                            pickImage(context);
                          },
                          child: Container(
                            height: height * 0.05,
                            width: width * 0.45,
                            margin: const EdgeInsets.only(top: 25),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Change image',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: ConstantFonts.poppinsRegular),
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  color: ConstantColor.backgroundColor,
                                  Icons.image,
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: height * 0.40,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.10, vertical: height * 0.03),
                    height: height * 0.4,
                    decoration: BoxDecoration(
                        // color: Colors.black,
                        borderRadius: BorderRadius.circular(30)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DelayedDisplay(
                            delay: 1.seconds,
                            child: buildText(height, width, 'Name',
                                widget.staffDetails.name)),
                        DelayedDisplay(
                          delay: 1.2.seconds,
                          child: buildText(height, width, 'Email',
                              widget.staffDetails.email),
                        ),
                        DelayedDisplay(
                            delay: 1.4.seconds,
                            child: buildText(height, width, 'Department',
                                widget.staffDetails.department)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.80,
                  left: 0,
                  right: 0,
                  child: DelayedDisplay(
                    delay: 1.6.seconds,
                    child: Center(
                      child: TextButton.icon(
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          await FirebaseAuth.instance.signOut();
                          await HiveOperations().clearDetails();
                          final pref = await SharedPreferences.getInstance();
                          await pref.clear();

                          navigator.pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                              (route) => false);
                        },
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.black),
                        label: Text('Log out',
                            style: TextStyle(
                                fontSize: height * 0.020,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        icon: const Icon(Icons.logout_rounded),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.88,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: DelayedDisplay(
                      delay: 1.9.seconds,
                      child: Text(
                        'Version ${AppConstants.displayVersion}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: ConstantFonts.poppinsMedium,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget buildText(double height, double width, String title, String value) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        margin: EdgeInsets.symmetric(vertical: height * 0.01),
        height: height * 0.09,
        decoration: BoxDecoration(
            color: const Color(0xffEEF0FE),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: height * 0.015,
                fontWeight: FontWeight.bold,
                color: Colors.black26,
              ),
            ),
            Text(value,
                style: TextStyle(
                    fontSize: height * 0.018,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const Divider(
              // height: height * 0.03,
              color: Colors.black54,
              thickness: 1.0,
            ),
          ],
        ),
      );
}

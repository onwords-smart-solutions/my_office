import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      pickUploadImage(File(pickedFile.path));
    }
  }

  Future pickerCameraImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      pickUploadImage(File(pickedFile.path));
    }
  }

  Future<void> pickUploadImage(File image) async {
    var profileImage = firebaseStorage.ref().child('PROFILE IMAGE/${widget.staffDetails.uid}/');
    profileImage.putFile(File(image.path)).whenComplete(() async {
      final url = await profileImage.getDownloadURL();
      FirebaseDatabase.instance.ref().child('staff/${widget.staffDetails.uid}/').update({
        'profileImage': url,
      });

      if (!mounted) return;
      setState(() {
        imageUrl = url;
      });
    });
  }

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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      pickerCameraImage(context);
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.camera_alt_rounded, color: ConstantColor.backgroundColor),
                    title: Text(
                      'Camera',
                      style: TextStyle(fontSize: 18, fontFamily: ConstantFonts.sfProMedium),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      pickerGalleryImage(context);
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.photo_size_select_actual_rounded, color: ConstantColor.backgroundColor),
                    title: Text(
                      'Gallery',
                      style: TextStyle(fontSize: 18, fontFamily: ConstantFonts.sfProMedium),
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
    await FirebaseDatabase.instance.ref('staff/${widget.staffDetails.uid}/').once().then((value) {
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
    final size = MediaQuery.of(context).size;
    // print(imageUrl);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Profile', style: TextStyle(fontFamily: ConstantFonts.sfProMedium)),
          centerTitle: true),
      body: Container(
        width: size.width,
        margin: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 5.0,
              blurRadius: 10.0,
            ),
          ],
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // profile picture
              Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Image.asset('assets/profile_overlay.png', height: size.width * .6),
                      Container(
                        height: size.width * .4,
                        width: size.width * .4,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: imageUrl.isEmpty
                            ? const Image(image: AssetImage('assets/profile_icon.jpg'))
                            : CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(
                                    color: ConstantColor.backgroundColor, value: downloadProgress.progress),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                      )
                    ],
                  ),
                  TextButton(onPressed: () => pickImage(context), child: const Text('Edit')),
                  Text(
                    widget.staffDetails.name,
                    style: TextStyle(fontFamily: ConstantFonts.sfProBold, fontSize: 25.0),
                  ),
                  Text(
                    widget.staffDetails.email,
                    style: TextStyle(fontFamily: ConstantFonts.sfProMedium, fontSize: 15.0),
                  ),
                  Text(
                    widget.staffDetails.department,
                    style: TextStyle(fontFamily: ConstantFonts.sfProMedium, fontSize: 20.0),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              IconButton.filled(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    await FirebaseAuth.instance.signOut();
                    await HiveOperations().clearDetails();
                    final pref = await SharedPreferences.getInstance();
                    await pref.clear();

                    navigator.pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                  },
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.orange.shade700, padding: const EdgeInsets.all(15.0), iconSize: 30.0),
                  icon: const Icon(Icons.exit_to_app_rounded)),
              const SizedBox(height: 20.0),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned(
                      top: 20.0,
                      child: Text(
                        'Version : ${AppConstants.displayVersion}',
                        style: const TextStyle(color: Colors.grey, fontSize: 13.0),
                      )),
                  //bottom style
                  Image.asset('assets/id_bottom.png'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

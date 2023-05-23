import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
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
  final String currentAppVersion = '1.1.1';


  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final staff = FirebaseDatabase.instance.ref().child("staff");
  final firebaseStorage = FirebaseStorage.instance;

  String imageUrl = '';

  Future saveValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
        prefs.setString('imageValue', _image!.path.toString());
    });
  }

  getProfile(){
    staff.child(widget.staffDetails.uid).once().then((value) async {
      var profilePic;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      profilePic = value.snapshot.value;
      setState(() {
        try{
          imageUrl = profilePic['profileImage'].toString();
          prefs.setString('imageValueNet', imageUrl);
          print(imageUrl);
        } catch (e) {
          imageUrl = '';
        }
      });
    });
  }


  final picker = ImagePicker();

  File? _image;

  // File? get image => _image;

  Future pickerGalleryImage(BuildContext context) async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        pickUploadImage();

        saveValue();
        getProfile();
      }
    });
  }

  Future pickerCameraImage(BuildContext context) async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        pickUploadImage();
        saveValue();
        getProfile();
      }
    });
  }

  void pickUploadImage() async {
    var profileImage = firebaseStorage
        .ref()
        .child('PROFILE IMAGE/${widget.staffDetails.uid}/');
    setState(() {
      profileImage.putFile(File(_image!.path)).whenComplete(() async {
        imageUrl = await profileImage.getDownloadURL();
        FirebaseDatabase.instance
            .ref()
            .child('staff/${widget.staffDetails.uid}/')
            .update({
          'profileImage': imageUrl,
        }).then((value)async {
          imageUrl = await profileImage.getDownloadURL();
          // Provider.of<ProfileController>(context, listen: false).url = url;
        });
      });
    });
  }

  void pickImage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      pickerCameraImage(context);
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.camera),
                    title: const Text('Camera'),
                  ),
                  ListTile(
                    onTap: () {
                      pickerGalleryImage(context);
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.browse_gallery),
                    title: const Text('Gallery'),
                  ),
                ],
              ),
            ),
          );
        });
  }


  @override
  void initState() {
    getProfile();
    super.initState();
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
                                onTap: () {
                                  pickImage(context);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black.withOpacity(0.1),
                                    //     offset: const Offset(2, 2),
                                    //     spreadRadius: 2,
                                    //     blurRadius: 0,
                                    //   ),
                                    //   const BoxShadow(
                                    //       color: Color(0xffEEF0FE),
                                    //       offset: Offset(2, 2),
                                    //       spreadRadius: 2,
                                    //       blurRadius: 5),
                                    // ],
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: _image == null
                                        ? imageUrl == '' || imageUrl == 'null'
                                        ? const Icon(Icons.person)
                                        : CircleAvatar(
                                      backgroundImage:
                                      NetworkImage(imageUrl),
                                    )
                                        : CircleAvatar(
                                        backgroundImage: FileImage(
                                            File(_image!.path).absolute)),
                                  ),
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
                                width: width*0.3,
                                margin: const EdgeInsets.only(top: 20),
                                decoration:  BoxDecoration(
                                    color: Colors.black.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(20)

                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('Edit ',style: TextStyle(fontSize: 15),),
                                    Icon(
                                      Icons.edit,
                                      size: 15,
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

                              // Provider.of<TaskData>(context, listen: false)
                              //     .invoiceListData
                              //     .clear();
                              // Provider.of<TaskData>(context, listen: false)
                              //     .value
                              //     .clear();
                              // Provider.of<TaskData>(context, listen: false)
                              //     .deleteCustomerDetails(1);
                              navigator.pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => const LoginScreen()),
                                      (route) => false);
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.black),
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
        )
    );
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
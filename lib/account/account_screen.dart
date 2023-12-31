import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/account/profile_image_viewer.dart';
import 'package:my_office/app_version/version.dart';
import 'package:my_office/provider/user_provider.dart';
import 'package:my_office/util/custom_sheet.dart';
import 'package:my_office/util/image_custom_cropper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/login_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final staff = FirebaseDatabase.instance.ref().child("staff");
  final firebaseStorage = FirebaseStorage.instance;
  final picker = ImagePicker();

  Future pickerGalleryImage(String userId) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ImageCustomCropper(image: File(pickedFile.path), staffId: userId),
        ),
      );
    }
  }

  Future pickerCameraImage(String userId) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ImageCustomCropper(image: File(pickedFile.path), staffId: userId),
        ),
      );
    }
  }

  void pickImage(String userId, Size size) {
    CustomSheets.showImagePickerDialog(
      context: context,
      size: size,
      title: 'Pick image for profile',
      onTakePhoto: () => pickerCameraImage(userId),
      onChoosePhoto: () => pickerGalleryImage(userId),
    );
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
          title: Text('Profile', style: TextStyle()),
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
              Consumer<UserProvider>(builder: (ctx, userProvider, child) {
                return userProvider.user == null
                    ? Center(child: Lottie.asset('assets/animations/new_loading.json'))
                    : Column(
                        children: [
                          const SizedBox(height: 20.0),
                          Image.asset(
                            'assets/onwords.png',
                            height: 20,
                            fit: BoxFit.cover,
                          ),
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Image.asset('assets/profile_overlay.png', height: size.width * .6),
                              Hero(
                                tag: 'profile',
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) => ProfileImageViewer(
                                              name: userProvider.user!.name, url: userProvider.user!.profilePic)),
                                    );
                                  },
                                  child: Container(
                                    height: size.width * .4,
                                    width: size.width * .4,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: const BoxDecoration(shape: BoxShape.circle),
                                    child: userProvider.user!.profilePic.isEmpty
                                        ? const Image(image: AssetImage('assets/profile_icon.jpg'))
                                        : CachedNetworkImage(
                                            imageUrl: userProvider.user!.profilePic,
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                CircularProgressIndicator(
                                                    color: ConstantColor.backgroundColor,
                                                    value: downloadProgress.progress),
                                            errorWidget: (context, url, error) => const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                          ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          TextButton(
                            onPressed: () => pickImage(userProvider.user!.uid, size),
                            child: const Text('Edit'),
                          ),
                          Text(
                            userProvider.user!.name,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 25.0),
                          ),
                          Text(
                            userProvider.user!.email,
                            style: const TextStyle(fontSize: 15.0),
                          ),
                          Text(
                            DateFormat('dd-MM-yyyy')
                                .format(DateTime.fromMillisecondsSinceEpoch(userProvider.user!.dob)),
                            style: const TextStyle(fontSize: 15.0),
                          ),
                          Text(
                            userProvider.user!.department,
                            style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500),
                          ),

                        ],
                      );
              }),
              const SizedBox(height: 20.0),
              IconButton.filled(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    await FirebaseAuth.instance.signOut();
                    final pref = await SharedPreferences.getInstance();
                    await pref.clear();
                    Provider.of<UserProvider>(context, listen: false).clearUser();
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

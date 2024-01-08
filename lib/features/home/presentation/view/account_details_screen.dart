import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/features/home/presentation/view/profile_image_viewer.dart';
import 'package:my_office/features/theme/presentation/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utilities/constants/app_color.dart';
import '../../../../core/utilities/constants/app_version.dart';
import '../../../../core/utilities/custom_widgets/custom_image_cropper.dart';
import '../../../../core/utilities/custom_widgets/custom_sheets.dart';
import '../../../auth/presentation/provider/authentication_provider.dart';
import '../../../auth/presentation/view/login_screen.dart';
import '../../../theme/presentation/view/theme_selector.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final picker = ImagePicker();

  Future pickerGalleryImage(String userId) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      if(!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              CustomImageCropper(image: File(pickedFile.path), staffId: userId),
        ),
      );
    }
  }

  Future pickerCameraImage(String userId) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      if(!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              CustomImageCropper(image: File(pickedFile.path), staffId: userId),
        ),
      );
    }
  }

  void pickImage(String userId, Size size) {
    CustomSheets.showImagePickerDialog(
      context: context,
      size: size,
      title: 'Pick image for profile',
      subTitle: 'Take from Camera / Choose from Gallery ',
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).primaryColor,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25, color: Theme.of(context).primaryColor)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          margin: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(.1),
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // profile picture
                Consumer<AuthenticationProvider>(
                  builder: (ctx, userProvider, child) {
                    return userProvider.user == null
                        ? Center(
                            child: Lottie.asset(
                              'assets/animations/new_loading.json',
                            ),
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 20.0),
                             Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ?
                              Image.asset(
                                'assets/images/onwords_light.png',
                                height: 20,
                                fit: BoxFit.cover,
                              ):
                              Image.asset(
                                'assets/images/onwords_dark.png',
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                              const Gap(10),
                              Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Image.asset(
                                    'assets/profile_overlay.png',
                                    height: size.width * .6,
                                  ),
                                  Hero(
                                    tag: 'profile',
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ProfileImageViewer(
                                              name: userProvider.user!.name,
                                              url: userProvider.user!.url,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: size.width * .4,
                                        width: size.width * .4,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: userProvider.user!.url.isEmpty
                                            ? const Image(
                                                image: AssetImage(
                                                  'assets/profile_icon.jpg',
                                                ),
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: userProvider.user!.url,
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder: (
                                                  context,
                                                  url,
                                                  downloadProgress,
                                                ) =>
                                                    CircularProgressIndicator(
                                                  color: Theme.of(context).primaryColor,
                                                  strokeWidth: 2.0,
                                                  value:
                                                      downloadProgress.progress,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () =>
                                    pickImage(userProvider.user!.uid, size),
                                child: const Text(
                                    'Edit',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                ),
                                ),
                              ),
                              Text(
                                userProvider.user!.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25.0,
                                ),
                              ),
                              Text(
                                userProvider.user!.email,
                                style: const TextStyle(fontSize: 15.0),
                              ),
                              Text(
                                DateFormat('dd-MM-yyyy').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    userProvider.user!.dob,
                                  ),
                                ),
                                style: const TextStyle(fontSize: 15.0),
                              ),
                              Text(
                                userProvider.user!.dep,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                  },
                ),
                const ThemeSelector(),
                IconButton.filled(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    await FirebaseAuth.instance.signOut();
                    final pref = await SharedPreferences.getInstance();
                    await pref.clear();
                    if(!mounted) return;
                    Provider.of<AuthenticationProvider>(context, listen: false).clearUser();
                    Provider.of<ThemeProvider>(context,listen: false).clearAppTheme();
                    navigator.pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    padding: const EdgeInsets.all(15.0),
                    iconSize: 30.0,
                  ),
                  icon: const Icon(Icons.exit_to_app_rounded),
                ),
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Positioned(
                      top: 20.0,
                      child: Text(
                        'Version : ${AppVersion.androidAppShowVersion}',
                        style:
                            const TextStyle(fontSize: 13.0),
                      ),
                    ),
                    //bottom style
                    Image.asset('assets/id_bottom.png'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

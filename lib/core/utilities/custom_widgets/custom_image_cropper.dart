import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:provider/provider.dart';

import '../../../features/auth/presentation/provider/auth_provider.dart';

class CustomImageCropper extends StatefulWidget {
  final File image;
  final String staffId;

  const CustomImageCropper({
    Key? key,
    required this.image,
    required this.staffId,
  }) : super(key: key);

  @override
  State<CustomImageCropper> createState() => _CustomImageCropperState();
}

class _CustomImageCropperState extends State<CustomImageCropper> {
  final _controller = CropController();
  final ValueNotifier<Uint8List?> _image = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          'Move and Scale',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ValueListenableBuilder(
        valueListenable: _image,
        builder: (ctx, image, child) {
          return image != null ? _uploading(image, size) : child!;
        },
        child: SizedBox.expand(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              // -- cropping --
              Crop(
                fixArea: true,
                image: widget.image.readAsBytesSync(),
                controller: _controller,
                progressIndicator: const CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
                  strokeWidth: 2.0,
                ),
                aspectRatio: 1,
                initialAreaBuilder: (rect) => Rect.fromCircle(
                  center: Offset(size.width / 2, size.height / 3),
                  radius: size.width * .4,
                ),
                cornerDotBuilder: (size, edgeAlignment) =>
                    const SizedBox.shrink(),
                onCropped: (image) async {
                  _image.value = image;
                  File croppedImage = File(widget.image.path);
                  croppedImage.writeAsBytesSync(image);
                  await pickUploadImage(croppedImage, widget.staffId);
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
                baseColor: Theme.of(context).scaffoldBackgroundColor,
                maskColor:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(.8),
                withCircleUi: true,
                interactive: true,
              ),
              //-- button --
              Positioned(
                bottom: MediaQuery.sizeOf(context).height * .02,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _controller.crop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        'Choose',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _uploading(Uint8List image, Size size) {
    return SizedBox.expand(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // -- cropped image --

          ClipRRect(
            borderRadius: BorderRadius.circular(500.0),
            child: Image.memory(
              image,
              height: size.width * .8,
              width: size.width * .8,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(.2),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              // Adjust sigmaX and sigmaY for different blur amounts
              child: Container(
                color: Colors
                    .transparent, // You can change this color to achieve the desired overlay effect
              ),
            ),
          ),
          // -- loading --
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
                  strokeWidth: 2.0,
                ),
                SizedBox(height: 10.0),
                Text(
                  'Saving',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickUploadImage(File image, String userId) async {
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    var profileImage =
        FirebaseStorage.instance.ref().child('PROFILE IMAGE/$userId/');
    await profileImage.putFile(File(image.path)).whenComplete(() async {
      final url = await profileImage.getDownloadURL();
      await FirebaseDatabase.instance.ref().child('staff/$userId/').update({
        'profileImage': url,
      });
      // userProvider.updateImage(url);
    });
  }
}

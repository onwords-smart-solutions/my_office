import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomSheets {
  static showImagePickerDialog({
    required BuildContext context,
    required Size size,
    required String title,
    required Function onTakePhoto,
    required Function onChoosePhoto,
    AnimationController? dialogController,
  }) {
    return showModalBottomSheet(
      transitionAnimationController: dialogController,
      context: context,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      elevation: 0.0,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          width: size.width,
          padding: const EdgeInsets.all(18.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // -- heading --
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 35.0,
                    width: 35.0,
                    child: IconButton.filled(
                      onPressed: () => Navigator.of(ctx).pop(),
                      color: Colors.black,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(.3),
                        iconSize: 20.0,
                      ),
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),
                ],
              ),
              // -- options --
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey.withOpacity(.3),
                ),
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(ctx).pop();
                          onTakePhoto();
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10.0),
                          ),
                        ),
                        trailing:
                            const Icon(Iconsax.camera, color: Colors.black),
                        title: const Text('Take Photo'),
                      ),
                    ),
                    Divider(color: Colors.grey.withOpacity(.5), height: 0.0),
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(ctx).pop();
                          onChoosePhoto();
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(10.0),
                          ),
                        ),
                        trailing:
                            const Icon(Iconsax.gallery, color: Colors.black),
                        title: const Text('Choose Photo'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

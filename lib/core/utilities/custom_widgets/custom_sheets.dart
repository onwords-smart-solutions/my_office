import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomSheets {
  static showImagePickerDialog({
    required BuildContext context,
    required Size size,
    required String title,
    String? subTitle,
    required Function onTakePhoto,
    required Function onChoosePhoto,
    AnimationController? dialogController,
  }) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      transitionAnimationController: dialogController,
      context: context,
      useSafeArea: true,
      elevation: 0.0,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // -- heading --
              ListTile(
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Text(
                  subTitle!,
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing:  IconButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: IconButton.styleFrom(foregroundColor: Colors.grey),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
              Divider(
                color: Colors.grey.withOpacity(.3),
                height: 0.0,
                thickness: .5,
              ),
              // -- options --
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
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
                        Icon(Iconsax.camera, color: Theme.of(context).primaryColor),
                        title: const Text('Take Photo'),
                      ),
                    ),
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
                        Icon(Iconsax.gallery, color: Theme.of(context).primaryColor),
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

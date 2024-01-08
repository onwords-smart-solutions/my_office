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
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                subtitle: Text(
                  subTitle!,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(.4),
                  ),
                ),
                trailing:  IconButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: IconButton.styleFrom(foregroundColor: Colors.grey),
                  icon: Icon(Icons.close_rounded,color: Theme.of(context).primaryColor,),
                ),
              ),
              Divider(
                color: Theme.of(context).primaryColor.withOpacity(.4),
                height: 0.0,
                thickness: .7,
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
                        title: Text('Take Photo',style: TextStyle(color: Theme.of(context).primaryColor,),),
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
                        title: Text('Choose Photo', style: TextStyle(color: Theme.of(context).primaryColor,),),
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

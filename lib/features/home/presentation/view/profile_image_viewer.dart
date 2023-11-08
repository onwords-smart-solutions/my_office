import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';

class ProfileImageViewer extends StatelessWidget {
  final String name;
  final String url;

  const ProfileImageViewer({Key? key, required this.name, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xff252525),
      appBar: AppBar(
        backgroundColor: const Color(0xff252525).withOpacity(.8),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          splashRadius: 20.0,
        ),
      ),
      body: SizedBox.expand(
        child: InteractiveViewer(
          child: Center(
            child: Hero(
              tag: 'profile',
              child: SizedBox(
                height: size.height * .5,
                width: size.width,
                child: url.isEmpty
                    ? const Image(image: AssetImage('assets/profile_icon.jpg'))
                    : CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                          color: AppColor.backGroundColor,
                          value: downloadProgress.progress,
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

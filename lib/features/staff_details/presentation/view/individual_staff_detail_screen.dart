import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/features/staff_details/data/model/staff_detail_model.dart';

class FullStaffDetails extends StatefulWidget {
  final StaffDetailModel allDetails;

  const FullStaffDetails({super.key, required this.allDetails});

  @override
  State<FullStaffDetails> createState() => _FullStaffDetailsState();
}

class _FullStaffDetailsState extends State<FullStaffDetails> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff164B60),
              Colors.white38,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: size.height * 0.3,
                width: size.width * 0.6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.allDetails.profileImage!,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (
                      context,
                      url,
                      downloadProgress,
                    ) =>
                        CircularProgressIndicator(
                      color: AppColor.primaryColor,
                      strokeWidth: 2,
                      value: downloadProgress.progress,
                    ),
                    errorWidget: (context, url, error) => const Image(
                      image: AssetImage(
                        'assets/profile_pic.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.08),
            Row(
              children: [
                SizedBox(width: size.width * 0.06),
                const Text(
                  'Name  ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                SizedBox(width: size.width * 0.18),
                SelectableText(
                  widget.allDetails.name,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              children: [
                SizedBox(width: size.width * 0.06),
                const Text(
                  'Department  ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                SizedBox(width: size.width * 0.05),
                SelectableText(
                  widget.allDetails.department,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              children: [
                SizedBox(width: size.width * 0.06),
                const Text(
                  'Email id  ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                SizedBox(width: size.width * 0.14),
                Flexible(
                  child: SelectableText(
                    widget.allDetails.emailId!,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

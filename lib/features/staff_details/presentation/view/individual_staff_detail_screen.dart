import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(widget.allDetails.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 25),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const Gap(50),
          SizedBox(
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
                  color: Theme.of(context).primaryColor,
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
          SizedBox(height: size.height * 0.08),
          Row(
            children: [
              SizedBox(width: size.width * 0.06),
              Text(
                'Name  ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(width: size.width * 0.18),
              SelectableText(
                widget.allDetails.name,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            children: [
              SizedBox(width: size.width * 0.06),
              Text(
                'Department  ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(width: size.width * 0.05),
              SelectableText(
                widget.allDetails.department,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            children: [
              SizedBox(width: size.width * 0.06),
              Text(
                'Email id  ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(width: size.width * 0.14),
              Flexible(
                child: SelectableText(
                  widget.allDetails.emailId!,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/features/staff_details/data/model/staff_detail_model.dart';
import 'package:my_office/features/staff_details/presentation/provider/staff_detail_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/utilities/constants/app_main_template.dart';
import 'individual_staff_detail_screen.dart';

class StaffDetails extends StatefulWidget {
  const StaffDetails({super.key});

  @override
  State<StaffDetails> createState() => _StaffDetailsState();
}

class _StaffDetailsState extends State<StaffDetails> {
  List<StaffDetailModel> allStaffs = [];
  String imageUrl = '';

  String department = 'ALL';
  final List<String> dropDown = [
    'ALL',
    'APP',
    'RND',
    'MEDIA',
    'WEB',
    'PR',
  ];

  @override
  void initState() {
    final context = this.context;
    Provider.of<StaffDetailProvider>(context, listen: false).getAllStaffNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Onwords staff details🧑‍💻👨‍‍💼',
      templateBody: buildEmployeeNames(),
      bgColor: AppColor.backGroundColor,
    );
  }

  buildEmployeeNames() {
    final staffProvider =
        Provider.of<StaffDetailProvider>(context, listen: false);
    if (department == 'APP') {
      allStaffs = staffProvider.allNames
          .where((element) => element.department == 'APP')
          .toList();
    } else if (department == 'RND') {
      allStaffs = staffProvider.allNames
          .where((element) => element.department == 'RND')
          .toList();
    } else if (department == 'MEDIA') {
      allStaffs = staffProvider.allNames
          .where((element) => element.department == 'MEDIA')
          .toList();
    } else if (department == 'WEB') {
      allStaffs = staffProvider.allNames
          .where((element) => element.department == 'WEB')
          .toList();
    } else if (department == 'PR') {
      allStaffs = staffProvider.allNames
          .where((element) => element.department == 'PR')
          .toList();
    } else {
      allStaffs = staffProvider.allNames;
    }
    var size = MediaQuery.of(context).size;
    return Consumer<StaffDetailProvider>(
      builder: (context, provider, child){
       return  provider.isLoading
            ? Center(
          child: Lottie.asset('assets/animations/leave_loading.json'),
        )
            : Column(
          children: [
            SizedBox(height: size.height * 0.01),
            Text(
              'Total staffs: ${allStaffs.length}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info,
                            color: Colors.grey,
                            size: 15,
                          ),
                          SizedBox(width: size.width * 0.02),
                          const Text(
                            'Tap to View staff details',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.info, color: Colors.grey, size: 15,),
                          SizedBox(width: size.width * 0.02),
                          const Text(
                            'Long press to Delete staff details',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: size.width * 0.04),
                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  position: PopupMenuPosition.under,
                  elevation: 10,
                  itemBuilder: (ctx) => List.generate(
                    dropDown.length,
                        (i) {
                      return PopupMenuItem(
                        child: Text(
                          dropDown[i],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            department = dropDown[i];
                          });
                        },
                      );
                    },
                  ),
                  icon: Icon(
                    Icons.sort,
                    color: department == "APP"
                        ? const Color(0xff6527BE)
                        : department == 'RND'
                        ? const Color(0xff0EA293)
                        : department == 'MEDIA'
                        ? const Color(0xffDB005B)
                        : department == 'WEB'
                        ? const Color(0xff9A208C)
                        : department == 'PR'
                        ? const Color(0xffF24C3D)
                        : Colors.black,
                  ),
                ),
                Text(
                  department,
                  style: TextStyle(
                    color: department == "APP"
                        ? const Color(0xff6527BE)
                        : department == 'RND'
                        ? const Color(0xff0EA293)
                        : department == 'MEDIA'
                        ? const Color(0xffDB005B)
                        : department == 'WEB'
                        ? const Color(0xff9A208C)
                        : department == 'PR'
                        ? const Color(0xffF24C3D)
                        : Colors.black,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            Expanded(
              child: GridView.builder(
                itemCount: allStaffs.length,
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.14 / 1.1,
                  crossAxisCount: 4,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 1,
                ),
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => FullStaffDetails(
                            allDetails: allStaffs[i],
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text(
                              '⚠️Warning!!!',
                              style: TextStyle(
                                fontSize: 17,
                                color: CupertinoColors.destructiveRed,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            content: RichText(
                              text: TextSpan(
                                text: 'Do you want to delete all details of ',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: allStaffs[i].name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' from Onwords database?',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: FilledButton.tonal(
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: CupertinoColors.destructiveRed,
                                    ),
                                  ),
                                  onPressed: () async {
                                    await staffProvider.removeStaffDetails(
                                      allStaffs[i].uid,
                                    );
                                    staffProvider.allNames;
                                    if (!mounted) return;
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: FilledButton.tonal(
                                  child: const Text(
                                    'No',
                                    style: TextStyle(
                                      color: CupertinoColors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          allStaffs[i].name,
                          style: TextStyle(
                            color: department == "APP"
                                ? const Color(0xff6527BE)
                                : department == 'RND'
                                ? const Color(0xff0EA293)
                                : department == 'MEDIA'
                                ? const Color(0xffDB005B)
                                : department == 'WEB'
                                ? const Color(0xff9A208C)
                                : department == 'PR'
                                ? const Color(0xffF24C3D)
                                : Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.13,
                          width: size.width * 0.24,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: allStaffs[i].profileImage!.isEmpty
                                ? const Image(
                              image:
                              AssetImage('assets/profile_pic.png'),
                            )
                                : CachedNetworkImage(
                              imageUrl: allStaffs[i].profileImage!,
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
                              errorWidget: (context, url, error) =>
                              const Image(
                                image: AssetImage(
                                  'assets/profile_pic.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

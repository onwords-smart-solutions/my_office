import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
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
  String imageUrl = '';

  String department = 'ALL';
  final List<String> dropDown = [
    'ALL',
    'APP',
    'RND',
    'MEDIA',
    'WEB',
    'PR',
    'INSTALLATION',
    'HR',
    'MANAGEMENT',
    'OFFICE STAFF',
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
      subtitle: 'Staff details',
      templateBody: buildEmployeeNames(),
      bgColor: AppColor.backGroundColor,
    );
  }

  buildEmployeeNames() {
    final staffProvider =
        Provider.of<StaffDetailProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Consumer<StaffDetailProvider>(
      builder: (context, provider, child) {
        return provider.isLoading
            ? Center(
                child: Lottie.asset('assets/animations/leave_loading.json'),
              )
            : Consumer<StaffDetailProvider>(
                builder: (context, staffs, child) {
                  var allStaffs = staffs.allNames;
                  if (department == 'ALL') {
                    allStaffs = staffs.allNames;
                  } else {
                    allStaffs = staffs.allNames
                        .where((element) => element.department == department)
                        .toList();
                  }
                  return Column(
                    children: [
                      SizedBox(height: size.height * 0.01),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total staffs: ${allStaffs.length}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            PopupMenuButton(
                              surfaceTintColor: Colors.transparent,
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
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor,
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(CupertinoIcons.sort_down, color: Theme.of(context).primaryColor,),
                                  Text(
                                    department,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Expanded(
                        child: GridView.builder(
                          itemCount: allStaffs.length,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.14 / 1,
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
                                      surfaceTintColor: Colors.transparent,
                                      title: const Text(
                                        '⚠️Warning!!!',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: CupertinoColors.destructiveRed,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'SF Pro',
                                        ),
                                      ),
                                      content: RichText(
                                        text: TextSpan(
                                          text:
                                              'Do you want to delete all details of ',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'SF Pro',
                                          ),
                                          children: [
                                            TextSpan(
                                              text: allStaffs[i].name,
                                              style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'SF Pro',
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' from Onwords database?',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'SF Pro',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        FilledButton.tonal(
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          onPressed: () async {
                                            await staffProvider
                                                .removeStaffDetails(
                                              allStaffs[i].uid,
                                            );
                                            staffProvider.getAllStaffNames();
                                            if (!mounted) return;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FilledButton.tonal(
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      allStaffs[i].name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    const Gap(10),
                                    SizedBox(
                                      height: size.height * 0.13,
                                      width: size.width * 0.24,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: allStaffs[i].profileImage!.isEmpty
                                            ? const Image(
                                                image: AssetImage(
                                                    'assets/profile_pic.png',),
                                              )
                                            : CachedNetworkImage(
                                                imageUrl:
                                                    allStaffs[i].profileImage!,
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder: (
                                                  context,
                                                  url,
                                                  downloadProgress,
                                                ) =>
                                                    CircularProgressIndicator(
                                                  color: Theme.of(context).primaryColor,
                                                  strokeWidth: 2,
                                                  value:
                                                      downloadProgress.progress,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
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
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
      },
    );
  }
}

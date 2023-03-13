import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/database/hive_operations.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Account/account_screen.dart';
import '../Constant/fonts/constant_font.dart';

class MainTemplate extends StatefulWidget {
  final Widget templateBody;
  final String subtitle;
  final Color bgColor;
  final Widget? bottomImage;

  const MainTemplate(
      {Key? key,
      required this.subtitle,
      required this.templateBody,
      required this.bgColor,
      this.bottomImage})
      : super(key: key);

  @override
  State<MainTemplate> createState() => _MainTemplateState();
}

class _MainTemplateState extends State<MainTemplate> {
  final HiveOperations _hiveOperations = HiveOperations();
  StaffModel? staffInfo;

  void getStaffDetail() async {
    final data = await _hiveOperations.getStaffDetail();
    setState(() {
      staffInfo = data;
    });
  }

  SharedPreferences? preferences;

  String preferencesImageUrl = '';
  // String preferencesImageUrl2 = '';

  Future getImageUrl() async {
    preferences = await SharedPreferences.getInstance();
    // String? image = preferences?.getString('imageValue');
    String? imageNet = preferences?.getString('imageValueNet');
    if (imageNet == null) return;
    setState(() {
      // preferencesImageUrl = image.toString();
      preferencesImageUrl = imageNet;
      // print(preferencesImageUrl2);
    });
  }

  @override
  void initState() {
    getStaffDetail();
    getImageUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 5));
        setState(() {
          _pageLoadController();
        });

      },
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Positioned(
                top: 0,
                child: Container(
                  height: height * 0.95,
                  width: width,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewPadding.top * 1.5),
                  decoration: BoxDecoration(
                    color: widget.bgColor,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Name and subtitle
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    staffInfo == null
                                        ? 'Hi'
                                        : 'Hi ${staffInfo!.name}',
                                    style: TextStyle(
                                      fontFamily: ConstantFonts.poppinsMedium,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                  Text(
                                    widget.subtitle,
                                    style: TextStyle(
                                      fontFamily: ConstantFonts.poppinsMedium,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),

                              //Profile icon
                              GestureDetector(
                                onTap: () {
                                  // getImageUrl();
                                  HapticFeedback.mediumImpact();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => AccountScreen(
                                          staffDetails: staffInfo!)));
                                },
                                child: SizedBox(
                                  height: height * 0.08,
                                  width: height * 0.08,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child:  preferencesImageUrl == ''
                                        ? const Icon(Iconsax.user) : Image.network(preferencesImageUrl,fit: BoxFit.cover,)
                                        // : Image.file(
                                        //     File(preferencesImageUrl).absolute,
                                        //     fit: BoxFit.cover,
                                        //   ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        //Custom widget section
                        Expanded(child: widget.templateBody),
                      ],
                    ),
                  ),
                ),
              ),
              //Illustration at the bottom
              if (widget.bottomImage != null) widget.bottomImage!,
            ],
          ),
        ),
      ),
    );
  }

  Future _pageLoadController() async {
    setState(() {
      getImageUrl();
    });
  }
}

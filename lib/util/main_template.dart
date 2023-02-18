import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/database/hive_operations.dart';
import 'package:my_office/models/staff_model.dart';
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
  @override
  void initState() {
    HiveOperations().getUStaffDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   final height =  MediaQuery.of(context).size.height;
   final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
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
                  child: ValueListenableBuilder(
                      valueListenable: staffDetails,
                      builder: (BuildContext ctx, List<StaffModel> staffInfo, Widget? child) {
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //Name and subtitle
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        staffInfo.isEmpty
                                            ? 'Hi'
                                            : 'Hi ${staffInfo[0].name}',
                                        style: TextStyle(
                                          fontFamily:
                                              ConstantFonts.poppinsMedium,
                                          fontSize: 24.0,
                                        ),
                                      ),
                                      Text(
                                        widget.subtitle,
                                        style: TextStyle(
                                          fontFamily:
                                              ConstantFonts.poppinsMedium,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),

                                  //Profile icon
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => AccountScreen(staffDetails:  staffInfo[0])));
                                    },
                                    child: const CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor:
                                          ConstantColor.backgroundColor,
                                      foregroundColor: Colors.white,
                                      child: Icon(Iconsax.user),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                             SizedBox(height: height * 0.01),

                            //Custom widget section
                            Expanded(child: widget.templateBody),

                          ],
                        );
                      }),
                ),
              ),
            ),
            //Illustration at the bottom
            if (widget.bottomImage != null) widget.bottomImage!,
          ],
        ),
      ),
    );
  }
}

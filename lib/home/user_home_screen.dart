import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/refreshment/refreshement_screen.dart';
import 'package:my_office/util/main_template.dart';

import '../Absentees/absentees.dart';
import '../Constant/fonts/constant_font.dart';
import '../leads/search_leads.dart';
import '../leave_apply/leave_apply_screen.dart';
import '../leave_approval/leave_request.dart';
import '../onyx/announcement.dart';
import '../refreshment/refreshment.dart';
import '../work_done/work_complete.dart';
import '../work_manager/work_entry.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      name: 'Test Admin',
      subtitle: 'Choose your destination here!',
      templateBody: buildMenuGrid(),
      bgColor: ConstantColor.background1Color,
    );
  }

  Widget buildMenuGrid() {
    return GridView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          mainAxisExtent: 230
          // childAspectRatio: 3.0

          ),
      children: [
        buildButton(
          name: 'Work Manager',
          image: Image.asset(
            'assets/work_entry.png',
            scale: 3.5,
          ),
          page: const WorkEntryScreen(),
        ),
        buildButton(
            name: 'Refreshment',
            image: Image.asset(
              'assets/refreshment.png',
              scale: 3.8,
            ),
            page: const RefreshmentScreen()),
        buildButton(
            name: 'Leave form',
            image: Image.asset('assets/leave_apply.png'),
            page: const LeaveApplyScreen()),
        buildButton(
            name: 'Search leads',
            image: Image.asset(
              'assets/lead search.png',
              scale: 3.0,
            ),
            page: const SearchLeadsScreen()),
        buildButton(
            name: 'Onyx',
            image: Image.asset(
              'assets/onxy.png',
              scale: 3.4,
            ),
            page: const AnnouncementScreen()),
        buildButton(
            name: 'Work done',
            image: Image.asset(
              'assets/work_entry.png',
              scale: 3.5,
            ),
            page: const WorkCompleteViewScreen()),
        buildButton(
            name: 'Absent Details',
            image: Image.asset(
              'assets/lead search.png',
              scale: 3.0,
            ),
            page: const AbsenteeScreen()),
        buildButton(
          name: 'Leave Approval page',
          image: Image.asset(
            'assets/leave form.png',
            scale: 4.0,
          ),
          page: const LeaveApprovalScreen(),
        ),
      ],
    );
  }

  Widget buildButton(
      {required String name, required Image image, required Widget page}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));

      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: const Color(0xffDAD6EE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: image),
            AutoSizeText(
              name,
              style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                color: ConstantColor.blackColor,
              ),
              maxFontSize: 18,
              minFontSize: 12,
            )
          ],
        ),
      ),
    );
  }
}

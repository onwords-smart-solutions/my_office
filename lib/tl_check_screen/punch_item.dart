import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/models/custom_punching_model.dart';

class PunchItem extends StatelessWidget {
  final CustomPunchModel punchDetail;

  const PunchItem({Key? key, required this.punchDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color topContainerColor = Colors.green.shade400;
    IconData icon = Icons.badge_rounded;
    String status = 'Present on Time';

    if (punchDetail.isProxy) {
      icon = Icons.phone_android_rounded;
    }

    if (punchDetail.checkInTime == null) {
      topContainerColor = Colors.grey.shade600;
      status = 'Absent today';
    } else if (punchDetail.checkInTime!
                .difference(DateTime(punchDetail.checkInTime!.year, punchDetail.checkInTime!.month,
                    punchDetail.checkInTime!.day, 09, 00))
                .inMinutes >
            10 &&
        punchDetail.checkInTime!
                .difference(DateTime(punchDetail.checkInTime!.year, punchDetail.checkInTime!.month,
                    punchDetail.checkInTime!.day, 09, 20))
                .inMinutes <=
            0) {
      topContainerColor = Colors.orangeAccent.shade400;
      status =
          'Late by ${punchDetail.checkInTime!.difference(DateTime(punchDetail.checkInTime!.year, punchDetail.checkInTime!.month, punchDetail.checkInTime!.day, 09, 00)).inMinutes - 10} mins';
    } else if (punchDetail.checkInTime!
            .difference(DateTime(
                punchDetail.checkInTime!.year, punchDetail.checkInTime!.month, punchDetail.checkInTime!.day, 09, 00))
            .inMinutes >
        20) {
      topContainerColor = Colors.red.shade400;
      status =
          'Late by ${punchDetail.checkInTime!.difference(DateTime(punchDetail.checkInTime!.year, punchDetail.checkInTime!.month, punchDetail.checkInTime!.day, 09, 00)).inMinutes - 10} mins';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Colors.grey.withOpacity(.3)),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          punchDetail.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20.0, fontFamily: ConstantFonts.sfProBold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        ' (${punchDetail.department})',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                          fontFamily: ConstantFonts.sfProBold,
                        ),
                      ),
                    ],
                  ),
                  if (punchDetail.checkInTime != null)
                    Text(
                      'Check In : ${timeFormat(punchDetail.checkInTime!)}',
                      style: TextStyle(fontFamily: ConstantFonts.sfProMedium),
                    ),
                  if (punchDetail.checkInTime != null)
                    Text(
                      punchDetail.checkOutTime == null
                          ? 'Check Out : No entry'
                          : 'Check Out : ${timeFormat(punchDetail.checkOutTime!)}',
                      style: TextStyle(fontFamily: ConstantFonts.sfProMedium),
                    ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Text(
                status,
                style: TextStyle(fontFamily: ConstantFonts.poppinsBold, color: topContainerColor),
              ),
              const SizedBox(height: 10.0),
              if (punchDetail.checkInTime != null)
                Icon(
                  icon,
                  color: topContainerColor,
                  size: 30.0,
                )
            ],
          ),
          Container(
            width: 30.0,
            height: MediaQuery.sizeOf(context).height * .12,
            margin: const EdgeInsets.only(left: 5.0),
            decoration: BoxDecoration(
              color: topContainerColor,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String timeFormat(DateTime time) => DateFormat.jm().format(time);

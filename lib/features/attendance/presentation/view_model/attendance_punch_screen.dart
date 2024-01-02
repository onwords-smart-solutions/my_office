import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/features/attendance/data/model/punch_model.dart';

class AttendancePunchItem extends StatelessWidget {
  final AttendancePunchModel punchDetail;

  const AttendancePunchItem({Key? key, required this.punchDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color topContainerColor = Colors.green.shade400;
    IconData icon = Icons.badge_rounded;
    String status = 'Present on Time';
    DateTime endTime = DateTime.now();

    List<String> punchInComponents = punchDetail.punchIn.split(':');
    int punchInHour = int.parse(punchInComponents[0]);
    int punchInMinute = int.parse(punchInComponents[1]);

    String formattedHour = punchInHour.toString().padLeft(2, '0');
    String formattedMinute = punchInMinute.toString().padLeft(2, '0');

    DateTime punchInTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.parse(formattedHour),
      int.parse(formattedMinute),
    );

      if (punchDetail.isProxy) {
        icon = Icons.phone_android_rounded;
      }

      if (punchDetail.checkOutTime != null) {
        endTime = punchDetail.checkOutTime!;
      }

      if (punchDetail.checkInTime == null) {
        topContainerColor = Colors.grey;
        status = 'Absent today';
      } else if (punchDetail.checkInTime!
              .difference(
                DateTime(
                  punchDetail.checkInTime!.year,
                  punchDetail.checkInTime!.month,
                  punchDetail.checkInTime!.day,
                  int.parse(formattedHour),
                  int.parse(formattedMinute),
                ),
              )
              .inMinutes >
          20) {
        topContainerColor = Colors.red.shade400;
        status = 'Late by ${punchDetail.checkInTime!.difference(
              DateTime(
                punchDetail.checkInTime!.year,
                punchDetail.checkInTime!.month,
                punchDetail.checkInTime!.day,
                int.parse(formattedHour),
                int.parse(formattedMinute),
              ),
            ).inMinutes} mins';
      } else if (punchDetail.checkInTime!
                  .difference(
                    DateTime(
                      punchDetail.checkInTime!.year,
                      punchDetail.checkInTime!.month,
                      punchDetail.checkInTime!.day,
                      int.parse(formattedHour),
                      int.parse(formattedMinute),
                    ),
                  )
                  .inMinutes >
              10 &&
          punchInTime
                  .difference(
                    DateTime(
                      punchInTime.year,
                      punchInTime.month,
                      punchInTime.day,
                      int.parse(formattedHour),
                      int.parse(formattedMinute),
                    ).add(const Duration(minutes: 20)),
                  )
                  .inMinutes <=
              0) {
        topContainerColor = Colors.orangeAccent.shade400;
        status = 'Late by ${punchDetail.checkInTime!.difference(
              DateTime(
                punchDetail.checkInTime!.year,
                punchDetail.checkInTime!.month,
                punchDetail.checkInTime!.day,
                int.parse(formattedHour),
                int.parse(formattedMinute),
              ),
            ).inMinutes} mins';
      } else if (punchDetail.checkInTime!
                  .difference(
                    DateTime(
                      punchDetail.checkInTime!.year,
                      punchDetail.checkInTime!.month,
                      punchDetail.checkInTime!.day,
                      int.parse(formattedHour),
                      int.parse(formattedMinute),
                    ),
                  )
                  .inMinutes >
              0 &&
          punchInTime
                  .difference(
                    DateTime(
                      punchInTime.year,
                      punchInTime.month,
                      punchInTime.day,
                      int.parse(formattedHour),
                      int.parse(formattedMinute),
                    ).add(const Duration(minutes: 10)),
                  )
                  .inMinutes <=
              0) {
        topContainerColor = Colors.amber.shade500;
        status = 'Late by ${punchDetail.checkInTime!.difference(
              DateTime(
                punchDetail.checkInTime!.year,
                punchDetail.checkInTime!.month,
                punchDetail.checkInTime!.day,
                int.parse(formattedHour),
                int.parse(formattedMinute),
              ),
            ).inMinutes} mins';
      }

    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Theme.of(context).primaryColor.withOpacity(.1),
      ),
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
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        ' (${punchDetail.department})',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  if (punchDetail.checkInTime != null)
                    Text(
                      'Check In : ${timeFormat(punchDetail.checkInTime!)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  if (punchDetail.checkInTime != null)
                    Text(
                      punchDetail.checkOutTime == null
                          ? 'Check Out : No entry'
                          : 'Check Out : ${timeFormat(punchDetail.checkOutTime!)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: topContainerColor,
                ),
              ),
              const SizedBox(height: 10.0),
              if (punchDetail.checkInTime != null) ...[
                Icon(
                  icon,
                  color: topContainerColor,
                  size: 30.0,
                ),
                Text(
                  'Duration : ${duration(punchDetail.checkInTime!, endTime)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
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

String duration(DateTime start, DateTime end) {
  final diff = end.difference(start);
  int hours = diff.inHours;
  int minutes = diff.inMinutes % 60;

  return '${hours}h ${minutes}m';
}

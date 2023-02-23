import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/PR/visit/product_detail_screen.dart';
import 'package:my_office/PR/visit/summary_notes.dart';
import 'package:my_office/PR/visit/verification_screen.dart';
import 'package:my_office/database/hive_operations.dart';
import 'package:my_office/models/visit_model.dart';

import '../../Constant/fonts/constant_font.dart';

class ResumeVisitFormItem extends StatelessWidget {
  final VisitModel visitDetail;

  const ResumeVisitFormItem({Key? key, required this.visitDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(visitDetail.customerPhoneNumber),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        HiveOperations()
            .deleteVisitEntry(phoneNumber: visitDetail.customerPhoneNumber);
      },
      background: background(),
      child: Container(
        margin: const EdgeInsets.all(5.0),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: () {
              switch (visitDetail.stage) {
                case 'visitScreen':
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => VerificationScreen(
                          name: visitDetail.customerName,
                          phone: visitDetail.customerPhoneNumber)));
                  break;

                case 'verificationScreen':
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(
                            visiData: visitDetail,
                          )));
                  break;
                case 'productScreen':
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SummaryAndNotes(visitInfo: visitDetail)));
                  break;
              }
            },
            minLeadingWidth: 0.0,
            enableFeedback: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            tileColor: Colors.grey.withOpacity(.25),
            leading: const Icon(Icons.edit_note_rounded),
            title: Text(visitDetail.customerName,
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsBold, fontSize: 15.0)),
            subtitle: Text(DateFormat('y-MM-dd').format(visitDetail.dateTime),
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium, fontSize: 12.0)),
            trailing: Text(DateFormat.jm().format(visitDetail.dateTime),
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium, fontSize: 12.0)),
          ),
        ),
      ),
    );
  }

  Widget background() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), color: Colors.red),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Delete',
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium, color: Colors.white),
          ),
          const Icon(Icons.delete_rounded, color: Colors.white),
        ],
      ),
    );
  }
}

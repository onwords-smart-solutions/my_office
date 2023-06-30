
import 'package:flutter/material.dart';
import 'package:my_office/PR/pr_workdone/prWorkDoneModel.dart';
import '../../Constant/colors/constant_colors.dart';
import '../../Constant/fonts/constant_font.dart';
import '../../util/screen_template.dart';

class PrFullWorkDetails extends StatefulWidget {
  final PRWorkDoneModel staffDetail;

  const PrFullWorkDetails({Key? key, required this.staffDetail})
      : super(key: key);

  @override
  State<PrFullWorkDetails> createState() => _PrFullWorkDetailsState();
}

class _PrFullWorkDetailsState extends State<PrFullWorkDetails> {

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildPrWorks(),
      title: widget.staffDetail.name,
    );
  }



  Widget buildPrWorks() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(3),
        },
        border: TableBorder.all(
          borderRadius: BorderRadius.circular(10),
          color: ConstantColor.backgroundColor,
          width: 2,
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text(
                  "Calls",
                  style: TextStyle(
                    color: ConstantColor.headingTextColor,
                    fontSize: 16,
                    fontFamily: ConstantFonts.sfProRegular,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: SelectableText(
                 widget.staffDetail.calls.toString(),
                  style: TextStyle(
                      color: ConstantColor.backgroundColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsBold),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text(
                  "Invoice",
                  style: TextStyle(
                    color: ConstantColor.headingTextColor,
                    fontSize: 16,
                    fontFamily: ConstantFonts.sfProRegular,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: SelectableText(
                  widget.staffDetail.invoice.toString(),
                  style: TextStyle(
                      color: ConstantColor.backgroundColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsBold),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text(
                  "Message",
                  style: TextStyle(
                    color: ConstantColor.headingTextColor,
                    fontSize: 16,
                    fontFamily: ConstantFonts.sfProRegular,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: SelectableText(
                  widget.staffDetail.message.toString(),
                  style: TextStyle(
                      color: ConstantColor.backgroundColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsBold),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text(
                  "Points",
                  style: TextStyle(
                    color: ConstantColor.headingTextColor,
                    fontSize: 16,
                    fontFamily: ConstantFonts.sfProRegular,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: SelectableText(
                  widget.staffDetail.points.toString(),
                  style: TextStyle(
                      color: ConstantColor.backgroundColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsBold),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text(
                  "Quote",
                  style: TextStyle(
                    color: ConstantColor.headingTextColor,
                    fontSize: 16,
                    fontFamily: ConstantFonts.sfProRegular,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: SelectableText(
                  widget.staffDetail.quote.toString(),
                  style: TextStyle(
                      color: ConstantColor.backgroundColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsBold),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text(
                  "Visit",
                  style: TextStyle(
                    color: ConstantColor.headingTextColor,
                    fontSize: 16,
                    fontFamily: ConstantFonts.sfProRegular,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: SelectableText(
                  widget.staffDetail.visit.toString(),
                  style: TextStyle(
                      color: ConstantColor.backgroundColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsBold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

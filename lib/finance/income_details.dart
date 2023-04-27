import 'package:flutter/material.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import '../util/screen_template.dart';
import 'income_model.dart';

class IncomeDetails extends StatefulWidget {
  final IncomeModel incomeDetails;

  const IncomeDetails({Key? key, required this.incomeDetails})
      : super(key: key);

  @override
  State<IncomeDetails> createState() => _IncomeDetailsState();
}

class _IncomeDetailsState extends State<IncomeDetails> {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildIncomeDetailsScreen(),
      title: 'Income Details',
    );
  }

  Widget buildIncomeDetailsScreen() {
    return Center(
      child: Column(
        children: [
          buildIncomeTable(),
        ],
      ),
    );
  }

  Widget buildIncomeTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(3),
        },
        border: TableBorder.all(
          borderRadius: BorderRadius.circular(10),
          color: ConstantColor.backgroundColor,
          width: 1.5,
        ),
        children: [
          TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade300,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Amount",
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.incomeDetails.amount.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.poppinsMedium),
                  ),
                ),
              ],
          ),
          TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade300,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Customer Name",
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.incomeDetails.customerName.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.poppinsMedium),
                  ),
                ),
              ],
          ),
          TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade300,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Entered By",
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.incomeDetails.enteredBy.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.poppinsMedium),
                  ),
                ),
              ],
          ),
          TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade300,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Entered Date",
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.incomeDetails.enteredDate.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.poppinsMedium),
                  ),
                ),
              ],
          ),
          TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade300,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Entered Time",
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.incomeDetails.enteredTime.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.poppinsMedium),
                  ),
                ),
              ],
          ),
          TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade300,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Invoice Number",
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.incomeDetails.invoiceNumber.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.poppinsMedium),
                  ),
                ),
              ],
          ),
          TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade300,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Paid Date",
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.incomeDetails.paidDate.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.poppinsMedium),
                  ),
                ),
              ],
          ),
          TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade300,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Paid Time",
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.incomeDetails.paidTime.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.poppinsMedium),
                  ),
                ),
              ],
          ),
          TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade300,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Payment Method",
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.incomeDetails.paymentMethod.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.poppinsMedium),
                  ),
                ),
              ],
          ),
          TableRow(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade300,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Product Name",
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.poppinsMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.incomeDetails.productName.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                        fontFamily: ConstantFonts.poppinsMedium),
                  ),
                ),
              ],
          ),
        ],
      ),
    );
  }
}

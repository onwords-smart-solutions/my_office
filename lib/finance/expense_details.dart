import 'package:flutter/material.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import '../util/screen_template.dart';
import 'expense_model.dart';

class ExpenseDetails extends StatefulWidget {
  final ExpenseModel expenseDetails;

  const ExpenseDetails({Key? key, required this.expenseDetails})
      : super(key: key);

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildExpenseDetailsScreen(),
      title: 'Expense Details',
    );
  }

  Widget buildExpenseDetailsScreen() {
    return Center(
      child: Column(
        children: [
          buildExpenseTable(),
        ],
      ),
    );
  }

  Widget buildExpenseTable() {
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
                      fontFamily: ConstantFonts.sfProBold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.expenseDetails.amount.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                         ),
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
                      fontFamily: ConstantFonts.sfProBold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.expenseDetails.enteredBy.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                         ),
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
                      fontFamily: ConstantFonts.sfProBold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.expenseDetails.enteredDate.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                         ),
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
                      fontFamily: ConstantFonts.sfProBold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.expenseDetails.enteredTime.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                         ),
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
                      fontFamily: ConstantFonts.sfProBold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.expenseDetails.productName.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                         ),
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
                    "Purchased Date",
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.sfProBold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.expenseDetails.purchasedDate.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                         ),
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
                    "Purchased For",
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.sfProBold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.expenseDetails.purchasedFor.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                         ),
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
                    "Purchased Time",
                    style: TextStyle(
                      color: ConstantColor.headingTextColor,
                      fontSize: 16,
                      fontFamily: ConstantFonts.sfProBold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.expenseDetails.purchasedTime.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                         ),
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
                    "Service",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: ConstantFonts.sfProBold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText(
                    widget.expenseDetails.service.toString(),
                    style: TextStyle(
                        color: ConstantColor.backgroundColor,
                        fontSize: 16,
                         ),
                  ),
                ),
              ],
          ),
        ],
      ),
    );
  }
}

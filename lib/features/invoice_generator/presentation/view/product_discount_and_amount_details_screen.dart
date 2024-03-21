import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_app_button.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_text_field.dart';
import 'package:my_office/features/invoice_generator/presentation/view/invoice_generator_preview_screen.dart';
import 'package:provider/provider.dart';
import '../provider/invoice_generator_provider.dart';

class InvoiceTypeAndDetails extends StatefulWidget {
  const InvoiceTypeAndDetails({Key? key}) : super(key: key);

  @override
  State<InvoiceTypeAndDetails> createState() => _InvoiceTypeAndDetailsState();
}

class _InvoiceTypeAndDetailsState extends State<InvoiceTypeAndDetails> {
  final formKey = GlobalKey<FormState>();

  TextEditingController discountController = TextEditingController();
  TextEditingController advancedAmountController = TextEditingController();

  bool gstNeed = false;

  double finalAmountWithoutGst = 0;
  double prPoint = 0;

  // @override
  // void dispose() {
  //   discountController.dispose();
  //   advancedAmountController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    int maxTotalAmount = 0;
    int minTotalAmount = 0;
    double discountAmount = 0;
    double obcTotal = 0;
    int discountPercentage = 0;

    final invoiceProvider = Provider.of<InvoiceGeneratorProvider>(context);
    final invoiceList = invoiceProvider.getProductDetails;

    for (var invoice in invoiceList) {
      maxTotalAmount += invoice.subTotalList;
    }

    for (var invoice in invoiceList) {
      minTotalAmount += invoice.minPrice * invoice.productQuantity;
    }
    for (var invoice in invoiceList) {
      obcTotal += invoice.obcPrice * invoice.productQuantity;
    }

    int getDiscount1;
    double getDiscount2;

    getDiscount1 = maxTotalAmount - minTotalAmount;
    getDiscount2 = (int.parse(getDiscount1.toString()) /
            int.parse(maxTotalAmount.toString())) *
        100;

    discountPercentage = double.parse(getDiscount2.toString()).toInt();

    discountAmount = int.parse(maxTotalAmount.toString()) *
        int.parse(discountPercentage.toString()) /
        100;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discount and Amount Info',
          style: TextStyle(fontSize: 22, color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).primaryColor ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: height * .9,
            // color: Colors.black26,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: height * 0.7,
                  // color: Colors.black26,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: height * .28,
                        decoration: BoxDecoration(
                          // color: Colors.blueGrey,
                          border: Border.all(
                            color:Theme.of(context).primaryColor.withOpacity(.5),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildListTile(
                              height,
                              'Max Total Amount',
                              maxTotalAmount.toString(),
                            ),
                            buildListTile(
                              height,
                              'Min Total Amount',
                              minTotalAmount.toString(),
                            ),
                            buildListTile(
                              height,
                              'Percentage',
                              discountPercentage.toString(),
                            ),
                            buildListTile(
                              height,
                              'Discount Amount',
                              discountAmount.toString(),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// DISCOUNT AMOUNT
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            height: height * .16,
                            width: width * .5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Available Discount - $discountPercentage %',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Expanded(
                                  child: CustomTextField(
                                    controller: discountController,
                                    textInputType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    hintName: 'Fill below $discountPercentage%',
                                    icon: Icon(
                                      Icons.percent,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    maxLength: 3,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Fill Percentage';
                                      } else if (value.toString().contains('.')) {
                                        return 'Enter Only Single Value';
                                      } else if (int.parse(value) >
                                          int.parse(
                                            discountPercentage.toString(),
                                          )) {
                                        return 'Enter less then $discountPercentage %';
                                      }
                                      return null;
                                    },
                                  ).textInputField(context),
                                ),
                              ],
                            ),
                          ),
                          /// NEED GST
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: height * .078,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor.withOpacity(.3),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "GST Need : ",
                                  style: TextStyle(
                                    fontSize: height * 0.019,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Checkbox(
                                  checkColor: Theme.of(context).primaryColor,
                                  value: gstNeed,
                                  onChanged: (val) {
                                    setState(() {
                                      gstNeed = val!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      /// ADVANCE AMOUNT
                      invoiceProvider.getCustomerDetails.docType ==
                              'PROFORMA_INVOICE'
                          ? Container(
                              height: height * .15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Advanced Amount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    controller: advancedAmountController,
                                    textInputType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    hintName: 'Advance',
                                    icon: Icon(
                                      Icons.money,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    maxLength: 10,
                                    // validator: (value) {
                                    //   if (value == null || value.isEmpty) {
                                    //     return 'Fill Advanced Amount';
                                    //   }
                                    //   return null;
                                    // },
                                  ).textInputField(context),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                AppButton(
                  child: Text('Next',
                    style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      discountAmount = int.parse(maxTotalAmount.toString()) *
                          int.parse(discountController.text) /
                          100;

                      finalAmountWithoutGst =
                          double.parse(maxTotalAmount.toString()) -
                              double.parse(discountAmount.toString());
                      log('$finalAmountWithoutGst');
                      log('$discountAmount');

                      prPoint =
                          (double.parse(finalAmountWithoutGst.toString()) -
                                  double.parse(obcTotal.toString())) /
                              1000;
                      log('PR POINT : ${prPoint.toString()}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InvoiceGeneratorPreviewScreen(
                            finalAmountWithoutGst: finalAmountWithoutGst,
                            advanceAmount:
                                advancedAmountController.text.isNotEmpty
                                    ? double.parse(
                                        advancedAmountController.text,
                                      ).toDouble()
                                    : 0,
                            gstNeed: gstNeed,
                            discountAmount:
                                double.parse(discountAmount.toString())
                                    .toDouble(),
                            percentage: int.parse(discountController.text),
                            prPoint: prPoint,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListTile(double height, String title, String value) {
    return SizedBox(
      height: height * .06,
      child: Center(
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
          trailing: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

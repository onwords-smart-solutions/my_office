import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:provider/provider.dart';
import '../../../Constant/colors/constant_colors.dart';
import '../models/providers.dart';
import '../widgets/button_widget.dart';
import '../widgets/textFiled_widget.dart';
import 'document_preview_screen.dart';

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

  @override
  void dispose() {
    discountController.dispose();
    advancedAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int maxTotalAmount = 0;
    int minTotalAmount = 0;
    double discountAmount = 0;
    double obcTotal = 0;
    int discountPercentage = 0;

    final invoiceProvider = Provider.of<InvoiceProvider>(context);
    final invoiceList = invoiceProvider.getProductDetails;

    for (var invoice in invoiceList) {
      maxTotalAmount += invoice.subTotalList;
    }

    for (var invoice in invoiceList) {
      minTotalAmount += invoice.minPrice * invoice.productQuantity;
    }
    for(var invoice in invoiceList){
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
        title: const Text('Discount and Amount Info'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: ConstantColor.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
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
                            border:
                                Border.all(color: Colors.black.withOpacity(0.3), width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildListTile(height, 'Max Total Amount',
                                maxTotalAmount.toString()),
                            buildListTile(height, 'Min Total Amount',
                                minTotalAmount.toString()),
                            buildListTile(height, 'Percentage',
                                discountPercentage.toString()),
                            buildListTile(height, 'Discount Amount',
                                discountAmount.toString()),
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
                            width: width*.5,
                            decoration: BoxDecoration(
                              // color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text('Available Discount - $discountPercentage %',
                                style: TextStyle(
                                  fontFamily: ConstantFonts.poppinsRegular,
                                  fontWeight: FontWeight.w600,
                                  color: ConstantColor.backgroundColor,
                                  fontSize: 14
                                ),),
                                const SizedBox(height: 15),
                                TextFiledWidget(
                                  controller: discountController,
                                  textInputType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  hintName:
                                  'Fill below $discountPercentage%',
                                  icon: const Icon(Icons.percent, color: Colors.black,),
                                  maxLength: 3,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Fill Percentage';
                                    } else if (value.toString().contains('.')) {
                                      return 'Enter Only Single Value';
                                    } else if (int.parse(value) >
                                        int.parse(discountPercentage.toString())) {
                                      return 'Enter less then $discountPercentage %';
                                    }
                                    return null;
                                  },
                                ).textInputFiled(),
                              ],
                            ),
                          ),
                          /// NEED GST
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: height * .078,

                            decoration: BoxDecoration(
                              // color: Colors.blueGrey,
                              border: Border.all(color: Colors.black.withOpacity(0.3), width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "GST Need : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * 0.020,
                                      color: Colors.black),
                                ),
                                Checkbox(
                                    value: gstNeed,
                                    onChanged: (val) {
                                      setState(() {
                                        gstNeed = val!;
                                      });
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),

                      /// ADVANCE AMOUNT
                      invoiceProvider.getCustomerDetails.docType != 'QUOTATION'
                          ? Container(
                              height: height * .15,
                              decoration: BoxDecoration(
                                  // color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Text('Advanced Amount', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, fontFamily: ConstantFonts.poppinsRegular),),
                                  const SizedBox(height: 10),
                                  TextFiledWidget(
                                    controller: advancedAmountController,
                                    textInputType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    hintName: 'Advance',
                                    icon: const Icon(Icons.money, color: Colors.black),
                                    maxLength: 10,
                                    // validator: (value) {
                                    //   if (value == null || value.isEmpty) {
                                    //     return 'Fill Advanced Amount';
                                    //   }
                                    //   return null;
                                    // },
                                  ).textInputFiled(),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                Button('Next', () {
                  if (formKey.currentState!.validate()) {
                    discountAmount = int.parse(maxTotalAmount.toString()) *
                        int.parse(discountController.text) /
                        100;

                    finalAmountWithoutGst =
                        double.parse(maxTotalAmount.toString()) -
                            double.parse(discountAmount.toString());
                    log('$finalAmountWithoutGst');
                    log('$discountAmount');


                    prPoint = (double.parse(finalAmountWithoutGst.toString()) -
                        double.parse(obcTotal.toString())) /
                        1000;
                    log('PR POINT : ${prPoint.toString()}');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => InvoicePreviewScreen(
                                  finalAmountWithoutGst: finalAmountWithoutGst,
                                  advanceAmount:
                                      advancedAmountController.text.isNotEmpty
                                          ? double.parse(
                                                  advancedAmountController.text)
                                              .toDouble()
                                          : 0,
                                  gstNeed: gstNeed,
                                  discountAmount:
                                      double.parse(discountAmount.toString())
                                          .toDouble(), percentage: int.parse(discountController.text), prPoint: prPoint,
                                ),),);
                  }
                }).button(),
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

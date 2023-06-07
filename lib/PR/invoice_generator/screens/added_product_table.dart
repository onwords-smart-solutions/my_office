import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:provider/provider.dart';
import '../models/providers.dart';
import '../models/table_list.dart';
import '../widgets/button_widget.dart';
import 'add_products.dart';
import 'dicount_and_amount.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    final invoiceProvider = Provider.of<InvoiceProvider>(context);
    final invoiceList = invoiceProvider.getProductDetails;

    int total = 0;
    for (var invoice in invoiceList) {
      total += invoice.subTotalList;
    }

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Table'),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          /// TABLE
          SizedBox(
            child: Column(
              children: [
                /// TABLE HEAD
                Neumorphic(
                  margin: const EdgeInsets.only(bottom: 5),
                  style: NeumorphicStyle(
                    depth: 1,
                    boxShape: NeumorphicBoxShape.roundRect(
                      const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: height * .08,
                    width: width * 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tableHeading(width, 'Items', width * .0005, true),
                        tableHeading(width, 'Qty', width * .0003, true),
                        tableHeading(width, 'Unit Price', width * .0006, true),
                        tableHeading(width, 'Total', width * .0005, false),
                      ],
                    ),
                  ),
                ),

                /// TABLE CONTENT
                Neumorphic(
                  style: NeumorphicStyle(
                    depth: 2,
                    boxShape: NeumorphicBoxShape.roundRect(
                      const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                    ),
                  ),
                  child: Container(
                      height: height * .55,
                      width: width * 1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemCount: invoiceList.length,
                          itemBuilder: (BuildContext context, index) {
                            final data = [
                              invoiceList[index].productName,
                              invoiceList[index].productQuantity.toString(),
                              invoiceList[index].productPrice.toString(),
                              invoiceList[index].subTotalList.toString(),
                            ];
                            return GestureDetector(
                              onTap: () {
                                _showDialog(context, index, invoiceList);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Table(
                                    // border: TableBorder.all(color: Colors.black),

                                    children: [
                                      createTableRow(data),
                                    ]),
                              ),
                            );
                          })),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10, left: width * .4),
                  child: AutoSizeText(
                    'Sub Total : $total',
                    maxFontSize: 25,
                    minFontSize: 15,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    children: [
                     const SizedBox(width: 20),
                      Icon(Icons.info, color: Colors.black.withOpacity(0.4)),
                      const SizedBox(width: 5),
                      Text(
                        'Tap on the product to delete..',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: ConstantFonts.poppinsRegular,
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          /// NEXT BUTTON
          Row(
            children: [
              const Spacer(),
              SizedBox(
                height: 50,
                width: 250,
                child: Provider.of<InvoiceProvider>(context)
                    .getProductDetails
                    .isNotEmpty
                    ? Button('Next', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const InvoiceTypeAndDetails()));
                }).button()
                    : const SizedBox(),
              ),
             const Spacer(),
              FloatingActionButton(
                backgroundColor: ConstantColor.backgroundColor,
                child: const Center(
                  child: Icon(Icons.add),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProductDetails()));
                },
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget tableHeading(
      double width, String title, double widthVal, bool isTrue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: width * widthVal,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: ConstantFonts.poppinsRegular,
                  fontSize: 16),
            ),
          ),
        ),
        isTrue
            ? VerticalDivider(
                color: Colors.black.withOpacity(0.4),
                endIndent: 23,
                indent: 23,
                thickness: 3,
              )
            : const SizedBox(),
      ],
    );
  }

  TableRow createTableRow(List<String> cells, {bool isHeader = false}) =>
      TableRow(
        children: cells.map(
          (cell) {
            final style = TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.w600,
            );
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  cell,
                  style: style,
                ),
              ),
            );
          },
        ).toList(),
      );

  _showDialog(
      BuildContext context, int index, List<ListOfTable> productDetailsModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: CupertinoAlertDialog(
              title: Text(
                "Delete",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontFamily: ConstantFonts.poppinsRegular,
                fontSize: 18
                ),
              ),
              content: Material(
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    'Do you want to delete this product?',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: ConstantFonts.poppinsRegular,
                        fontSize: 16),
                  ),
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    "Delete",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                        fontFamily: ConstantFonts.poppinsRegular),
                  ),
                  onPressed: () async {
                    Provider.of<InvoiceProvider>(context, listen: false)
                        .deleteProduct(productDetailsModel[index].productName);
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: ConstantFonts.poppinsRegular),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_app_button.dart';
import 'package:my_office/features/invoice_generator/presentation/provider/invoice_generator_provider.dart';
import 'package:my_office/features/invoice_generator/presentation/view/product_details_screen.dart';
import 'package:my_office/features/invoice_generator/presentation/view/product_discount_and_amount_details_screen.dart';
import 'package:my_office/features/invoice_generator/utils/list_of_table_utils.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    final invoiceProvider = Provider.of<InvoiceGeneratorProvider>(context);
    final invoiceList = invoiceProvider.getProductDetails;

    int total = 0;
    for (var invoice in invoiceList) {
      total += invoice.subTotalList;
    }

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Table',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, ),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: height * .08,
                  width: width * 1,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).primaryColor.withOpacity(.1),
                  ),
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

                /// TABLE CONTENT
                Container(
                  height: height * .55,
                  width: width * 1,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor.withOpacity(.1),
                  ),
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10, left: width * .4),
                  child: AutoSizeText(
                    'Sub Total : $total',
                    maxFontSize: 25,
                    minFontSize: 15,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Icon(Icons.info, color: Theme.of(context).primaryColor.withOpacity(.5)),
                      const SizedBox(width: 5),
                      Text(
                        'Tap on the product to delete..',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).primaryColor.withOpacity(.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// NEXT BUTTON
          Row(
            children: [
              const Spacer(),
              SizedBox(
                height: 50,
                width: 200,
                child: Provider.of<InvoiceGeneratorProvider>(context)
                        .getProductDetails
                        .isNotEmpty
                    ? AppButton(
                        child: Text('Next', style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InvoiceTypeAndDetails(),
                            ),
                          );
                        },
                      )
                    : const SizedBox(),
              ),
              const Spacer(),
              FloatingActionButton(
                backgroundColor: Colors.deepPurple.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Icon(Icons.add, color: Theme.of(context).primaryColor,),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProductDetails()),
                  );
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
    double width,
    String title,
    double widthVal,
    bool isTrue,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: width * widthVal,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ),
        isTrue
            ? VerticalDivider(
                color: Colors.black.withOpacity(0.4),
                endIndent: 23,
                indent: 23,
                thickness: 2,
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
              fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
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
    BuildContext context,
    int index,
    List<ListOfTable> productDetailsModel,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: CupertinoAlertDialog(
                content: const Material(
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      'Do you want to delete this product?',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () async {
                      Provider.of<InvoiceGeneratorProvider>(context,
                              listen: false,
                      )
                          .deleteProduct(
                        productDetailsModel[index].productName,
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

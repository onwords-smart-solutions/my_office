/////BACKUP CODE//////
import 'dart:developer';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:my_office/PR/invoice/model/customer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../products/point_calculations.dart';
import '../provider_page.dart';

import 'preview_Screen.dart';

class AddIterm extends StatefulWidget {
  const AddIterm({Key? key}) : super(key: key);

  @override
  State<AddIterm> createState() => _AddItermState();
}

class _AddItermState extends State<AddIterm> {
  final ref = FirebaseDatabase.instance.ref();

  final date = DateTime.now();

  final SingleValueDropDownController itermNameController =
      SingleValueDropDownController();
  TextEditingController itermNameController2 = TextEditingController();

  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController vatController = TextEditingController();
  TextEditingController fileName = TextEditingController();
  TextEditingController quotNo = TextEditingController();
  TextEditingController labAndInstall = TextEditingController();
  TextEditingController advancePaid = TextEditingController();
  TextEditingController discountController = TextEditingController();

  List productName = [];
  List productPrice = [];
  List productQuantity = [];
  List productVat = [];

  late SharedPreferences logData;

  String dropdownValue = 'QUOTATION';
  String category = 'GA';

  int advanceAmt = 0;
  int labCharge = 0;
  int discountAmount = 0;

  String? maxPrice;
  String? minPrice;
  String? obcPrice;
  List minPriceList = [];
  List obcPriceList = [];

  int? maxTotal = 0;
  int? minTotal = 0;
  int? obcTotal = 0;
  int? discount = 0;
  int? maximumDiscount = 0;
  double? percentage = 0;
  double? discountedAmount = 0;
  double? finalAmount = 0;

  double subTotal = 0.0;

  bool gstNeed = false;
  bool labNeed = false;
  bool discountNeed = false;

  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<DropDownValueModel> productList = [];
  List<TableList> listOfProductDetails = [];

  bool isTextFiled = false;

  var setProdoct;

  Future<void> getProducts() async {
    int count = 1;
    ref.child('inventory_management').once().then((value) {
      for (var a in value.snapshot.children) {
        // print(a.key);
        setState(() {
          setProdoct = a.value;
          productList
              .add(DropDownValueModel(name: setProdoct['name'], value: count));
        });
        // print(productList);
        setState(() {
          count++;
        });
      }
    });
  }

  var setVal;

  String? selectedVal;

  Future<void> getProductsDetails() async {
    ref.child('inventory_management').once().then((value) {
      for (var a in value.snapshot.children) {
        final x = a.value as Map<Object?, Object?>;
        if (x['name'].toString().toUpperCase() ==
            selectedVal.toString().toUpperCase()) {
          // print(a.value);
          setVal = a.value;
          setState(() {
            priceController.text = setVal['max_price'];
            maxPrice = setVal['max_price'];
            minPrice = setVal['min_price'];
            obcPrice = setVal['obc'];
          });
        }
      }
    });
  }

  bool isPressed = false;

  @override
  void initState() {
    itermNameController;
    itermNameController2;
    priceController;
    quantityController;
    vatController;
    fileName;
    quotNo;
    labAndInstall;
    getProducts();
    advancePaid;
    discountController;
    super.initState();
  }

  @override
  void dispose() {
    itermNameController.dispose();
    itermNameController2.dispose();
    priceController.dispose();
    quantityController.dispose();
    vatController.dispose();
    fileName.dispose();
    quotNo.dispose();
    labAndInstall.dispose();
    advancePaid.dispose();
    discountController.dispose();
    super.dispose();
  }

  final _form = GlobalKey<FormState>();

  bool isDone = false;

  void changIsDone(bool value) {
    setState(() {
      isDone = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<TaskData>(builder: (context, taskData, child) {
      // print("taskData.tasks ${taskData.tasks.length}");
      final task =
          taskData.tasks.length == 2 ? taskData.tasks[1] : taskData.tasks[0];
      // final val = taskData.subTotalValue;
      // if(val.isEmpty){
      //   // print("aas-swipe");
      // }else{
      //   subTotal = val.map((e) => e.quantity*e.amount).reduce((value, element) => value + element);
      // }
      // final netTotal = val.map((item) => item.amount * item.quantity).reduce((item1, item2) => item1 + item2);

      return WillPopScope(
        onWillPop: () async {
          setState(() {
            if (isDone) {
              isDone = false;
            } else {
              Navigator.pop(context);
            }
          });
          return isDone ? true : false;
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: const Color(0xffDDE6E8),
            elevation: 0,
            title: Text(
              "Add Products",
              style: TextStyle(
                  fontFamily: 'Nexa',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: height * 0.018),
            ),
            centerTitle: true,
            leading: GestureDetector(
              child: Image.asset(
                'assets/back arrow.png',
                scale: 2.3,
                color: const Color(0xff00bcd4),
              ),
              onTap: () {
                setState(() {
                  if (isDone == true) {
                    isDone = false;
                  } else {
                    Navigator.pop(context);
                  }
                });
              },
            ),
          ),
          backgroundColor: const Color(0xffDDE6E8),
          body: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    topContent(height, width),

                    ///CUSTOMER DETAILS
                    buildCustomerDetails(width, height, task),
                    /// Add Button, Table Headings,Product Details, Next Button
                    SizedBox(
                      height: isDone == false ? height * 0.8 : height * 0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            /// Add Button
                            addButton(width, height, context),

                            ///Table Headings
                            tableHeading(width, height),

                            /// Product Details
                            tableContent(width, height),

                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (listOfProductDetails.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('Please select product'),
                                      duration: Duration(seconds: 1),
                                    ));
                                  } else {
                                    _showDialog(context, changIsDone);
                                  }
                                });
                              },
                              child: buildNeumorphic(
                                width,
                                height,
                                const SizedBox(
                                  width: 150,
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      'Next',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: isDone ? height * 0.8 : height * 0,
                      // color: Colors.blueAccent,
                      child: Column(
                        children: [
                          ///Get Points Button
                          // getPointButton(width, height),

                          ///AMOUNT DETAILS
                          amountDetails(width, height),

                          /// DOCUMENT DETAILS
                          pdfDetails(width, height),

                          buildNeumorphic(
                              width,
                              height,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Give Discount : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.012,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: width * 0.40,
                                      child: TextFormField(
                                        textInputAction: TextInputAction.done,
                                        onChanged: (val) {
                                          if (val.isNotEmpty) {
                                            if (mounted) {
                                              setState(() {
                                                discountAmount = int.parse(val);
                                              });
                                            }
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter quantity';
                                          } else if (value
                                              .toString()
                                              .contains('.')) {
                                            return 'Enter Single Value';
                                          } else if (int.parse(value) >
                                              int.parse(
                                                  maximumDiscount.toString())) {
                                            return 'Enter less then $maximumDiscount % ';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                'Enter below ${maximumDiscount.toString()} %'),
                                        controller: discountController,
                                      ),
                                    ),
                                  ],
                                ),
                              )),

                          ///NEXT BUTTON
                          nextButton(context, width, height),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget nextButton(BuildContext context, double width, double height) {
    return Listener(
      onPointerUp: (_) => setState(() {
        isPressed = false;
      }),
      onPointerDown: (_) => setState(() {
        isPressed = true;
      }),
      child: GestureDetector(
        onTap: () {
          if (_form.currentState!.validate()) {
            discountedAmount = int.parse(maxTotal.toString()) *
                int.parse(discountController.text) /
                100;
            // print(discountedAmount);
            finalAmount = double.parse(maxTotal.toString()) -
                double.parse(discountedAmount.toString());

            // prPoint = (double.parse(finalAmount.toString()) -
            //     double.parse(obcTotal.toString())) /
            //     1000;

            // print(prPoint);
            // prPoint = double.parse(prPoint!.toStringAsFixed(3));
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => PointView(
            //           points: prPoint.toString(),
            //         )));
            // discountController.clear();
            // itermNameController.clearDropDown();
            // quantityController.clear();
            // listOfProductDetails.clear();
            // maxTotal = 0;
            // minTotal = 0;
            // discount = 0;
            // percentage = 0;
            // minPriceList.clear();
            // showTable = false;
            // getPointsStatus = false;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewScreen(
                  docType: dropdownValue,
                  category: category,
                  advanceAmt: advanceAmt,
                  // labAndInstall: labCharge,
                  gstValue: gstNeed,
                  discountAmount: discountedAmount!.toInt(),
                  // discountNeed: discountNeed,
                  productDetails: listOfProductDetails,
                  finalAmount: finalAmount!.toInt(),
                  listAmount: maxTotal!.toInt(),
                  // labValue: labNeed,
                ),
              ),
            ).then((value) {
              setState(() {
                // labAndInstall.clear();
                advancePaid.clear();
                advanceAmt = 0;
                // labCharge = 0;
              });
            });
          }
        },
        child: Neumorphic(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(top: 20),
          style: NeumorphicStyle(
            depth: isPressed ? 0 : 3,
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(20),
            ),
          ),
          child: SizedBox(
            width: width * 0.58,
            height: height * 0.07,
            // decoration: BoxDecoration(
            //   color: const Color(0xff00bcd4),
            //   borderRadius: BorderRadius.circular(15),
            //   boxShadow: [
            //     BoxShadow(
            //         color: Colors.black.withOpacity(0.3),
            //         offset: const Offset(8, 8),
            //         blurRadius: 10,
            //         spreadRadius: 0)
            //   ],
            // ),
            child: Center(
              child: Text(
                "Next",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: height * 0.025,
                    fontFamily: 'Nexa',
                    color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget pdfDetails(double width, double height) {
    return buildNeumorphic(
      width,
      height,
      Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        height: height * 0.23,
        width: width * 0.95,
        // decoration: BoxDecoration(
        //   color: Colors.black.withOpacity(0.1),
        //   borderRadius: BorderRadius.circular(20),
        // ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Doc-Type",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.012,
                        fontFamily: 'Nexa',
                        color: Colors.black),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    // underline: Container(
                    //   height: 0.5,
                    //   color: Colors.black,
                    // ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['QUOTATION', 'PROFORMA_INVOICE', 'INVOICE']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.012,
                        fontFamily: 'Nexa',
                        color: Colors.black),
                  ),
                  DropdownButton<String>(
                    value: category,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue!;
                      });
                    },
                    items: <String>[
                      'GA',
                      'SH',
                      'IT',
                      'DL',
                      'SS',
                      'WTA',
                      'AG',
                      'VC',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "GST Need : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: height * 0.012,
                        fontFamily: 'Nexa',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  dropdownValue == "INVOICE"|| dropdownValue == "PROFORMA_INVOICE"
                      ? Text(
                          "Advance Amount",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: height * 0.012,
                              fontFamily: 'Nexa',
                              color: Colors.black),
                        )
                      : const Text(""),
                  dropdownValue == "INVOICE" || dropdownValue == "PROFORMA_INVOICE"
                      ? SizedBox(
                          width: width * 0.40,
                          child: TextFormField(
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                setState(() {
                                  advanceAmt = int.parse(val);
                                });
                              }
                            },
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: height * 0.012,
                              fontFamily: 'Avenir',
                            ),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: ' Advance Paid',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: 'Nexa',
                              ),
                            ),
                            controller: advancePaid,
                          ),
                        )
                      : const Text(""),
                ],
              ),

              SizedBox(
                height: height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget amountDetails(double width, double height) {
    return buildNeumorphic(
        width,
        height,
        SizedBox(
          height: height * 0.20,
          width: width * 0.95,
          child: Column(
            children: [
              buildListTile(height, 'Max Total Amount', maxTotal.toString()),
              buildListTile(height, 'Min Total Amount', minTotal.toString()),
              buildListTile(height, 'Percentage', maximumDiscount.toString()),
              buildListTile(height, 'Discount Amount', '${  int.parse(maxTotal.toString()) *
                  int.parse(maximumDiscount.toString()) / 100}'),

            ],
          ),
        ));
  }

  // Widget getPointButton(double width, double height) {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         var sum = 0.0;
  //         for (var i = 0; i < listOfProductDetails.length; i++) {
  //           sum += listOfProductDetails[i].subTotalList;
  //           maxTotal = sum.toInt();
  //         }
  //
  //         var sum1 = 0.0;
  //         for (var i = 0; i < minPriceList.length; i++) {
  //           sum1 += minPriceList[i];
  //           minTotal = sum1.toInt();
  //         }
  //
  //         var sum2 = 0.0;
  //         for (var i = 0; i < obcPriceList.length; i++) {
  //           sum2 += obcPriceList[i];
  //           obcTotal = sum2.toInt();
  //         }
  //
  //         discount =
  //             int.parse(maxTotal.toString()) - int.parse(minTotal.toString());
  //
  //         // print('$maxTotal , $discount $obcTotal');
  //         percentage =
  //             int.parse(maxTotal.toString()) / int.parse(discount.toString());
  //
  //         maximumDiscount = double.parse(percentage.toString()).toInt();
  //         //     getPointsStatus = true;
  //       });
  //     },
  //     child: buildNeumorphic(
  //       width,
  //       height,
  //       SizedBox(
  //           width: width * 1,
  //           height: height * 0.08,
  //           child: Center(
  //               child: Text(
  //             'Get Price Details',
  //             style: TextStyle(
  //                 fontWeight: FontWeight.w900, fontSize: height * 0.025),
  //           ),),),
  //     ),
  //   );
  // }

  Widget tableContent(double width, double height) {
    return buildNeumorphic(
      width,
      height,
      SizedBox(
        height: height * 0.38,
        width: width * 0.95,
        // decoration: BoxDecoration(
        //   color: Colors.black.withOpacity(0.1),
        //   borderRadius: const BorderRadius.only(
        //       bottomLeft: Radius.circular(20.0),
        //       bottomRight: Radius.circular(20.0)),
        // ),
        child: ListView.builder(
          // shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemCount: listOfProductDetails.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                showDeleteDialog(context, index);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Table(
                  // border: TableBorder.all(),
                  children: [
                    buildRow([
                      listOfProductDetails[index].productName,
                      listOfProductDetails[index].productQuantity.toString(),
                      listOfProductDetails[index].productPrice,
                      listOfProductDetails[index].subTotalList.toString(),
                    ]),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget tableHeading(double width, double height) {
    return buildNeumorphic(
      width,
      height,
      Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        width: width * .95,
        height: height * 0.08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: width * 0.15,
              child: Text(
                'Name',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: height * 0.012,
                ),
              ),
            ),
            VerticalDivider(
              color: Colors.black.withOpacity(0.4),
              endIndent: 25,
              indent: 25,
              thickness: 3,
            ),
            SizedBox(
              width: width * 0.16,
              child: Text(
                'Quantity',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: height * 0.012,
                ),
              ),
            ),
            VerticalDivider(
              color: Colors.black.withOpacity(0.4),
              endIndent: 25,
              indent: 25,
              thickness: 3,
            ),
            SizedBox(
                width: width * 0.12,
                child: Text(
                  'Rate',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: height * 0.012,
                  ),
                )),
            VerticalDivider(
              color: Colors.black.withOpacity(0.4),
              endIndent: 25,
              indent: 25,
              thickness: 3,
            ),
            SizedBox(
                width: width * 0.12,
                child: Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: height * 0.012,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget addButton(double width, double height, BuildContext context) {
    return buildNeumorphic(
      width,
      height,
      SizedBox(
        width: width * 0.95,
        height: height * 0.08,
        // decoration: BoxDecoration(
        //   color: Colors.black.withOpacity(0.1),
        //   borderRadius: BorderRadius.circular(20),
        // ),
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Add Item",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.012,
                  fontFamily: 'Nexa',
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    showAnotherAlertDialog(context, height, width);
                  });
                },
                icon: Image.asset(
                  'assets/add.png',
                  color: const Color(0xff00bcd4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomerDetails(double width, double height, Customer task) {
    return buildNeumorphic(
      width,
      height,
      Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        width: width * 0.95,
        height: height * 0.05,
        // decoration: BoxDecoration(
        //     color: Colors.black.withOpacity(0.1),
        //     borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'To :   ${task.name}',
              // style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: height * 0.012,
              //     fontFamily: 'Avenir',
              //     color: Colors.black),
            ),
            // IconButton(
            //     onPressed: () {},
            //     icon: Image.asset(
            //       'assets/etit1.png',
            //       scale: 3.5,
            //     ))
          ],
        ),
      ),
    );
  }

  Widget topContent(double height, double width) {
    return Column(
      children: [
        // Text(
        //   'Date : ${DateFormat("dd.MM.yyyy").format(date)}',
        //   style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //       fontSize: height * 0.012,
        //       fontFamily: 'Nexa',
        //       color: Colors.black),
        // ),
        SizedBox(
          height: height * 0.01,
        ),
        // Container(
        //   width: width * 1,
        //   height: height * 0.04,
        //   decoration: BoxDecoration(
        //       color: const Color(0xff00bcd4),
        //       borderRadius: BorderRadius.circular(10)),
        //   child: Center(
        //     child: Text(
        //       'Products',
        //       style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           fontSize: height * 0.019,
        //           fontFamily: 'Nexa',
        //           color: Colors.white),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget buildListTile(double height, String title, String value) {
    return SizedBox(
      height: height * 0.04,
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

  Widget buildNeumorphic(double width, double height, Widget widget) {
    return Neumorphic(
      margin: const EdgeInsets.symmetric(vertical: 10),
      style: NeumorphicStyle(
        depth: 3,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(20),
        ),
      ),
      child: widget,
    );
  }

  TableRow buildRow(List<String> cells, {bool isHeader = false}) => TableRow(
        children: cells.map(
          (cell) {
            final style = TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            );
            return Padding(
              padding: const EdgeInsets.all(10),
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

  showDeleteDialog(BuildContext context, int index) {
    Widget okButton = TextButton(
      child: const Text(" ok "),
      onPressed: () {
        setState(() {
          listOfProductDetails.removeAt(index);
          discountController.clear();
          minPriceList.removeAt(index);
          obcPriceList.removeAt(index);

          // maxTotal = 0;
          // minTotal = 0;
          // obcTotal = 0;
          // discountAmount = 0;
          // percentage = 0;
          // maximumDiscount = 0;
          //
          //

          // itermNameController.clearDropDown();
          // quantityController.clear();
          // listOfProductDetails.clear();

          // productName.removeAt(index);
          // productQuantity.removeAt(index);
          // productVat.removeAt(index);
          // productPrice.removeAt(index);
          // Provider.of<TaskData>(context, listen: false).deleteTask(index);
          // Provider.of<TaskData>(context, listen: false).clearSubtotal(index);
          Navigator.pop(context, false);
        });
      },
    );
    Widget cancelButton = TextButton(
      child: const Text(" Cancel "),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: const Text("Do you want to delete ?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAnotherAlertDialog(BuildContext context, height, width) {
    // Create button
    Widget okButton = TextButton(
      child: const Text(" ok "),
      onPressed: () {
        if (formKey.currentState!.validate()) {
          // if (!mounted) return;
          setState(() {
            minPriceList.add(int.parse(quantityController.text) *
                int.parse(minPrice.toString()));

            obcPriceList.add(int.parse(quantityController.text) *
                int.parse(obcPrice.toString()));

            // print(minPriceList);
            // print(obcPriceList);
            final index = listOfProductDetails.indexWhere((element) =>
                element.productName == itermNameController.dropDownValue?.name);
            if (index > -1) {
              listOfProductDetails[index].productQuantity +=
                  int.parse(quantityController.text);
              listOfProductDetails[index].subTotalList +=
                  int.parse(listOfProductDetails[index].productPrice) *
                      int.parse(quantityController.text);
            } else {
              final product = TableList(
                  productName: itermNameController.dropDownValue!.name,
                  productQuantity: int.parse(quantityController.text),
                  productPrice: maxPrice.toString(),
                  subTotalList: int.parse(quantityController.text) *
                      int.parse(maxPrice.toString()));
              listOfProductDetails.add(product);
            }
          });
          //   ///
          //   isTextFiled
          //       ? productName.add(itermNameController2.text)
          //       : productName.add(itermNameController.dropDownValue?.name);
          //   productPrice.add(priceController.text);
          //   productQuantity.add(quantityController.text);
          //   productVat.add(vatController.text);
          // });
          // Provider.of<TaskData>(context, listen: false).addInvoiceListData(
          //     isTextFiled
          //         ? itermNameController2.text.toString()
          //         : itermNameController.dropDownValue!.name.toString(),
          //     int.parse(quantityController.text),
          //     double.parse(priceController.text));
          // Provider.of<TaskData>(context, listen: false).addSubTotal(
          //   int.parse(quantityController.text),
          //   double.parse(priceController.text),
          // );
          Navigator.pop(context, false);
          itermNameController.clearDropDown();
          itermNameController2.clear();
          priceController.clear();
          quantityController.clear();
          vatController.clear();
        }
      },
    );
    Widget cancelButton = TextButton(
      child: const Text(" Cancel "),
      onPressed: () {
        Navigator.pop(context, false);
        itermNameController.dropDownValue?.name.isEmpty;
        priceController.clear();
        quantityController.clear();
        itermNameController2.clear();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: const Text(
        "  Data entry ",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Form(
            key: formKey,
            child: SizedBox(
              height: height * 0.40,
              width: width * 1.0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // IconButton(
                    //     onPressed: () {
                    //       setState(() {
                    //         isTextFiled = !isTextFiled;
                    //         // print(isTextFiled);
                    //       });
                    //     }, icon: Icon(isTextFiled ? Icons.arrow_drop_down_sharp : Icons.text_fields)),
                    SizedBox(
                        width: width * 0.6,
                        child:
                            // isTextFiled != true
                            //     ?
                            DropDownTextField(
                          // initialValue: "name4",
                          controller: itermNameController,
                          clearOption: true,
                          enableSearch: true,
                          dropDownIconProperty: IconProperty(
                              icon: Icons.arrow_drop_down, color: Colors.black),
                          clearIconProperty: IconProperty(
                              color: Colors.black, icon: Icons.clear),
                          // dropdownColor: Colors.orange,

                          searchDecoration:
                              const InputDecoration(hintText: "Select Product"),
                          validator: (value) {
                            if (value == null) {
                              return "Required Product Name";
                            } else {
                              return null;
                            }
                          },
                          dropDownItemCount: 6,
                          dropDownList: productList,

                          onChanged: (val) {
                            // print(itermNameController.dropDownValue?.name);
                            selectedVal =
                                itermNameController.dropDownValue?.name;
                            getProductsDetails();
                          },
                        )
                        //     : Container(
                        //   padding: const EdgeInsets.only(top: 20.0),
                        //    child: TextFormField(
                        //     textInputAction: TextInputAction.next,
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return 'Please enter product name';
                        //       }
                        //       return null;
                        //     },
                        //     keyboardType: TextInputType.name,
                        //     decoration: const InputDecoration(
                        //         hintText: 'Product Name'),
                        //     controller: itermNameController2,
                        //   ),
                        // ),
                        ),

                    /// PRICE
                    Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        enabled: false,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: 'Amount Of Product'),
                        controller: priceController,
                      ),
                    ),

                    ///QUANTITY
                    Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter quantity';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: 'Quantity of Product'),
                        controller: quantityController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: alert,
          );
        });
      },
    );
  }

  _showDialog(BuildContext context, Function(bool) onclick) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: CupertinoAlertDialog(
              title: const Text("Be sure to add all items. "),
              // content: const Text(
              //     ""
              //         // "If you click ok, you cannot change that list."
              // ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("Yes"),
                  onPressed: () {
                    setState(() {
                      var sum = 0.0;
                      for (var i = 0; i < listOfProductDetails.length; i++) {
                        sum += listOfProductDetails[i].subTotalList;
                      }

                      var sum1 = 0.0;
                      for (var i = 0; i < minPriceList.length; i++) {
                        sum1 += minPriceList[i];
                      }

                      var sum2 = 0.0;
                      for (var i = 0; i < obcPriceList.length; i++) {
                        sum2 += obcPriceList[i];
                      }
                      obcTotal = sum2.toInt();
                      minTotal = sum1.toInt();
                      maxTotal = sum.toInt();

                      discount = int.parse(maxTotal.toString()) -
                          int.parse(minTotal.toString());

                      // print('$maxTotal , $discount $obcTotal');
                      percentage = (int.parse(discount.toString()) /
                              int.parse(maxTotal.toString())) *
                          100;
                      // print(percentage);

                      maximumDiscount =
                          double.parse(percentage.toString()).toInt();

                      onclick(true);
                      Navigator.of(context).pop();
                    });
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("No"),
                  onPressed: () {
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

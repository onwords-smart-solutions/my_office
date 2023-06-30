import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constant/fonts/constant_font.dart';

class PointCalculationsScreen extends StatefulWidget {
  const PointCalculationsScreen({Key? key}) : super(key: key);

  @override
  State<PointCalculationsScreen> createState() =>
      _PointCalculationsScreenState();
}

class _PointCalculationsScreenState extends State<PointCalculationsScreen> {
  final ref = FirebaseDatabase.instance.ref();

  final SingleValueDropDownController itermNameController =
      SingleValueDropDownController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController percentageController = TextEditingController();

  List<DropDownValueModel> productList = [];

  List minPriceList = [];
  List obcPriceList = [];

  List<TableList> listOfProductDetails = [];
  var setProductName;
  var setVal;

  String? selectedVal;
  String? maxPrice;
  String? minPrice;
  String? obcPrice;

  int? maxTotal = 0;
  int? minTotal = 0;
  int? obcTotal = 0;
  int? discount = 0;
  int? maximumDiscount = 0;

  double? prPoint = 0;

  double? percentage = 0;
  double? discountedAmount = 0;
  double? finalAmount = 0;

  Future<void> getProducts() async {
    int count = 1;
    ref.child('inventory_management').once().then((value) {
      for (var a in value.snapshot.children) {
        // print(a.key);
        if (!mounted) return;
        setState(() {
          setProductName = a.value;
          productList.add(
              DropDownValueModel(name: setProductName['name'], value: count));
        });
        // print(productList);
        if (!mounted) return;
        setState(() {
          count++;
        });
      }
    });
  }

  Future<void> getProductsDetails() async {
    ref.child('inventory_management').once().then((value) {
      for (var a in value.snapshot.children) {
        // print(a.value);
        final x = a.value as Map<Object?, Object?>;
        if (x['name'].toString().toUpperCase() ==
            selectedVal.toString().toUpperCase()) {
          // if (a.value.toString().contains(selectedVal.toString())) {
          //   print(a.value);
          setVal = a.value;

          setState(() {
            maxPrice = setVal['max_price'];
            minPrice = setVal['min_price'];
            obcPrice = setVal['obc'];
          });
        }
      }
    });
  }

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  void dispose() {
    quantityController.dispose();
    percentageController.dispose();
    super.dispose();
  }

  final _form = GlobalKey<FormState>();

  bool getPointsStatus = false;
  bool showTable = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Points Calculations',
          style: TextStyle(color: Colors.black,
          fontFamily: ConstantFonts.sfProBold,
            fontSize: 23,
          ),
        ),
        backgroundColor: const Color(0xffEEEEEE),
        elevation: 0,
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedContainer(
                padding: const EdgeInsets.all(10),
                // color: Colors.black,
                duration: const Duration(milliseconds: 500),
                height: getPointsStatus == false ? height * 1 : height * 0.0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.05,
                      ),

                      ///Drop Down
                      buildContainer(
                        height,
                        width,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            width: width * 1,
                            height: height * 0.08,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: DropDownTextField(
                                  textStyle: TextStyle(
                                    fontFamily: ConstantFonts.sfProMedium,
                                    fontSize: 17,
                                  ),
                                  listTextStyle: TextStyle(
                                    fontFamily: ConstantFonts.sfProMedium,
                                    fontSize: 17,
                                  ),
                                  controller: itermNameController,
                                  clearOption: true,
                                  enableSearch: true,

                                  dropDownIconProperty: IconProperty(
                                      icon: Icons.arrow_drop_down_circle,
                                      color: Colors.black),
                                  clearIconProperty: IconProperty(
                                      color: Colors.black, icon: Icons.clear),
                                  dropdownColor: const Color(0xffDDE6E8),
                                  // searchDecoration:InputDecoration(hintText: "Select Product"),
                                  textFieldDecoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '     Select Product',
                                    hintStyle: TextStyle(
                                      fontSize: 17,
                                      fontFamily: ConstantFonts.sfProMedium,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return "Required Product Name";
                                    } else {
                                      return null;
                                    }
                                  },
                                  dropDownItemCount: 7,
                                  dropDownList: productList,

                                  onChanged: (val) {
                                    selectedVal =
                                        itermNameController.dropDownValue?.name;
                                    getProductsDetails();
                                    // print(selectedVal);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),

                      ///Quantity
                      Row(
                        children: [
                          buildContainer(
                            height,
                            width,
                            SizedBox(
                              width: width * 0.38,
                              height: height * 0.08,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: ConstantFonts.sfProMedium
                                    ),
                                    textAlign: TextAlign.center,
                                    textInputAction: TextInputAction.done,
                                    // validator: (value) {
                                    //   if (value == null || value.isEmpty) {
                                    //     return 'Please enter quantity';
                                    //   }
                                    //   return null;
                                    // },
                                    keyboardType: TextInputType.number,
                                    decoration:  InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Quantity of Product',
                                    hintStyle: TextStyle(
                                      fontFamily: ConstantFonts.sfProMedium,
                                      fontSize: 17,
                                    ),
                                    ),
                                    controller: quantityController,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          ///ADD BUTTON
                          GestureDetector(
                            onTap: () {
                              if (itermNameController.dropDownValue == null) {
                                showSnackBar(
                                    message: 'Select Product',
                                    color: Colors.red);
                              } else if (quantityController.text.isEmpty) {
                                showSnackBar(
                                    message: 'Fill Quantity',
                                    color: Colors.red);
                              } else {
                                setState(() {
                                  minPriceList.add(
                                      int.parse(quantityController.text) *
                                          int.parse(minPrice.toString()));

                                  obcPriceList.add(
                                      int.parse(quantityController.text) *
                                          int.parse(obcPrice.toString()));

                                  final index = listOfProductDetails.indexWhere(
                                      (element) =>
                                          element.productName ==
                                          itermNameController
                                              .dropDownValue?.name);
                                  if (index > -1) {
                                    listOfProductDetails[index]
                                            .productQuantity +=
                                        int.parse(quantityController.text);
                                    listOfProductDetails[index].subTotalList +=
                                        int.parse(listOfProductDetails[index]
                                                .productPrice) *
                                            int.parse(quantityController.text);
                                  } else {
                                    final product = TableList(
                                        productName: itermNameController
                                            .dropDownValue!.name,
                                        productQuantity:
                                            int.parse(quantityController.text),
                                        productPrice: maxPrice.toString(),
                                        subTotalList:
                                            int.parse(quantityController.text) *
                                                int.parse(maxPrice.toString()));
                                    listOfProductDetails.add(product);
                                  }
                                  var sum = 0.0;
                                  for (var i = 0;
                                      i < listOfProductDetails.length;
                                      i++) {
                                    sum += listOfProductDetails[i].subTotalList;
                                    maxTotal = sum.toInt();
                                  }

                                  var sum1 = 0.0;
                                  for (var i = 0;
                                      i < minPriceList.length;
                                      i++) {
                                    sum1 += minPriceList[i];
                                    minTotal = sum1.toInt();
                                  }

                                  var sum2 = 0.0;
                                  for (var i = 0;
                                      i < obcPriceList.length;
                                      i++) {
                                    sum2 += obcPriceList[i];
                                    obcTotal = sum2.toInt();
                                  }

                                  discount = int.parse(maxTotal.toString()) -
                                      int.parse(minTotal.toString());

                                  // print('$maxTotal , $discount $obcTotal');
                                  percentage = (int.parse(discount.toString()) /
                                          int.parse(maxTotal.toString())) *
                                      100;
                                  // print(percentage);

                                  maximumDiscount =
                                      double.parse(percentage.toString())
                                          .toInt();
                                  itermNameController.clearDropDown();
                                  quantityController.clear();
                                  showTable = true;
                                });
                              }
                            },
                            child: buildContainer(
                              width,
                              height,
                              SizedBox(
                                width: width * 0.4,
                                height: height * 0.08,
                                child: Center(
                                  child: Text(
                                    'Add',
                                    style: TextStyle(
                                      fontFamily: ConstantFonts.sfProBold,
                                        fontSize: height * 0.021),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      ///Table And Button
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        // color: Colors.black,
                        height: showTable ? height * 0.55 : height * 0,

                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              /// Table Heading
                              buildContainer(
                                width,
                                height,
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.05),
                                  width: width * 1,
                                  height: height * 0.08,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: width * 0.15,
                                        child: Text(
                                          'Name',
                                          style: TextStyle(
                                            fontFamily: ConstantFonts.sfProMedium,
                                            fontSize: height * 0.017,
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
                                            fontFamily: ConstantFonts.sfProMedium,
                                            fontSize: height * 0.017,

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
                                              fontFamily: ConstantFonts.sfProMedium,
                                              fontSize: height * 0.017,

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
                                              fontFamily: ConstantFonts.sfProMedium,
                                              fontSize: height * 0.017,
                                            ),
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /// Table Value
                              buildContainer(
                                width,
                                height,
                                SizedBox(
                                  height: height * 0.25,
                                  width: width * 1,
                                  child: ListView.builder(
                                    // shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: listOfProductDetails.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          // showDeleteDialog(context, index);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Table(
                                            // border: TableBorder.all(),
                                            children: [
                                              buildRow([
                                                listOfProductDetails[index]
                                                    .productName,
                                                listOfProductDetails[index]
                                                    .productQuantity
                                                    .toString(),
                                                listOfProductDetails[index]
                                                    .productPrice,
                                                listOfProductDetails[index]
                                                    .subTotalList
                                                    .toString(),
                                              ]),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.05,
                              ),

                              ///Get Points Button
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    getPointsStatus = true;
                                    //     minPriceList.add(
                                    //         int.parse(quantityController.text) *
                                    //             int.parse(minPrice.toString()));
                                    //
                                    //     obcPriceList.add(
                                    //         int.parse(quantityController.text) *
                                    //             int.parse(obcPrice.toString()));
                                    //
                                    //     final index = listOfProductDetails.indexWhere(
                                    //         (element) =>
                                    //             element.productName ==
                                    //             itermNameController
                                    //                 .dropDownValue?.name);
                                    //     if (index > -1) {
                                    //       listOfProductDetails[index]
                                    //               .productQuantity +=
                                    //           int.parse(quantityController.text);
                                    //       listOfProductDetails[index].subTotalList +=
                                    //           int.parse(listOfProductDetails[index]
                                    //                   .productPrice) *
                                    //               int.parse(quantityController.text);
                                    //     } else {
                                    //       final product = TableList(
                                    //           productName: itermNameController
                                    //               .dropDownValue!.name,
                                    //           productQuantity:
                                    //               int.parse(quantityController.text),
                                    //           productPrice: maxPrice.toString(),
                                    //           subTotalList:
                                    //               int.parse(quantityController.text) *
                                    //                   int.parse(maxPrice.toString()));
                                    //       listOfProductDetails.add(product);
                                    //     }
                                    //     var sum = 0.0;
                                    //     for (var i = 0;
                                    //         i < listOfProductDetails.length;
                                    //         i++) {
                                    //       sum += listOfProductDetails[i].subTotalList;
                                    //       maxTotal = sum.toInt();
                                    //     }
                                    //
                                    //     var sum1 = 0.0;
                                    //     for (var i = 0;
                                    //         i < minPriceList.length;
                                    //         i++) {
                                    //       sum1 += minPriceList[i];
                                    //       minTotal = sum1.toInt();
                                    //     }
                                    //
                                    //     var sum2 = 0.0;
                                    //     for (var i = 0;
                                    //         i < obcPriceList.length;
                                    //         i++) {
                                    //       sum2 += obcPriceList[i];
                                    //       obcTotal = sum2.toInt();
                                    //     }
                                    //
                                    //     discount = int.parse(maxTotal.toString()) -
                                    //         int.parse(minTotal.toString());
                                    //
                                    //     // print('$maxTotal , $discount $obcTotal');
                                    //     percentage = int.parse(maxTotal.toString()) /
                                    //         int.parse(discount.toString());
                                    //
                                    //     maximumDiscount =
                                    //         double.parse(percentage.toString())
                                    //             .toInt();
                                    //     getPointsStatus = true;
                                  });
                                },
                                child: buildContainer(
                                  width,
                                  height,
                                  SizedBox(
                                      width: width * 1,
                                      height: height * 0.08,
                                      child: Center(
                                          child: Text(
                                        'Get Price Details',
                                        style: TextStyle(
                                            fontFamily: ConstantFonts.sfProBold,
                                            fontSize: height * 0.025),
                                      ),
                                      ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: getPointsStatus ? height * 1 : height * 0.0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildContainer(
                          width,
                          height,
                          SizedBox(
                            height: height * 0.20,
                            width: width * 0.9,
                            child: Column(
                              children: [
                                buildListTile(height, 'Max Total Amount',
                                    maxTotal.toString()),
                                buildListTile(height, 'Min Total Amount',
                                    minTotal.toString()),
                                buildListTile(height, 'Discount Amount', '${  int.parse(maxTotal.toString()) *
                                    int.parse(maximumDiscount.toString()) / 100}'),
                                buildListTile(height, 'Percentage',
                                    maximumDiscount.toString()),
                              ],
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            buildContainer(
                              width,
                              height,
                              Container(
                                padding: const EdgeInsets.all(8),
                                height: height * 0.09,
                                width: width * .85,
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: ConstantFonts.sfProMedium,
                                    ),
                                    textInputAction: TextInputAction.done,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter quantity';
                                      } else if (value
                                          .toString()
                                          .contains('.')) {
                                        return 'Enter Single Value';
                                      } else if (int.parse(value) >=
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
                                            'Enter below ${maximumDiscount.toString()} %',
                                    hintStyle: TextStyle(
                                      fontFamily: ConstantFonts.sfProMedium,
                                      fontSize: 17,
                                    )
                                    ),
                                    controller: percentageController,
                                  ),
                                ),
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     setState(() {
                            //       itermNameController.clearDropDown();
                            //       quantityController.clear();
                            //       getPointsStatus = false;
                            //     });
                            //   },
                            //   child: buildNeumorphic(
                            //     width,
                            //     height,
                            //     SizedBox(
                            //       height: height * 0.09,
                            //       width: width * 0.3,
                            //       child: const Center(
                            //           child: Text(
                            //             'Add Products',
                            //             style:
                            //             TextStyle(fontWeight: FontWeight.w900),
                            //           )),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_form.currentState!.validate()) {
                            setState(() {
                              discountedAmount =
                                  int.parse(maxTotal.toString()) *
                                      int.parse(percentageController.text) /
                                      100;
                              // print(discountedAmount);
                              finalAmount = double.parse(maxTotal.toString()) -
                                  double.parse(discountedAmount.toString());

                              prPoint = (double.parse(finalAmount.toString()) -
                                      double.parse(obcTotal.toString())) /
                                  1000;

                              // print(prPoint);
                              // prPoint = double.parse(prPoint!.toStringAsFixed(3));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PointView(
                                            points: prPoint.toString(),
                                          )));
                              // percentageController.clear();
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
                            });
                          }
                        },
                        child: buildContainer(
                          width,
                          height,
                          SizedBox(
                            height: height * 0.08,
                            width: width * 0.9,
                            child: Center(
                              child: Text(
                                "Get Point",
                                style: TextStyle(
                                    fontSize: height * 0.027,
                                   fontFamily: ConstantFonts.sfProBold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListTile(double height, String title, String value) {
    return SizedBox(
      height: height * 0.04,
      child: Center(
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontFamily: ConstantFonts.sfProBold,
            ),
          ),
          trailing: Text(
            value,
            style: TextStyle(
              fontFamily: ConstantFonts.sfProMedium,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContainer(double width, double height, Widget widget) {
    return Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: CupertinoColors.systemGrey.withOpacity(0.4),
        ),
        child: widget
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

  void showSnackBar({required String message, required Color color}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        padding: const EdgeInsets.all(0.0),
        content: Container(
          height: 50.0,
          color: color,
          child: Center(
            child: Text(
              message,
              style: TextStyle(
                  fontSize: 17,
                  fontFamily: ConstantFonts.sfProMedium),
            ),
          ),
        ),
      ),
    );
  }
}

class TableList {
  String productName;
  String productPrice;
  int productQuantity;
  int subTotalList;

  TableList(
      {required this.productName,
      required this.productQuantity,
      required this.productPrice,
      required this.subTotalList});
}

class PointView extends StatefulWidget {
  final String points;

  const PointView({Key? key, required this.points}) : super(key: key);

  @override
  State<PointView> createState() => _PointViewState();
}

class _PointViewState extends State<PointView> {
  final controller = ConfettiController();

  bool isPlaying = false;

  bool isPressed = false;

  @override
  void initState() {
    controller.play();
    Timer(const Duration(milliseconds: 500), () {
      controller.stop();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xff282C35),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.2),
            Text(
              'You have got',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: ConstantFonts.sfProMedium,
                  fontSize: height * 0.05),
            ),
            Text(
              widget.points.toString(),
              style: TextStyle(
                  color: Colors.amber,
                  fontFamily: ConstantFonts.sfProMedium,
                  fontSize: height * 0.05,
              ),
            ),
            Text(
              'points👍',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: ConstantFonts.sfProMedium,
                  fontSize: height * 0.05),
            ),
            SizedBox(height: height * 0.3),
            Center(
                child: Listener(
              onPointerUp: (_) => setState(() {
                isPressed = false;
              }),
              onPointerDown: (_) => setState(() {
                isPressed = true;
              }),
              child: Container(
                height: height * 0.08,
                width: width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: CupertinoColors.systemPurple,
                ),
                child: CupertinoButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                    child: Text(
                      'Go Back',
                      style: TextStyle(
                          fontSize: height * 0.035,
                          fontFamily: ConstantFonts.sfProBold,
                          color: const Color(0xffDDE6E8)),
                    ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

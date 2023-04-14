import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  double subTotal = 0.0;

  bool gstNeed = false;
  bool labNeed = false;
  bool discountNeed = false;

  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<DropDownValueModel> productList =  [];

  bool isTextFiled = false;

  var setProdoct;

  Future<void> getProducts() async {
    int count = 1;
    ref.child('inventory_management').once().then((value) {

      for (var a in value.snapshot.children) {
        // print(a.key);
        setState(() {
          setProdoct = a.value;
          productList.add(DropDownValueModel(name: setProdoct['name'], value: count));
        });
        setState(() {
          count++;
        });
      }
    });
  }

  var setval;
  String? selectedVal;

  Future<void> getProductsDetails() async {
    ref.child('inventory_management').once().then((value) {
      for (var a in value.snapshot.children) {
        // print(a.value);
        if (a.value.toString().contains(selectedVal.toString())) {
          // print(a.value);
          setval = a.value;
          setState(() {
            priceController.text = setval['max_price'];
          });
        }
      }
    });
  }

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
      //   // print("aasswipe");
      // }else{
      //   subTotal = val.map((e) => e.quantity*e.amount).reduce((value, element) => value + element);
      // }
      // final netTotal = val.map((item) => item.amount * item.quantity).reduce((item1, item2) => item1 + item2);

      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Add Items",
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
                Navigator.pop(context);
              });
            },
          ),
          // actions: [
          //   GestureDetector(
          //     child: Icon(
          //       Icons.account_circle_outlined,
          //       color: const Color(0xff00bcd4),
          //       size: height * 0.03,
          //     ),
          //     onTap: () {
          //       setState(() {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => const AccountScreen()));
          //       });
          //     },
          //   ),
          //   SizedBox(width: width*0.05,)
          //
          // ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Date : ${DateFormat("dd.MM.yyyy").format(date)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: height * 0.012,
                      fontFamily: 'Nexa',
                      color: Colors.black),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  width: width * 1,
                  height: height * 0.04,
                  decoration: BoxDecoration(
                      color: const Color(0xff00bcd4),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Products',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.019,
                          fontFamily: 'Nexa',
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  width: width * 0.9,
                  height: height * 0.05,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
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
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  width: width * 0.9,
                  height: height * 0.08,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
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
                SizedBox(
                  height: height * 0.02,
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  width: width * 0.9,
                  height: height * 0.08,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 0.15,
                        child: Text('Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: height * 0.012,
                            fontFamily: 'Avenir',
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
                        child: Text('Quantity',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: height * 0.012,
                            fontFamily: 'Avenir',
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
                          child: Text('Rate',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.012,
                              fontFamily: 'Avenir',
                            ),
                          )

                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * 0.18,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                  ),
                  child: ListView.builder(
                    // shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemCount: productName.length,
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
                                '${productName[index]}',
                                '${productQuantity[index]}',
                                '${productPrice[index]}',
                              ]),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  height: height * 0.27,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                              items: <String>[
                                'QUOTATION',
                                'INVOICE'
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

                        ///NEED DISCOUNT
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Discount : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.012,
                                  fontFamily: 'Nexa',
                                  color: Colors.black),
                            ),
                            Checkbox(
                                value: discountNeed,
                                onChanged: (val) {
                                  setState(() {
                                    discountNeed = val!;
                                  });
                                })
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (discountNeed)
                                ? Text(
                              "Give Discount : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.012,
                                  fontFamily: 'Nexa',
                                  color: Colors.black),
                            )
                                : const Text(""),
                            (discountNeed)
                                ? SizedBox(
                              width: width * 0.40,
                              child: TextFormField(
                                onChanged: (val) {
                                  if (val.isNotEmpty) {
                                    setState(() {
                                      discountAmount = int.parse(val);
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
                                  hintText: ' Enter Amount',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    fontFamily: 'Nexa',
                                  ),
                                ),
                                controller: discountController,
                              ),
                            )
                                : const Text(""),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            dropdownValue == "INVOICE"
                                ? Text(
                              "Advance Amount",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.012,
                                  fontFamily: 'Nexa',
                                  color: Colors.black),
                            )
                                : const Text(""),
                            dropdownValue == "INVOICE"
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
                SizedBox(
                  height: height * 0.01,
                ),
                SizedBox(
                  width: width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (productName.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Please select product'),
                                duration: Duration(seconds: 1),
                              ));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PreviewScreen(
                                        doctype: dropdownValue,
                                        category: category,
                                        advanceAmt: advanceAmt,
                                        // labAndInstall: labCharge,
                                        gstValue: gstNeed,
                                        discountAmount: discountAmount,
                                        discountNeed: discountNeed,
                                        // labValue: labNeed,
                                      ))).then((value) {
                                setState(() {
                                  // labAndInstall.clear();
                                  advancePaid.clear();
                                  advanceAmt = 0;
                                  // labCharge = 0;
                                });
                              });
                            }
                          });
                        },
                        child: Container(
                          width: width * 0.28,
                          height: height * 0.05,
                          decoration: BoxDecoration(
                            color: const Color(0xff00bcd4),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(8, 8),
                                  blurRadius: 10,
                                  spreadRadius: 0)
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.013,
                                  fontFamily: 'Nexa',
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
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
          productName.removeAt(index);
          productQuantity.removeAt(index);
          productVat.removeAt(index);
          productPrice.removeAt(index);
          Provider.of<TaskData>(context, listen: false).deleteTask(index);
          Provider.of<TaskData>(context, listen: false).clearSubtotal(index);
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
          if (!mounted) return;
          setState(() {
            isTextFiled ? productName.add(itermNameController2.text): productName.add(itermNameController.dropDownValue?.name);
            productPrice.add(priceController.text);
            productQuantity.add(quantityController.text);
            productVat.add(vatController.text);
          });
          Provider.of<TaskData>(context, listen: false).addInvoiceListData(
              isTextFiled ?  itermNameController2.text.toString() : itermNameController.dropDownValue!.name.toString(),
              int.parse(quantityController.text),
              double.parse(priceController.text));
          Provider.of<TaskData>(context, listen: false).addSubTotal(
              int.parse(quantityController.text),
              double.parse(priceController.text));
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
      content: StatefulBuilder(builder:
          (BuildContext context, StateSetter setState) {
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
                    child: isTextFiled != true ?  DropDownTextField(
                      // initialValue: "name4",
                      controller: itermNameController,
                      clearOption: true,
                      enableSearch: true,
                      // dropDownIconProperty: IconProperty(icon: Icons.arrow_drop_down,color: Colors.black),
                      clearIconProperty: IconProperty(
                          color: Colors.black, icon: Icons.clear),
                      // dropdownColor: Colors.orange,

                      searchDecoration: const InputDecoration(
                          hintText: "Select Product"),
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
                        selectedVal = itermNameController.dropDownValue?.name;
                        getProductsDetails();

                      },
                    )
                        : Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(hintText: 'Product Name'),
                        controller: itermNameController2,
                      ),
                    ),
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
                      decoration: const InputDecoration(hintText: 'Amount Of Product'),
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
                      decoration: const InputDecoration(hintText: 'Quantity of Product'),
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
        return StatefulBuilder(
            builder: (context, setState) {
              return WillPopScope(onWillPop: () async {
                return false;
              },
                child: alert,
              );
            }
        );
      },
    );
  }


}


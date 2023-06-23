import 'dart:developer';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:provider/provider.dart';

import '../models/providers.dart';
import '../models/table_list.dart';
import '../widgets/button_widget.dart';
import '../widgets/textFiled_widget.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final formKey = GlobalKey<FormState>();
  final ref = FirebaseDatabase.instance.ref();

  ///CONTROLLERS
  SingleValueDropDownController itemNameController =
  SingleValueDropDownController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemQtyController = TextEditingController();

  final productName = TextEditingController();
  final productPrice = TextEditingController();
  final pageController = PageController();

  ///LISTS
  List<DropDownValueModel> productList = [];
  List<ListOfTable> listOfProductDetails = [];

  ///STRINGS
  String? selectedItemName;
  String? maxPriceStringVal;
  String? minPriceStringVal;
  String? obcPriceStringVal;

  int? minTotal;
  int? obcTotal;

  List minPriceList = [];
  List obcPriceList = [];

  var setGetProductsDetailsValue;

  Future<void> getSelectedProductsDetails() async {
    ref.child('inventory_management').once().then((value) {
      for (var a in value.snapshot.children) {
        final x = a.value as Map<Object?, Object?>;
        if (x['name'].toString().toUpperCase() ==
            selectedItemName.toString().toUpperCase()) {
          setGetProductsDetailsValue = a.value;
          setState(() {
            itemPriceController.text = setGetProductsDetailsValue['max_price'];
            maxPriceStringVal = setGetProductsDetailsValue['max_price'];
            minPriceStringVal = setGetProductsDetailsValue['min_price'];
            obcPriceStringVal = setGetProductsDetailsValue['obc'];
          });
        }
      }
    });
  }

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

  bool manualEntry = false;

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  void dispose() {
    itemNameController.dispose();
    itemQtyController.dispose();
    itemPriceController.dispose();
    productName.dispose();
    productPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                // color: Colors.blue,
                width: 300,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        manualEntry = !manualEntry;
                        log(manualEntry.toString());
                      });
                    },
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(manualEntry ? 'Change to DropDown' : 'Change to Manual Entry',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: ConstantFonts.poppinsRegular,
                          color: CupertinoColors.systemPurple
                        ),),
                        const SizedBox(
                          width: 10,
                        ),
                        manualEntry
                            ? const Icon(CupertinoIcons.arrow_2_circlepath)
                            : const Icon(CupertinoIcons.plus_rectangle_fill_on_rectangle_fill),
                      ],
                    )),
              ),

              /// Product Details
              productDetails(height,manualEntry),

              /// Next Button
              addButton(height,manualEntry),
            ],
          ),
        ),
      ),
    );
  }

  Widget addButton(
      double height,
      bool isManual
      ) {
    return Container(
        margin: EdgeInsets.only(top: height * 0.25),
        child: Button('Add Product', () {
          if (formKey.currentState!.validate()) {
            // minPriceList.add(int.parse(itemQtyController.text) *
            //     int.parse(minPriceStringVal.toString()));
            //
            // obcPriceList.add(int.parse(itemQtyController.text) *
            //     int.parse(obcPriceStringVal.toString()));

            Provider.of<InvoiceProvider>(context, listen: false).addProduct(
              ListOfTable(
                  productName: isManual ? productName.text :itemNameController.dropDownValue!.name,
                  productQuantity: int.parse(itemQtyController.text),
                  productPrice: int.parse(itemPriceController.text),
                  subTotalList: isManual ? int.parse(itemQtyController.text) * int.parse(itemPriceController.text.toString()) :  int.parse(itemQtyController.text) * int.parse(maxPriceStringVal.toString()),
                  minPrice: isManual ? int.parse(itemPriceController.text) : int.parse(minPriceStringVal.toString()),
                  obcPrice: isManual ? int.parse(itemPriceController.text) : int.parse(obcPriceStringVal.toString())),
            );
            Navigator.pop(context);

            log('MAX Price${maxPriceStringVal.toString()}');
            log('MIN Price${minPriceStringVal.toString()}');
            log('OBC Price${obcPriceStringVal.toString()}');
          }
        }).button());
  }

  Widget productDetails(double height, bool isManualEntry) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: height * 0.3,
      decoration: BoxDecoration(
        // color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ///DROPDOWN FILED

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isManualEntry
                    ? '  Enter Product Name\n'  : '  Select Product\n',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    fontFamily: ConstantFonts.poppinsRegular),
              ),
              isManualEntry
                  ? TextFiledWidget(
                isEnable: true,
                controller: productName,
                textInputType: TextInputType.name,
                textInputAction: TextInputAction.next,
                hintName: 'Product Name',
                icon: const Icon(Icons.currency_rupee_rounded,
                    color: Colors.black),
                maxLength: 1000,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Fill Product Name';
                  }
                  return null;
                },
              ).textInputFiled()
                  : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: height * .08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.black.withOpacity(0.3), width: 2),
                ),
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: DropDownTextField(
                    // initialValue: "name4",
                    controller: itemNameController,
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: ConstantFonts.poppinsRegular),
                    clearOption: true,
                    enableSearch: true,
                    dropDownIconProperty: IconProperty(
                        icon: Icons.arrow_drop_down, color: Colors.black),
                    clearIconProperty: IconProperty(
                        color: Colors.black, icon: Icons.clear),
                    // dropdownColor: Colors.orange,
                    searchDecoration: InputDecoration(
                      hintText: "Select Product",
                      hintStyle: TextStyle(
                        fontFamily: ConstantFonts.poppinsRegular,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    listTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: ConstantFonts.poppinsRegular,
                        fontSize: 16),
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
                      selectedItemName =
                          itemNameController.dropDownValue?.name;
                      getSelectedProductsDetails();
                    },
                  ),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// PRICE FILED
              SizedBox(
                width: 160,
                child: TextFiledWidget(
                  isEnable: isManualEntry ? true : false,
                  controller: itemPriceController,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  hintName: 'Product Price',
                  icon: const Icon(Icons.currency_rupee_rounded,
                      color: Colors.black),
                  maxLength: 20,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fill Product Price';
                    }
                    return null;
                  },
                ).textInputFiled(),
              ),

              ///QUANTITY FILED
              SizedBox(
                width: 160,
                child: TextFiledWidget(
                  controller: itemQtyController,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  hintName: 'Quantity',
                  icon: const Icon(Icons.numbers, color: Colors.black),
                  maxLength: 20,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fill Quantity';
                    }
                    return null;
                  },
                ).textInputFiled(),
              ),
            ],
          )
        ],
      ),
    );
  }
}

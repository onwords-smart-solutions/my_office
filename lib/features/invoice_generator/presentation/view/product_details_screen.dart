import 'dart:developer';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_app_button.dart';
import 'package:my_office/features/invoice_generator/data/data_source/invoice_generator_fb_data_source.dart';
import 'package:my_office/features/invoice_generator/data/data_source/invoice_generator_fb_data_source_impl.dart';
import 'package:my_office/features/invoice_generator/data/repository/invoice_generator_repo_impl.dart';
import 'package:my_office/features/invoice_generator/domain/repository/invoice_generator_repository.dart';
import 'package:my_office/features/invoice_generator/presentation/provider/invoice_generator_provider.dart';
import 'package:my_office/features/invoice_generator/utils/list_of_table_utils.dart';
import 'package:provider/provider.dart';
import '../../../../core/utilities/custom_widgets/custom_text_field.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final formKey = GlobalKey<FormState>();

  ///CONTROLLERS
  SingleValueDropDownController itemNameController = SingleValueDropDownController();
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

  late InvoiceGeneratorFbDataSource invoiceGeneratorFbDataSource = InvoiceGeneratorFbDataSourceImpl();
  late InvoiceGeneratorRepository invoiceGeneratorRepository = InvoiceGeneratorRepoImpl(invoiceGeneratorFbDataSource);

  Future<void> getSelectedProductsDetails(String productName) async {
    try {
      final productDetails = await invoiceGeneratorRepository.getProductDetails(selectedItemName!);
      setState(() {
        itemPriceController.text = productDetails.maxPrice;
        maxPriceStringVal = productDetails.maxPrice;
        minPriceStringVal = productDetails.minPrice;
        obcPriceStringVal = productDetails.obcPrice;
      });
    } catch (e) {
      Exception('Error caught while selecting products $e');
    }
  }

  Future<void> getProducts() async {
    try {
      final products = await invoiceGeneratorRepository.getProducts();
      setState(() {
        productList = products
            .asMap()
            .entries
            .map(
              (e) => DropDownValueModel(name: e.value.name, value: e.key + 1),
        )
            .toList();
      });
    } catch (e) {
      Exception('Error caught while fetching product details! $e');
    }
  }

  bool manualEntry = false;

  @override
  void initState() {
    getProducts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
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
              const SizedBox(
                // color: Colors.blue,
                width: 300,
                // child: IconButton(
                //     onPressed: () {
                //       setState(() {
                //         manualEntry = !manualEntry;
                //         log(manualEntry.toString());
                //       });
                //     },
                // icon: Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(manualEntry ? 'Change to DropDown' : 'Change to Manual Entry',
                //     style: TextStyle(
                //       fontSize: 17,
                //
                //       color: CupertinoColors.systemPurple
                //     ),),
                //     const SizedBox(
                //       width: 10,
                //     ),
                //     manualEntry
                //         ? const Icon(CupertinoIcons.arrow_2_circlepath)
                //         : const Icon(CupertinoIcons.plus_rectangle_fill_on_rectangle_fill),
                //   ],
                // )),
              ),

              /// Product Details
              productDetails(height, manualEntry),

              /// Next Button
              addButton(height, manualEntry),
            ],
          ),
        ),
      ),
    );
  }

  Widget addButton(
    double height,
    bool isManual,
  ) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.25),
      child: AppButton(
        child: Text('Add Product', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            // minPriceList.add(int.parse(itemQtyController.text) *
            //     int.parse(minPriceStringVal.toString()));
            //
            // obcPriceList.add(int.parse(itemQtyController.text) *
            //     int.parse(obcPriceStringVal.toString()));

            Provider.of<InvoiceGeneratorProvider>(context, listen: false)
                .addProduct(
              ListOfTable(
                productName: isManual
                    ? productName.text
                    : itemNameController.dropDownValue!.name,
                productQuantity: int.parse(itemQtyController.text),
                productPrice: int.parse(itemPriceController.text),
                subTotalList: isManual
                    ? int.parse(itemQtyController.text) *
                        int.parse(itemPriceController.text.toString())
                    : int.parse(itemQtyController.text) *
                        int.parse(maxPriceStringVal.toString()),
                minPrice: isManual
                    ? int.parse(itemPriceController.text)
                    : int.parse(minPriceStringVal.toString()),
                obcPrice: isManual
                    ? int.parse(itemPriceController.text)
                    : int.parse(obcPriceStringVal.toString()),
              ),
            );
            Navigator.pop(context);

            log('MAX Price${maxPriceStringVal.toString()}');
            log('MIN Price${minPriceStringVal.toString()}');
            log('OBC Price${obcPriceStringVal.toString()}');
          }
        },
      ),
    );
  }

  Widget productDetails(double height, bool isManualEntry) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: height * 0.3,
      decoration: BoxDecoration(
        // color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ///DROPDOWN FILED

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isManualEntry ? '  Enter Product Name\n' : '  Select Product\n',
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              isManualEntry
                  ? CustomTextField(
                      isEnable: true,
                      controller: productName,
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      hintName: 'Product Name',
                      icon: Icon(
                        Icons.currency_rupee_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      maxLength: 1000,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Fill Product Name';
                        }
                        return null;
                      },
                    ).textInputField(context)
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: height * .08,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor.withOpacity(.1),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: DropDownTextField(
                          // initialValue: "name4",
                          dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                          controller: itemNameController,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ),
                          clearOption: true,
                          enableSearch: true,
                          dropDownIconProperty: IconProperty(
                            icon: Icons.arrow_drop_down,
                            color: Theme.of(context).primaryColor,
                          ),
                          clearIconProperty: IconProperty(
                            color: Theme.of(context).primaryColor,
                            icon: Icons.clear,
                          ),
                          textFieldDecoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '   Select Product',
                            hintStyle: TextStyle(
                              fontSize: 17,
                              color: Theme.of(context).primaryColor.withOpacity(.5),
                            ),
                          ),
                          searchDecoration: InputDecoration(
                            hintText: "Select Product",
                            hintStyle: TextStyle(
                              color: Theme.of(context).primaryColor.withOpacity(.5),
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          listTextStyle: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
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
                            selectedItemName =
                                itemNameController.dropDownValue?.name;
                            getSelectedProductsDetails(selectedItemName!);
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
                child: CustomTextField(
                  isEnable: isManualEntry ? true : false,
                  controller: itemPriceController,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  hintName: 'Product Price',
                  icon: Icon(
                    Icons.currency_rupee_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  maxLength: 20,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fill Product Price';
                    }
                    return null;
                  },
                ).textInputField(context),
              ),

              ///QUANTITY FILED
              SizedBox(
                width: 160,
                child: CustomTextField(
                  controller: itemQtyController,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  hintName: 'Quantity',
                  icon: Icon(Icons.numbers, color: Theme.of(context).primaryColor,),
                  maxLength: 20,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fill Quantity';
                    }
                    return null;
                  },
                ).textInputField(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

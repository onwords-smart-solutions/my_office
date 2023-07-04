import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Constant/colors/constant_colors.dart';
import '../../Constant/fonts/constant_font.dart';

class CreateNewProduct extends StatefulWidget {
  const CreateNewProduct({Key? key}) : super(key: key);

  @override
  State<CreateNewProduct> createState() => _CreateNewProductState();
}

class _CreateNewProductState extends State<CreateNewProduct> {
  final ref = FirebaseDatabase.instance.ref().child('inventory_management');

  TextEditingController productNameController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController productIdController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController obcController = TextEditingController();

  createProductList() {
    ref.child(productIdController.text.toString().trim()).set({
      "id": productIdController.text.toString().trim(),
      "max_price": maxPriceController.text.toString().trim(),
      "min_price": minPriceController.text.toString().trim(),
      "name": productNameController.text.toString().trim(),
      "obc": obcController.text.toString().trim(),
      "stock": stockController.text.toString().trim(),
    }

    ).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'New product has been created!!',
            style: TextStyle(
              color: ConstantColor.backgroundColor,
              fontSize: 16,
              fontFamily: ConstantFonts.sfProRegular,
            ),
          ),
        ),
      );
      productIdController.clear();
      productNameController.clear();
      maxPriceController.clear();
      minPriceController.clear();
      obcController.clear();
      stockController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    productNameController.dispose();
    productIdController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    stockController.dispose();
    obcController.dispose();
    super.dispose();
  }

  final _form = GlobalKey<FormState>();

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffDDE6E8),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'New Products',
          style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontFamily: ConstantFonts.sfProBold),
        ),
        backgroundColor: const Color(0xffDDE6E8),
        elevation: 0,
      ),
      body: Form(
        key: _form,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: width*0.03),
              child: Column(
                children: [
                  buildTextField('Product Name', productNameController,
                      TextInputAction.next, TextInputType.text, 'Name'),
                  buildTextField('Product ID', productIdController,
                      TextInputAction.next, TextInputType.text, 'ID'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width*0.47,
                        child: buildTextField(
                          'Max Price',
                          maxPriceController,
                          TextInputAction.next,
                          TextInputType.number,
                          'Max Price',
                        ),
                      ),
                      SizedBox(
                        width: width*0.47,
                        child: buildTextField(
                            'Min Price',
                            minPriceController,
                            TextInputAction.next,
                            TextInputType.number,
                            'Min price'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width*0.47,
                        child: buildTextField('Product OBC', obcController,
                            TextInputAction.next, TextInputType.number, 'OBC'),
                      ),
                      SizedBox(
                        width: width*0.47,
                        child: buildTextField(
                            'Stock',
                            stockController,
                            TextInputAction.done,
                            TextInputType.number,
                            'Stock'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height*0.10,
                  ),
                  Listener(
                    onPointerUp: (_) => setState(() {
                      isPressed = false;
                    }),
                    onPointerDown: (_) => setState(() {
                      isPressed = true;
                    }),
                    child: GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   isPressed = !isPressed;
                        // });
                        final isValid = _form.currentState?.validate();
                        if (isValid!) {
                          createProductList();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: CupertinoColors.systemGrey.withOpacity(0.4),
                            ),
                            child: SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Create Product',
                                  style: TextStyle(
                                      fontSize: 16, fontFamily: ConstantFonts.sfProBold),
                                ),
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
        ),
      ),
    );
  }

  Widget buildTextField(
      String name,
      TextEditingController controller,
      TextInputAction textInputAction,
      TextInputType textInputType,
      String errorName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '    $name',
          style: TextStyle(
              color: Colors.black,fontFamily: ConstantFonts.sfProBold, fontSize: 17),
        ),
        Container(
         padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: CupertinoColors.systemGrey.withOpacity(0.4),
          ),
          child: TextFormField(
              textInputAction: textInputAction,
              keyboardType: textInputType,
              controller: controller,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                border: InputBorder.none,
                hintText: name,
                hintStyle: TextStyle(
                    fontFamily: ConstantFonts.sfProMedium,
                     fontSize: 16,
                     color: Colors.black54),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter $errorName of Product";
                }
                return null;
              },
            ),
        ),
      ],
    );
  }
}

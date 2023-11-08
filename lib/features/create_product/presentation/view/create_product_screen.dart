import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_snack_bar.dart';
import 'package:my_office/features/create_product/domain/entity/create_product_entity.dart';
import 'package:provider/provider.dart';

import '../provider/create_product_provider.dart';

class CreateNewProduct extends StatefulWidget {
  const CreateNewProduct({Key? key}) : super(key: key);

  @override
  State<CreateNewProduct> createState() => _CreateNewProductState();
}

class _CreateNewProductState extends State<CreateNewProduct> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController productIdController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController obcController = TextEditingController();

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

  Future<void> _createProduct() async {
    final provider = Provider.of<CreateProductProvider>(context, listen: false);
    if (_form.currentState?.validate() ?? false) {
      final createProduct = CreateProductEntity(
        id: productIdController.text.trim(),
        name: productNameController.text.trim(),
        maxPrice: maxPriceController.text.trim(),
        minPrice: minPriceController.text.trim(),
        obc: obcController.text.trim(),
        stock: stockController.text.trim(),
      );
      final response = await provider.createProduct(createProduct);
      if (response.isRight) {
        if (!mounted) return;
        CustomSnackBar.showSuccessSnackbar(
          message: 'A new product has been created successfully!',
          context: context,
        );
        productNameController.clear();
        productIdController.clear();
        minPriceController.clear();
        maxPriceController.clear();
        stockController.clear();
        obcController.clear();
      } else {
        if (!mounted) return;
        CustomSnackBar.showErrorSnackbar(
          message: 'Error while creating new product!',
          context: context,
        );
      }
    }
  }

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
        title: const Text(
          'New Products',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xffDDE6E8),
        elevation: 0,
      ),
      body: Form(
        key: _form,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Column(
                children: [
                  buildTextField(
                    'Product Name',
                    productNameController,
                    TextInputAction.next,
                    TextInputType.text,
                    'Name',
                  ),
                  buildTextField(
                    'Product ID',
                    productIdController,
                    TextInputAction.next,
                    TextInputType.text,
                    'ID',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 0.47,
                        child: buildTextField(
                          'Max Price',
                          maxPriceController,
                          TextInputAction.next,
                          TextInputType.number,
                          'Max Price',
                        ),
                      ),
                      SizedBox(
                        width: width * 0.47,
                        child: buildTextField(
                          'Min Price',
                          minPriceController,
                          TextInputAction.next,
                          TextInputType.number,
                          'Min price',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 0.47,
                        child: buildTextField(
                          'Product OBC',
                          obcController,
                          TextInputAction.next,
                          TextInputType.number,
                          'OBC',
                        ),
                      ),
                      SizedBox(
                        width: width * 0.47,
                        child: buildTextField(
                          'Stock',
                          stockController,
                          TextInputAction.done,
                          TextInputType.number,
                          'Stock',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.10,
                  ),
                  Listener(
                    onPointerUp: (_) => setState(() {
                      isPressed = false;
                    }),
                    onPointerDown: (_) => setState(() {
                      isPressed = true;
                    }),
                    child: GestureDetector(
                      onTap: _createProduct,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: CupertinoColors.systemGrey.withOpacity(0.4),
                          ),
                          child: const SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(
                                'Create Product',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
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
    String errorName,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '    $name',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
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
              hintStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
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

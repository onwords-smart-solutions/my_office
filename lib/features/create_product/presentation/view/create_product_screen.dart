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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Create New Product',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                            color: Theme.of(context).primaryColor.withOpacity(.2),
                          ),
                          child: SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(
                                'Create Product',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
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
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).primaryColor.withOpacity(.2),
          ),
          child: TextFormField(
            textInputAction: textInputAction,
            keyboardType: textInputType,
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              border: InputBorder.none,
              hintText: name,
              hintStyle: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor.withOpacity(.4),
              ),
              errorStyle: const TextStyle(color: Colors.red,),
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

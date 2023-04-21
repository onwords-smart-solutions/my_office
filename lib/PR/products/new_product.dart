import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
              fontFamily: ConstantFonts.poppinsMedium,
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
        title: const Text(
          'New Products',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                        child: Neumorphic(
                          duration: const Duration(
                            milliseconds: 200,
                          ),
                          style: NeumorphicStyle(
                            shadowLightColor: Colors.white.withOpacity(0.8),
                            depth: isPressed ? 0 : 3,
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(20),
                            ),
                          ),
                          child: const SizedBox(
                            height: 60,
                            child: Center(
                              child: Text(
                                'Create Product',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Neumorphic(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(5),
          style:  NeumorphicStyle(
            shadowLightColor: Colors.white.withOpacity(0.8),
            depth: 2,
          ),
          child: TextFormField(
            textInputAction: textInputAction,
            keyboardType: textInputType,
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: name,
              hintStyle: const TextStyle(
                  fontWeight: FontWeight.w300, color: Colors.black54),
              // enabledBorder: const OutlineInputBorder(
              //   borderSide: BorderSide(
              //     color: Colors.transparent,
              //   ),
              // ),
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

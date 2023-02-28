import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/PR/visit/summary_notes.dart';
import 'package:my_office/database/hive_operations.dart';
import 'package:my_office/models/visit_model.dart';
import 'package:my_office/util/screen_template.dart';

class ProductDetailScreen extends StatefulWidget {
  final VisitModel visiData;

  const ProductDetailScreen({Key? key, required this.visiData})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  List<File> productImages = [];
  List<Uint8List> productImagesBytes = [];
  List<String> selectedProducts = [];

  Map<String, bool> products = {
    'Smart Home': false,
    'Gate': false,
    'Door': false,
    'Tank': false,
    'Others': false,
  };

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ScreenTemplate(bodyTemplate: buildScreen(), title: 'Product Detail');
  }

  Widget buildScreen() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * .35,
              child: buildProductSelection()),
          const Divider(height: 0.0),
          buildQuotation(),
          const Divider(height: 0.0),
          buildProductImage(),
          buildNextButton(),
        ],
      ),
    );
  }

  Widget buildProductSelection() {
    return Column(
      children: [
        Text(
          'Choose Products',
          style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1,
                mainAxisSpacing: 1.0),
            itemCount: products.length,

            itemBuilder: (BuildContext context, int i) {
              final productName = products.keys.toList()[i].toString();
              final isSelected = products.values.toList()[i];

              String imagePath = 'assets/visit/default.jpg';

              switch (productName.toLowerCase()) {
                case 'smart home':
                  imagePath = 'assets/visit/smart_home.jpg';
                  break;
                case 'gate':
                  imagePath = 'assets/visit/gate.jpg';
                  break;
                case 'tank':
                  imagePath = 'assets/visit/tank.jpg';
                  break;
                case 'door':
                  imagePath = 'assets/visit/door.jpg';
                  break;
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    products.update(productName, (value) {
                      if (value == true) {
                        if (selectedProducts.contains(productName)) {
                          selectedProducts.remove(productName);
                        }
                      } else {
                        selectedProducts.add(productName);
                      }
                      return !value;
                    });
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      gradient:isSelected?null:const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.black, Colors.black],
                        stops:  [0.1, 0.9],
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          colorFilter:isSelected?null: ColorFilter.mode(
                              Colors.black.withOpacity(.3), BlendMode.dstATop),
                          image: AssetImage(imagePath),
                          fit: BoxFit.cover)),
                  child: Align(
                    alignment: AlignmentDirectional.bottomCenter,
                      child:isSelected?const SizedBox.shrink(): Text(
                    productName,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontFamily: ConstantFonts.poppinsBold),
                  )),
                ),
              );
            },

            // children: products.keys.map((String key) {
            //   return SizedBox(
            //     height: 38.0,
            //     child: CheckboxListTile(
            //       checkboxShape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(5.0)),
            //       enableFeedback: true,
            //       title: Text(
            //         key,
            //         style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
            //       ),
            //       value: products[key],
            //       onChanged: (data) {
            //         setState(() {
            //           products.update(key, (value) => data!);
            //           if (data == true) {
            //             selectedProducts.add(key);
            //           } else {
            //             if (selectedProducts.contains(key)) {
            //               selectedProducts.remove(key);
            //             }
            //           }
            //         });
            //       },
            //     ),
            //   );
            // }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildQuotation() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          SizedBox(
            height: size.height * .05,
            width: size.width * .65,
            child: ElevatedButton(
                onPressed: () async {
                  await LaunchApp.openApp(
                    androidPackageName: 'com.onwords.invoice_app',
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff8355B7)),
                child: const Text('Generate Quotation/Invoice')),
          ),
          const Text(
            'or',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
              height: size.height * .06,
              width: size.width * .65,
              child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    hintText: 'Quotation/Invoice number',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.grey.withOpacity(.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 1.5,
                        color: Colors.purple,
                      ),
                    ),
                  ))),
        ],
      ),
    );
  }

  Widget buildProductImage() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .25,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(width: 1, color: Colors.grey)),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: productImages.isEmpty
          ? firstImageInsertion()
          : multipleImageInsertion(),
    );
  }

  Widget multipleImageInsertion() {
    return Column(
      children: [
        CupertinoButton(
            onPressed: () {
              uploadProductImage();
            },
            padding: const EdgeInsets.all(0.0),
            child: Text(
              'Add image',
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium,
                  fontSize: 15.0,
                  color: const Color(0xff8355B7)),
            )),
        Expanded(
            child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: productImages.length,
          itemBuilder: (ctx, i) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(15.0)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.file(
                  productImages[i],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        )),
      ],
    );
  }

  Widget firstImageInsertion() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
            backgroundColor: ConstantColor.backgroundColor,
            radius: 20.0,
            child: IconButton(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  uploadProductImage();
                },
                icon: const Icon(
                  Icons.photo_camera_rounded,
                  color: Colors.white,
                  size: 20.0,
                ))),
        const SizedBox(height: 20.0),
        Text(
          'Upload product image',
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium, fontSize: 15.0),
        ),
      ],
    );
  }

  Widget buildNextButton() {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: submitProductDetailScreen,
      child: Container(
        height: size.height * 0.07,
        width: size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: const LinearGradient(
            colors: [
              Color(0xffD136D4),
              Color(0xff7652B2),
            ],
          ),
        ),
        child: Center(
          child: Text(
            'Next',
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                fontSize: size.height * 0.025,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  //Dialog bottom
  void uploadProductImage() {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await ImagePicker()
                        .pickImage(
                      source: ImageSource.gallery,
                    )
                        .then((pickedImage) async {
                      if (pickedImage == null) return;
                      setState(() {
                        productImages.add(File(pickedImage.path));
                      });
                    });
                  },
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: SizedBox(
                    height: size.height * 0.09,
                    child: Row(
                      children: [
                        SizedBox(width: size.width * 0.05),
                        const Icon(Icons.photo_library_rounded,
                            color: Color(0xff8355B7)),
                        SizedBox(width: size.width * 0.05),
                        Text(
                          "Choose from library",
                          style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await ImagePicker()
                        .pickImage(
                      source: ImageSource.camera,
                    )
                        .then((pickedImage) async {
                      if (pickedImage == null) return;
                      setState(() {
                        productImages.add(File(pickedImage.path));
                      });
                    });
                  },
                  child: SizedBox(
                    height: size.height * 0.09,
                    child: Row(
                      children: [
                        SizedBox(width: size.width * 0.05),
                        const Icon(Icons.camera_alt_rounded,
                            color: Color(0xff8355B7)),
                        SizedBox(width: size.width * 0.05),
                        Text(
                          "Take photo",
                          style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> submitProductDetailScreen() async {
    final nav = Navigator.of(context);

    if (selectedProducts.isEmpty) {
      showSnackBar(
          message: 'Please select at least one product', color: Colors.red);
    } else if (productImages.isEmpty) {
      showSnackBar(message: 'Please upload product image', color: Colors.red);
    } else if (_textController.text.isEmpty) {
      showSnackBar(
          message: 'Please enter quotation or invoice number',
          color: Colors.red);
    } else {
      //converting selected images into Uint8list to store in local db
      if (productImages.length > productImagesBytes.length) {
        productImagesBytes.clear();
        for (var i in productImages) {
          File file = File(i.path);
          productImagesBytes.add(file.readAsBytesSync());
        }
      }

      final visitData = VisitModel(
          dateTime: DateTime.now(),
          customerPhoneNumber: widget.visiData.customerPhoneNumber,
          customerName: widget.visiData.customerName,
          startKmImage: widget.visiData.startKmImage,
          startKm: widget.visiData.startKm,
          prDetails: widget.visiData.prDetails,
          productName: selectedProducts,
          productImage: productImagesBytes,
          quotationInvoiceNumber: _textController.value.text,
          stage: 'productScreen');
      await HiveOperations().updateVisitEntry(newVisitEntry: visitData);

      nav.push(MaterialPageRoute(
          builder: (_) => SummaryAndNotes(visitInfo: visitData)));
    }
  }

  void showSnackBar({required String message, required Color color}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        padding: const EdgeInsets.all(0.0),
        content: Container(
            height: 50.0,
            color: color,
            child: Center(
                child: Text(
              message,
              style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
            )))));
  }
}

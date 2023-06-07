import 'dart:io';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/PR/invoice_generator/screens/client_detials.dart';
// import 'package:my_office/PR/invoice/customer_detail_screen.dart';
import 'package:my_office/PR/visit/visit_summary.dart';
import 'package:my_office/models/visit_model.dart';
import 'package:image/image.dart' as ImageLib;
import '../../Constant/colors/constant_colors.dart';
import '../../Constant/fonts/constant_font.dart';
import '../../database/hive_operations.dart';
import '../../util/screen_template.dart';

class ProductDetailScreen extends StatefulWidget {
  final VisitModel visitData;

  const ProductDetailScreen({Key? key, required this.visitData})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController _invoiceQuotationNumberController =
      TextEditingController();
  List<String> selectedProducts = [];
  List<File> productImages = [];
  VisitModel? uploadedData;
  int currentStep = 0;
  String step1Error = '';
  String step2Error = '';
  String step3Error = '';
  bool isUploading=false;

  Map<String, bool> products = {
    'Smart Home': false,
    'Gate': false,
    'Door': false,
    'Water Tank': false,
    'Others': false,
  };

  @override
  void dispose() {
    _invoiceQuotationNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
        bodyTemplate: buildMainScreen(), title: 'Product Details');
  }

  Widget buildMainScreen() {
    return Stepper(
        currentStep: currentStep > 3 ? 3 : currentStep,
        physics: const BouncingScrollPhysics(),
        onStepContinue: onStepContinue,
        onStepCancel: () {
          if (currentStep == 0) {
            print('cant cancel');
          } else {
            setState(() {
              currentStep = currentStep - 1;
            });
          }
        },
        controlsBuilder: (BuildContext ctx, ControlsDetails details) {
          final buttonText = currentStep == 3 ? 'Continue' : 'Next';
          return isUploading?  loadingAnimation(): Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (currentStep > 0)
                CupertinoButton(
                    onPressed: details.onStepCancel,
                    child: Text(
                      'Back',
                      style: TextStyle(
                          fontFamily: ConstantFonts.poppinsMedium,
                          fontSize: 15.0,
                          color: Colors.grey),
                    )),
              ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff8355B7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  child: Text(buttonText,
                      style: TextStyle(
                        fontFamily: ConstantFonts.poppinsMedium,
                        fontSize: 15.0,
                      ))),
            ],
          );
        },
        steps: [
          productListStep(),
          quotationInvoiceStep(),
          productImageStep(),
          summaryStep(),
        ]);
  }

  Step productListStep() {
    final textStyle = currentStep == 0
        ? ConstantFonts.poppinsBold
        : ConstantFonts.poppinsMedium;
    final textColor = currentStep == 0 ? Colors.purple : Colors.black;

    return Step(
      title: Text(
        'Select Products',
        style: TextStyle(fontFamily: textStyle, color: textColor),
      ),
      content: buildProductList(),
      isActive: currentStep >= 0,
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
    );
  }

  Step quotationInvoiceStep() {
    final textStyle = currentStep == 1
        ? ConstantFonts.poppinsBold
        : ConstantFonts.poppinsMedium;
    final textColor = currentStep == 1 ? Colors.purple : Colors.black;

    return Step(
      title: Text(
        'Generate Invoice or Quotation',
        style: TextStyle(fontFamily: textStyle, color: textColor),
      ),
      content: buildInvoiceQuotation(),
      isActive: currentStep >= 1,
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
    );
  }

  Step productImageStep() {
    final textStyle = currentStep == 2
        ? ConstantFonts.poppinsBold
        : ConstantFonts.poppinsMedium;
    final textColor = currentStep == 2 ? Colors.purple : Colors.black;

    return Step(
      title: Text(
        'Product Images',
        style: TextStyle(fontFamily: textStyle, color: textColor),
      ),
      content: buildProductImage(),
      isActive: currentStep >= 2,
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
    );
  }

  Step summaryStep() {
    final textStyle = currentStep == 3
        ? ConstantFonts.poppinsBold
        : ConstantFonts.poppinsMedium;
    final textColor = currentStep == 3 ? Colors.purple : Colors.black;

    return Step(
      title: Text(
        'Summary',
        style: TextStyle(fontFamily: textStyle, color: textColor),
      ),
      content: buildSummary(),
      isActive: currentStep >= 3,
      state: currentStep > 3 ? StepState.complete : StepState.indexed,
    );
  }

  //on next button clicks in stepper
  void onStepContinue() {
    if (currentStep == 0) {
      if (selectedProducts.isEmpty) {
        setState(() {
          step1Error = 'Choose atleast one product';
        });
      } else {
        setState(() {
          step1Error = '';
          currentStep += 1;
        });
      }
    } else if (currentStep == 1) {
      if (_invoiceQuotationNumberController.text.trim().isEmpty) {
        setState(() {
          step2Error = 'Enter invoice or quotation number';
        });
      } else {
        setState(() {
          step2Error = '';
          currentStep += 1;
        });
      }
    } else if (currentStep == 2) {
      if (productImages.isEmpty) {
        setState(() {
          step3Error = 'Upload product image';
        });
      } else {
        setState(() {
          step3Error = '';
          currentStep += 1;
        });
      }
    }
    else if (currentStep == 3) {
      if (uploadedData != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                VisitSummaryScreen(visitData: uploadedData!)));
      } else {
        submitCurrentSection();
      }
    }
  }

  Widget buildProductList() {
    return Column(
      children: [
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
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
              case 'water tank':
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
              child: Stack(
                children: [
                  //main
                  Container(
                    margin: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        gradient: isSelected
                            ? null
                            : const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.black, Colors.black],
                                stops: [0.1, 0.9],
                              ),
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                            colorFilter: isSelected
                                ? null
                                : ColorFilter.mode(Colors.black.withOpacity(.3),
                                    BlendMode.dstATop),
                            image: AssetImage(imagePath),
                            fit: BoxFit.cover)),
                    child: Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: isSelected
                            ? const SizedBox.shrink()
                            : Text(
                                productName,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                    fontFamily: ConstantFonts.poppinsBold),
                              )),
                  ),
                  if (isSelected)
                    const CircleAvatar(
                      radius: 13.0,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                      ),
                    )
                ],
              ),
            );
          },
        ),

        //Error message section
        if (step1Error.isNotEmpty) showError(message: step1Error),
      ],
    );
  }

  Widget buildInvoiceQuotation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          TextField(
            controller: _invoiceQuotationNumberController,
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                fontSize: 15.0,
                color: Colors.black),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              hintText: 'Invoice or Quotation number',
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
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
                  color: Color(0xff8355B7),
                ),
              ),
            ),
          ),
          const Text(
            'or',
            style: TextStyle(color: Colors.grey),
          ),
          CupertinoButton(
              child: Text(
                'Generate',
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium, fontSize: 16.0),
              ),
              onPressed: () async {
                // await LaunchApp.openApp(
                //   androidPackageName: 'com.onwords.invoice_app',
                // );
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ClientDetails()));
              }),
          if (step2Error.isNotEmpty) showError(message: step2Error)
        ],
      ),
    );
  }

  Widget buildProductImage() {
    return Column(
      children: [
        Container(
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
        ),
        if (step3Error.isNotEmpty) showError(message: step3Error)
      ],
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
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: productImages.length,
          itemBuilder: (ctx, i) {
            return Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.file(
                      productImages[i],
                      width: 120.0,
                      height: 120.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      productImages.removeAt(i);
                    });
                  },
                  child: const CircleAvatar(
                    radius: 12.0,
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    child: Icon(
                      Icons.clear_rounded,
                      size: 20.0,
                    ),
                  ),
                )
              ],
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
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 12.0,
              color: Colors.grey),
        ),
      ],
    );
  }

  Widget buildSummary(){
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1, color: Colors.grey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Products selected',style: TextStyle(fontFamily: ConstantFonts.poppinsBold,fontSize: 15.0,),),
          ListView.builder(
              itemCount: selectedProducts.length,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              shrinkWrap: true,
              itemBuilder: (ctx,i){
            return Text('  ${i+1}. ${selectedProducts[i]}',style: TextStyle(fontFamily: ConstantFonts.poppinsMedium,fontSize: 15.0,));
          }),
          Text('Quotation or Invoice number',style: TextStyle(fontFamily: ConstantFonts.poppinsBold,fontSize: 15.0,),),
          const SizedBox(height: 10.0),
          Text('  ${_invoiceQuotationNumberController.text.trim()}',style: TextStyle(fontFamily: ConstantFonts.poppinsMedium,fontSize: 15.0,),),

          const SizedBox(height: 10.0),
          Text('Uploaded Product image count',style: TextStyle(fontFamily: ConstantFonts.poppinsBold,fontSize: 15.0,),),
          const SizedBox(height: 10.0),
          Text('  ${productImages.length}',style: TextStyle(fontFamily: ConstantFonts.poppinsMedium,fontSize: 15.0,),),

        ],
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

  Widget loadingAnimation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/cloud_animation.json', height: 80.0),
        const SizedBox(height: 10.0),
        Text(
          'Uploading data, please wait',
          style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
        ),
        Text(
          'Don\'t press back button or close this app',
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 12.0,
              color: Colors.grey),
        ),
      ],
    );
  }

  //for showing error message on each steps
  Widget showError({required String message}) {
    return Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: Colors.red),
        const SizedBox(width: 5.0),
        Text(
          message,
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium, color: Colors.red),
        ),
      ],
    );
  }

  Future<void> submitCurrentSection() async {
    setState(() {
      isUploading=true;
    });
    final nav = Navigator.of(context);
    final storageRef = FirebaseStorage.instance.ref().child('${widget.visitData.storagePath}');

    List<String> imageUrls = [];
    List<Map<int, File>> indexImages = [];

    for (int i = 0; i < productImages.length; i++) {
      indexImages.add({i + 1: productImages[i]});
    }
    imageUrls = await Future.wait(indexImages
        .map((image) => uploadImages(image: image, ref: storageRef)));


    //Work only if no error occurred
    if(isUploading){
      final data = VisitModel(
        dateTime: DateTime.now(),
        customerPhoneNumber: widget.visitData.customerPhoneNumber,
        customerName: widget.visitData.customerName,
        stage: 'product',
        inChargeDetail: widget.visitData.inChargeDetail,
        startKm: widget.visitData.startKm,
        storagePath: widget.visitData.storagePath,
        supportCrewNames: widget.visitData.supportCrewNames,
        supportCrewImageLinks: widget.visitData.supportCrewImageLinks,
        startKmImageLink: widget.visitData.startKmImageLink,
        productImageLinks: imageUrls,
        productName: selectedProducts,
        quotationInvoiceNumber: _invoiceQuotationNumberController.text.trim()

      );

      await HiveOperations().updateVisitEntry(newVisitEntry: data);
      setState(() {
        isUploading = false;
        uploadedData = data;
      });
      nav.push(MaterialPageRoute(
          builder: (context) => VisitSummaryScreen(visitData: data)));
    }

  }


  Future<String> uploadImages(
      {required Map<int, File> image, required dynamic ref}) async {
    String url = '';

    try {
      //compressing image
      var sourceImage =
      ImageLib.decodeImage(image.values.first.readAsBytesSync());
      var compressedImage = ImageLib.copyResize(sourceImage!, width: 800);


      final path = ref.child('PRODUCTS/Product_${image.keys.first}.jpg');
      UploadTask uploadTask = path.putData(ImageLib.encodeJpg(compressedImage));
      await uploadTask.whenComplete(() async {
        url = await path.getDownloadURL();
      });
    } catch (e) {
      print(e);
      setState(() {
        isUploading = false;
      });
      showSnackBar(
          message: 'Unable to upload product images. Try again',
          color: Colors.red);
    }
    return url;
  }

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
              style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
            ),
          ),
        ),
      ),
    );
  }

}

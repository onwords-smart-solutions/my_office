import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/home/user_home_screen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

// import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';
import '../../../database/hive_operations.dart';
import '../../../models/staff_model.dart';
import '../models/client_model.dart';
import '../models/providers.dart';
import '../models/table_list.dart';
import '../models/utils.dart';
import '../pdf_class/installation_pdf_class.dart';
import '../pdf_class/inv_qtn_pdf.dart';
import 'dart:ui' as ui;
import '../widgets/button_widget.dart';
import '../widgets/textFiled_widget.dart';

class InvoicePreviewScreen extends StatefulWidget {
  final double finalAmountWithoutGst;

  final double advanceAmount;
  final double discountAmount;
  final double prPoint;
  final int percentage;
  final bool gstNeed;

  const InvoicePreviewScreen(
      {Key? key,
      required this.finalAmountWithoutGst,
      required this.advanceAmount,
      required this.gstNeed,
      required this.percentage,
      required this.discountAmount,
      required this.prPoint})
      : super(key: key);

  @override
  State<InvoicePreviewScreen> createState() => _InvoicePreviewScreenState();
}

class _InvoicePreviewScreenState extends State<InvoicePreviewScreen> {
  final HiveOperations _hiveOperations = HiveOperations();
  StaffModel? staffInfo;

  final formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.ref();
  final date = DateTime.now();

  TextEditingController fileNameController = TextEditingController();
  TextEditingController estimateDateController = TextEditingController();

  double vatPercent = 0.09;
  double gst = 0.0;
  double grandTotal = 0.0;
  double finalTotal = 0.0;

  int docLen = 0;
  int? lisTotal;

  List listOfDocLength = [];
  List alreadyGeneratedId = [];

  // NumberFormat formatter = NumberFormat("0000");

  final GlobalKey _globalKey = GlobalKey();
  Uint8List? convertedImage;

  Future<void> _convertImage() async {
    dev.log('called function _convertImage()');
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 10.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    // dev.log('inside  Data is $convertedImage');
    setState(() {
      convertedImage = pngBytes;
    });
  }

  Future<void> getDocLength() async {
    docLen = 0;
    listOfDocLength.clear();
    databaseReference.child('QuotationAndInvoice').once().then((snap) async {
      try {
        for (var element in snap.snapshot.children) {
          if (Provider.of<InvoiceProvider>(context, listen: false)
                  .customerDetails
                  ?.docType ==
              element.key) {
            for (var element1 in element.children) {
              for (var element2 in element1.children) {
                if (element2.key == Utils.formatMonth(date)) {
                  for (var element3 in element2.children) {
                    listOfDocLength.add(element3.key);
                    dev.log('length ${listOfDocLength.length}');
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        dev.log('$e');
      }
    });
  }

  Future<void> getId() async {
    databaseReference
        .child('QuotationAndInvoice/PROFORMA_INVOICE')
        .once()
        .then((snap) async {
      List generatedId = [];
      for (var val1 in snap.snapshot.children) {
        for (var val2 in val1.children) {
          for (var val3 in val2.children) {
            final data = val3.value as Map<Object?, Object?>;
            final id = data['id'].toString();
            generatedId.add(id);
          }
        }
      }
      setState(() {
        alreadyGeneratedId = generatedId;
        dev.log('ID IS $alreadyGeneratedId');
      });
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const characters = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    return List.generate(
        len, (index) => characters[r.nextInt(characters.length)]).join();
  }

  void getStaffDetail() async {
    final data = await _hiveOperations.getStaffDetail();
    setState(() {
      staffInfo = data;
    });
  }

  @override
  void initState() {
    getStaffDetail();
    getId();
    getDocLength();
    super.initState();
  }

  @override
  void dispose() {
    fileNameController.dispose();
    estimateDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gstNeed) {
      gst = vatPercent * widget.finalAmountWithoutGst.toDouble();
    }

    grandTotal = widget.finalAmountWithoutGst.toDouble() + (gst * 2);
    finalTotal = grandTotal - widget.advanceAmount;

    final invoiceProvider = Provider.of<InvoiceProvider>(context);
    final customerDetails = invoiceProvider.getCustomerDetails;
    final productDetails = invoiceProvider.getProductDetails;

    int total = 0;
    for (var invoice in productDetails) {
      total += invoice.subTotalList;
    }
    lisTotal = total;

    String transactionNote = customerDetails.docCategory == 'GA'
        ? "Gate Automation"
        : customerDetails.docCategory == 'SH'
            ? "Smart Home"
            : customerDetails.docCategory == 'IT'
                ? "APP or Web Development"
                : customerDetails.docCategory == 'DL'
                    ? "Door Lock"
                    : customerDetails.docCategory == 'SS'
                        ? "Security System"
                        : customerDetails.docCategory == 'WTA'
                            ? "Water Tank Automation"
                            : customerDetails.docCategory == 'AG'
                                ? "Agriculture Automation"
                                : 'Onwords Smart Solutions';

    // final upiDetails = UPIDetails(
    //     upiID: "onwordspay@ybl",
    //     payeeName: "Onwords Smart Solutions",
    //     amount: grandTotal < 80000 ? grandTotal : null,
    //     transactionNote: customerDetails.docCategory == 'GA'
    //         ? "Gate Automation"
    //         : customerDetails.docCategory == 'SH'
    //             ? "Smart Home"
    //             : customerDetails.docCategory == 'IT'
    //                 ? "APP or Web Development"
    //                 : customerDetails.docCategory == 'DL'
    //                     ? "Door Lock"
    //                     : customerDetails.docCategory == 'SS'
    //                         ? "Security System"
    //                         : customerDetails.docCategory == 'WTA'
    //                             ? "Water Tank Automation"
    //                             : customerDetails.docCategory == 'AG'
    //                                 ? "Agriculture Automation"
    //                                 : 'Onwords Smart Solutions');

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview of Document'),
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
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: RepaintBoundary(
                key: _globalKey,
                child: QrImageView(
                  data:
                      'upi://pay?pa=onwordspay@ybl&pn=Onwords Smart Solutions&tr=&am=${grandTotal < 80000 ? grandTotal : ''}&cu=INR&mode=01&purpose=10&orgid=-&sign=-&tn=$transactionNote&note=${widget.prPoint}',
                  version: QrVersions.auto,
                  size: 200.0,
                )),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                color: ConstantColor.background1Color,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      /// Document Details
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 08, horizontal: 03),
                        height: height * .2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.black26, width: 2)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: height * 0.17,
                              width: width * .45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // border: Border.all(
                                //     color: Colors.black26, width: 1)
                              ),
                              child: Column(
                                children: [
                                  const Text('Customer Details',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                  createCustomerDetails(
                                    width,
                                    customerDetails,
                                    'Name  ',
                                    customerDetails.name,
                                    height * .02,
                                  ),
                                  const SizedBox(height: 3),
                                  createCustomerDetails(
                                    width,
                                    customerDetails,
                                    'Address  ',
                                    customerDetails.address,
                                    height * .05,
                                  ),
                                  const SizedBox(height: 3),
                                  createCustomerDetails(
                                    width,
                                    customerDetails,
                                    'Location  ',
                                    customerDetails.street,
                                    height * .02,
                                  ),
                                  createCustomerDetails(
                                    width,
                                    customerDetails,
                                    'Number  ',
                                    customerDetails.phone.toString(),
                                    height * .02,
                                  ),
                                  createCustomerDetails(
                                    width,
                                    customerDetails,
                                    'GST  ',
                                    customerDetails.gst.toString(),
                                    height * .02,
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.black,
                              width: 2,
                            ),
                            Container(
                              height: height * 0.2,
                              width: width * .47,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // border: Border.all(
                                //     color: Colors.black26, width: 1)
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('      Document Details',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                  Text(
                                      ' Doc-Type : #${customerDetails.docType}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 10)),
                                  Text(
                                      ' Category : ${customerDetails.docCategory}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 10)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                        indent: 5,
                        endIndent: 5,
                        thickness: 1,
                      ),

                      /// TABLE
                      SizedBox(
                        child: Column(
                          children: [
                            /// TABLE HEAD
                            Neumorphic(
                              margin: const EdgeInsets.only(bottom: 3),
                              style: NeumorphicStyle(
                                depth: 1,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                ),
                              ),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                height: height * .05,
                                width: width * 1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    tableHeading(
                                        width, 'Items', width * .0005, true),
                                    tableHeading(
                                        width, 'Qty', width * .0003, true),
                                    tableHeading(width, 'Unit Price',
                                        width * .0006, true),
                                    tableHeading(
                                        width, 'Total', width * .0005, false),
                                  ],
                                ),
                              ),
                            ),

                            /// TABLE CONTENT
                            Neumorphic(
                              style: NeumorphicStyle(
                                depth: 1,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  const BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)),
                                ),
                              ),
                              child: Container(
                                  height: height * .4,
                                  width: width * 1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: productDetails.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        final data = [
                                          productDetails[index].productName,
                                          productDetails[index]
                                              .productQuantity
                                              .toString(),
                                          productDetails[index]
                                              .productPrice
                                              .toString(),
                                          productDetails[index]
                                              .subTotalList
                                              .toString(),
                                        ];
                                        return Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Table(
                                              // border: TableBorder.all(color: Colors.black),

                                              children: [
                                                createTableRow(data),
                                              ]),
                                        );
                                      })),
                            ),
                            const Divider(
                              color: Colors.black,
                              indent: 5,
                              endIndent: 5,
                              thickness: 1,
                            ),
                            Container(
                              width: width * 1,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.black12, width: 2),
                              ),
                              child: Column(
                                children: [
                                  totalAmountDetails(width, height, 'Total  ',
                                      Utils.formatPrice(total.toDouble())),
                                  totalAmountDetails(
                                      width,
                                      height,
                                      'Discount ${widget.percentage} %  ',
                                      Utils.formatPrice(widget.discountAmount)),
                                  totalAmountDetails(
                                      width,
                                      height,
                                      'Sub Total  ',
                                      Utils.formatPrice(
                                          widget.finalAmountWithoutGst)),
                                  totalAmountDetails(width, height, 'CGST %  ',
                                      Utils.formatPrice(gst)),
                                  totalAmountDetails(width, height, 'SGST %  ',
                                      Utils.formatPrice(gst)),
                                  totalAmountDetails(
                                      width,
                                      height,
                                      'Grand Total  ',
                                      Utils.formatPrice(grandTotal)),
                                  totalAmountDetails(
                                      width,
                                      height,
                                      'Advanced  ',
                                      Utils.formatPrice(widget.advanceAmount)),
                                  totalAmountDetails(
                                    width,
                                    height,
                                    'Amount payable  ',
                                    Utils.formatPrice(finalTotal),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            /// PDF BUTTON
                            SizedBox(
                                width: width * 1,
                                height: height * .08,
                                child: Button('Save', () {
                                  getDocLength();
                                  _showDialog(
                                      context, customerDetails, productDetails);
                                }).button()),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget tableHeading(
      double width, String title, double widthVal, bool isTrue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: width * widthVal,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        isTrue
            ? VerticalDivider(
                color: Colors.black.withOpacity(0.4),
                endIndent: 23,
                indent: 23,
                thickness: 3,
              )
            : const SizedBox(),
      ],
    );
  }

  TableRow createTableRow(List<String> cells, {bool isHeader = false}) =>
      TableRow(
        children: cells.map(
          (cell) {
            final style = TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            );
            return Padding(
              padding: const EdgeInsets.all(8),
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

  Widget createCustomerDetails(double width, ClientModel customerDetails,
      String key, String value, double val) {
    return SizedBox(
        width: width * .6,
        height: val,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 60,
              child: Text(
                key,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 10),
              ),
            ),
            const Text(':'),
            const SizedBox(width: 10),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget totalAmountDetails(
    double width,
    double height,
    String key,
    String value,
  ) {
    return SizedBox(
        height: height * .03,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              // color: Colors.green,
              width: 150,
              child: Text(
                key,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 12),
              ),
            ),
            const Center(child: Text(':')),
            SizedBox(
              // color: Colors.transparent,
              width: 150,
              child: Text(value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 10,
                  )),
            ),
          ],
        ));
  }

  _showDialog(BuildContext context, ClientModel clientModel,
      List<ListOfTable> productDetailsModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Form(
              key: formKey,
              child: CupertinoAlertDialog(
                title: Text(
                  "Document Details\n",
                  style: TextStyle(
                      color: ConstantColor.backgroundColor,
                      fontFamily: ConstantFonts.poppinsRegular,
                      fontWeight: FontWeight.w600),
                ),
                content: Material(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFiledWidget(
                        controller: fileNameController,
                        textInputType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        hintName: 'File Name',
                        icon: const Icon(Icons.file_present),
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'File Name Required';
                          }
                          return null;
                        },
                      ).textInputFiled(),
                      const SizedBox(
                        height: 5,
                      ),
                      clientModel.docType != 'QUOTATION'
                          ? const Text(
                              '  Date For Installation',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Colors.black),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      clientModel.docType != 'QUOTATION'
                          ? TextFormField(
                              controller: estimateDateController,
                              textInputAction: TextInputAction.done,
                              maxLength: 15,
                              readOnly: true,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: ConstantFonts.poppinsRegular,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: 'Estimated Date',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: ConstantFonts.poppinsRegular,
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: ConstantFonts.poppinsRegular,
                                ),
                                border: myInputBorder(),
                                enabledBorder: myInputBorder(),
                                focusedBorder: myFocusBorder(),
                                disabledBorder: myDisabledBorder(),
                              ),
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date Required';
                                }
                                return null;
                              },
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101),
                                );

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  setState(() {
                                    estimateDateController.text =
                                        formattedDate; //set output date to TextField value.
                                  });
                                }
                              },
                            )
                          : const SizedBox(),
                    ],//
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: ConstantFonts.poppinsRegular),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: ConstantFonts.poppinsRegular),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return Center(
                                  child: SizedBox(
                                      child: Lottie.asset(
                                'assets/animations/loading.json',
                              )));
                            });
                        await _convertImage();
                        setState(() {
                          docLen = listOfDocLength.length + 1;
                        });
                        InvAndQtnPdf x = InvAndQtnPdf(
                          total: double.parse(lisTotal.toString()),
                          documentLen: docLen.toInt(),
                          subTotal: widget.finalAmountWithoutGst.toDouble(),
                          cgst: gst.toDouble(),
                          sgst: gst.toDouble(),
                          discount: widget.discountAmount.toDouble(),
                          advance: widget.advanceAmount.toDouble(),
                          grandTotal: grandTotal.toInt(),
                          needGst: widget.gstNeed,
                          amountToPay: finalTotal.toInt(),
                          percentage: widget.percentage,
                        );

                        DateTime currentPhoneDate = DateTime.now();
                        Timestamp myTimeStamp =
                            Timestamp.fromDate(currentPhoneDate);
                        final databaseReference =
                            FirebaseDatabase.instance.ref();
                        final firebaseStorage = FirebaseStorage.instance;

                        final pdfFile = await x.generate(
                            clientModel, productDetailsModel, convertedImage!);
                        final dir = await getExternalStorageDirectory();
                        final file =
                            File("${dir!.path}/${fileNameController.text}.pdf");

                        file.writeAsBytesSync(pdfFile.readAsBytesSync(),
                            flush: true);

                        OpenFile.open(file.path).then((value) async {
                          ///...............FIREBASE..........////
                          /// INVOICE OR PROFORMA_INVOICE
                          // if (clientModel.docType == "INVOICE" ||
                          //     clientModel.docType == "PROFORMA_INVOICE") {
                          //   String id = generateRandomString(5)
                          //       .toUpperCase()
                          //       .toString();
                          //   if (alreadyGeneratedId
                          //       .any((element) => element == id)) {
                          //     dev.log('Already Id Created. Create New one');
                          //     id = generateRandomString(5)
                          //         .toUpperCase()
                          //         .toString();
                          //   } else {
                          //     var snapshot = await firebaseStorage
                          //         .ref()
                          //         .child(
                          //             '${clientModel.docType}/INV${clientModel.docCategory}-${Utils.formatDummyDate(date)}${docLen.toString()}')
                          //         .putFile(pdfFile);
                          //     var downloadUrl =
                          //         await snapshot.ref.getDownloadURL();
                          //
                          //     /// INSTALLATION-INVOICE......
                          //     final installationPdfFile = await InstallationPdf(
                          //       documentLen: docLen,
                          //       estimateDate:
                          //           DateTime.parse(estimateDateController.text),
                          //     ).generate(clientModel, productDetailsModel);
                          //
                          //     var snapshotInstallation = await firebaseStorage
                          //         .ref()
                          //         .child(
                          //             'INSTALLATION-INVOICE/INV${clientModel.docCategory}-${Utils.formatDummyDate(date)}${docLen.toString()}')
                          //         .putFile(installationPdfFile);
                          //     var downloadUrlInstallation =
                          //         await snapshotInstallation.ref
                          //             .getDownloadURL();
                          //
                          //     var invoice = {
                          //       'Customer_name': clientModel.name,
                          //       'Status': 'Processing',
                          //       'TimeStamp': myTimeStamp.seconds,
                          //       'CreatedBy': staffInfo?.email,
                          //       'mobile_number': clientModel.phone,
                          //       'document_link': downloadUrl,
                          //       'installation_document_link':
                          //           downloadUrlInstallation,
                          //     };
                          //     var proformaInvoice = {
                          //       'Customer_name': clientModel.name,
                          //       'id': "#$id",
                          //       'Status': 'Processing',
                          //       'TimeStamp': myTimeStamp.seconds,
                          //       'CreatedBy': staffInfo?.email,
                          //       'mobile_number': clientModel.phone,
                          //       'document_link': downloadUrl,
                          //       'installation_document_link':
                          //           downloadUrlInstallation,
                          //     };
                          //
                          //     databaseReference
                          //         .child('QuotationAndInvoice')
                          //         .child(clientModel.docType == 'INVOICE'
                          //             ? 'INVOICE'
                          //             : 'PROFORMA_INVOICE')
                          //         .child('${Utils.formatYear(date)}')
                          //         .child('${Utils.formatMonth(date)}')
                          //         .child(
                          //             '${clientModel.docType == 'INVOICE' ? 'INV_' : 'PRO_INV_'}${clientModel.docCategory}-${Utils.formatDummyDate(date)}${docLen.toString()}')
                          //         .set(clientModel.docType == 'INVOICE'
                          //             ? invoice
                          //             : proformaInvoice);
                          //   }
                          // }
                          //
                          // /// QUOTATION
                          // else {
                          //   var snapshot = await firebaseStorage
                          //       .ref()
                          //       .child(
                          //           'QUOTATION/EST${clientModel.docCategory}-${Utils.formatDummyDate(date)}${docLen.toString()}')
                          //       .putFile(pdfFile);
                          //   var downloadUrl =
                          //       await snapshot.ref.getDownloadURL();
                          //   var quotation = {
                          //     'Customer_name': clientModel.name,
                          //     'Status': 'Processing',
                          //     'TimeStamp': myTimeStamp.seconds,
                          //     'CreatedBy': staffInfo?.email,
                          //     'mobile_number': clientModel.phone,
                          //     'document_link': downloadUrl,
                          //   };
                          //   databaseReference
                          //       .child('QuotationAndInvoice')
                          //       .child('QUOTATION')
                          //       .child('${Utils.formatYear(date)}')
                          //       .child('${Utils.formatMonth(date)}')
                          //       .child(
                          //           'EST${clientModel.docCategory}-${Utils.formatDummyDate(date)}${docLen.toString()}')
                          //       .set(quotation);
                          // }
                        }).then((value) {
                          // fileNameController.clear();
                          // listOfDocLength.clear();
                          // estimateDateController.clear();
                          // grandTotal = 0;
                          // gst = 0;
                          // Provider.of<InvoiceProvider>(context, listen: false)
                          //     .clearAllData();
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => const UserHomeScreen()),
                          //     (route) => false);
                          // // Navigator.pushNamedAndRemoveUntil(context, '/invoiceGenerator', (route) => false);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  OutlineInputBorder myInputBorder() {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.3),
          width: 2,
        ));
  }

  OutlineInputBorder myFocusBorder() {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.3),
          width: 2,
        ));
  }

  OutlineInputBorder myDisabledBorder() {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.3),
          width: 2,
        ));
  }
}

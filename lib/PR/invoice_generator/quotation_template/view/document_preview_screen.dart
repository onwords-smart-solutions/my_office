import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import '../../../../Constant/fonts/constant_font.dart';
import '../model/client_model.dart';
import '../model/list_data.dart';
import '../model/table_list.dart';
import '../model/utils.dart';
import '../pdf/inv_qtn_pdf.dart';
import '../provider/providers.dart';
import 'home_screen.dart';

class InvoicePreviewScreen extends StatefulWidget {
  final String type;

  const InvoicePreviewScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<InvoicePreviewScreen> createState() => _InvoicePreviewScreenState();
}

class _InvoicePreviewScreenState extends State<InvoicePreviewScreen> {
  final formKey = GlobalKey<FormState>();
  final date = DateTime.now();

  TextEditingController fileNameController = TextEditingController();
  TextEditingController estimateDateController = TextEditingController();

  double subTotal = 0.0;
  double grandTotal = 0.0;

  List<ListOfTable> addProducts = [];

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

  @override
  void initState() {
    dev.log(widget.type);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    widget.type == "SL-GA" ? addProducts = slidingGateData : widget.type == "SW-GA" ? addProducts = swingGateData : addProducts = smartHomeData;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    fileNameController.dispose();
    estimateDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.gstNeed) {
    //   gst = vatPercent * widget.finalAmountWithoutGst.toDouble();
    // }

    final invoiceProvider = Provider.of<Invoice1Provider>(context);
    final customerDetails = invoiceProvider.getCustomerDetails;


    if (customerDetails.docCategory == "SL-GA") {
      subTotal = slidingGateSubTotal;
    } else  if (customerDetails.docCategory == "SW-GA") {
      subTotal = swingGateSubTotal;
    }
    else if (customerDetails.docCategory == "SH") {
      subTotal = getSmartHomeSubTotal;
    }

    String transactionNote = customerDetails.docCategory.contains('-GA')
        ? "Gate Automation"
        : customerDetails.docCategory == 'SH'
            ? "Smart Home"
            : 'Onwords Smart Solutions';



    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Preview of Document',
          style: TextStyle(
            fontSize: 22,
           
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
                      'upi://pay?pa=onwordspay@ybl&pn=Onwords Smart Solutions&tr=&am=${grandTotal < 80000 ? grandTotal : ''}&cu=INR&mode=01&purpose=10&orgid=-&sign=-&tn=$transactionNote',
                  version: QrVersions.auto,
                  size: 200.0,
                ),
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
              ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
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
                          border: Border.all(color: Colors.black26, width: 2),
                      ),
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
                                Text(
                                  'Customer Details',
                                    style: TextStyle(
                                        color: Colors.black,
                                       
                                    ),
                                ),
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
                            width: 1,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('      Document Details',
                                    style: TextStyle(color: Colors.black,  ),
                                ),
                                Text(' Doc-Type : #${customerDetails.docType}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10, ),
                                ),
                                Text(
                                    ' Category : ${customerDetails.docCategory}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10, ),
                                ),
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            margin: const EdgeInsets.only(bottom: 3),
                            height: height * .05,
                            width: width * 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color:
                                  CupertinoColors.systemGrey.withOpacity(0.4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                tableHeading(
                                    width, 'Items', width * .0005, true),
                                tableHeading(width, 'Qty', width * .0003, true),
                                tableHeading(
                                    width, 'Unit Price', width * .0006, true),
                                tableHeading(
                                    width, 'Total', width * .0005, false),
                              ],
                            ),
                          ),

                          /// TABLE CONTENT
                          Container(
                              margin: const EdgeInsets.only(top: 3),
                              height: height * .4,
                              width: width * 1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    CupertinoColors.systemGrey.withOpacity(0.4),
                              ),
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: addProducts.length,
                                  itemBuilder: (BuildContext context, index) {
                                    final data = [
                                      addProducts[index].productName,
                                      addProducts[index]
                                          .productQuantity
                                          .toString(),
                                      addProducts[index]
                                          .productPrice
                                          .toString(),
                                      addProducts[index]
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
                                totalAmountDetails(width, height, 'Sub Total  ',
                                    Utils.formatPrice(subTotal)),
                                totalAmountDetails(width, height, 'CGST %  ',
                                    Utils.formatPrice(subTotal * 0.09)),
                                totalAmountDetails(width, height, 'SGST %  ',
                                    Utils.formatPrice(subTotal * 0.09)),
                                totalAmountDetails(
                                    width,
                                    height,
                                    'Grand Total  ',
                                    Utils.formatPrice(
                                        subTotal + (subTotal * .18),
                                    ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),

                          /// PDF BUTTON
                          GestureDetector(
                            onTap: () {
                              _showDialog(
                                  context, customerDetails, addProducts);
                            },
                            child: Container(
                              width: width * 0.5,
                              height: height * .06,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.white,
                                   
                                    fontSize: 20
                                      ),
                                ),
                              ),
                            ),
                          ),
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
              style: TextStyle(
                 
              ),
            ),
          ),
        ),
        isTrue
            ? const VerticalDivider(
                color: Colors.black,
                endIndent: 23,
                indent: 23,
                thickness: 2,
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
                  style: TextStyle(
                     
                  ),
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
                style: TextStyle(
                    color: Colors.black,
                   
                    fontSize: 10),
              ),
            ),
            const Text(':'),
            SizedBox(width: width * 0.02),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.black,
                   
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
    );
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
            width: width * 0.2,
            child: Text(
              key,
              style: TextStyle(
                  color: Colors.black,
                 
                  fontSize: 12,
              ),
            ),
          ),
          const Center(
            child: Text(':'),
          ),
          SizedBox(
            // color: Colors.transparent,
            width: width * 0.2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
               
              ),
            ),
          ),
        ],
      ),
    );
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
                title: const Text(
                  "Document Details\n",
                  style: TextStyle(fontSize: 16),
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
                    ], //
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return const Center(
                                child: SizedBox(
                                    child: CircularProgressIndicator()),
                              );
                            });
                        await _convertImage();
                        InvAndQtnPdf x = InvAndQtnPdf(
                          total: subTotal,
                          // cgst: (subTotal * 0.09),
                          // sgst: (subTotal * 0.09),
                          grandTotal: grandTotal.toInt(),
                          documentDate: DateTime.now(),
                        );

                        DateTime currentPhoneDate = DateTime.now();
                        // Timestamp myTimeStamp =
                        // Timestamp.fromDate(currentPhoneDate);

                        final pdfFile = await x.generate(
                            clientModel, productDetailsModel, convertedImage!);
                        final dir = await getExternalStorageDirectory();
                        final file =
                            File("${dir!.path}/${fileNameController.text}.pdf");

                        file.writeAsBytesSync(pdfFile.readAsBytesSync(),
                            flush: true);

                        OpenFile.open(file.path).then((value) async {
                          // fileNameController.clear();
                          // Provider.of<InvoiceProvider>(context,listen: false).clearAllData();
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => const ClientDetails()),
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

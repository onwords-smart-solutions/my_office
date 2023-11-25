import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_app_button.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_text_field.dart';
import 'package:my_office/features/auth/presentation/provider/authentication_provider.dart';
import 'package:my_office/features/invoice_generator/data/data_source/invoice_generator_fb_data_source.dart';
import 'package:my_office/features/invoice_generator/data/data_source/invoice_generator_fb_data_source_impl.dart';
import 'package:my_office/features/invoice_generator/data/model/invoice_generator_model.dart';
import 'package:my_office/features/invoice_generator/data/repository/invoice_generator_repo_impl.dart';
import 'package:my_office/features/invoice_generator/domain/repository/invoice_generator_repository.dart';
import 'package:my_office/features/invoice_generator/utils/list_of_table_utils.dart';
import 'package:my_office/features/user/domain/entity/user_entity.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/utilities/custom_widgets/custom_pdf_utils.dart';
import '../../../home/presentation/view/home_screen.dart';
import 'dart:ui' as ui;
import '../provider/invoice_generator_provider.dart';
import '../view_model/installation_pdf.dart';
import '../view_model/invoice_quotation_pdf.dart';

class InvoiceGeneratorPreviewScreen extends StatefulWidget {
  final double finalAmountWithoutGst;

  final double advanceAmount;
  final double discountAmount;
  final double prPoint;
  final int percentage;
  final bool gstNeed;

  const InvoiceGeneratorPreviewScreen({
    Key? key,
    required this.finalAmountWithoutGst,
    required this.advanceAmount,
    required this.gstNeed,
    required this.percentage,
    required this.discountAmount,
    required this.prPoint,
  }) : super(key: key);

  @override
  State<InvoiceGeneratorPreviewScreen> createState() =>
      _InvoiceGeneratorPreviewScreenState();
}

class _InvoiceGeneratorPreviewScreenState
    extends State<InvoiceGeneratorPreviewScreen> {
  UserEntity? staffInfo;

  final formKey = GlobalKey<FormState>();
  final date = DateTime.now();

  TextEditingController fileNameController = TextEditingController();
  TextEditingController estimateDateController = TextEditingController();
  TextEditingController documentDateController = TextEditingController();

  double vatPercent = 0.09;
  double gst = 0.0;
  double grandTotal = 0.0;
  double finalTotal = 0.0;

  int docLen = 0;
  int? lisTotal;

  List<String> listOfDocLength = [];
  List<String> alreadyGeneratedId = [];

  final GlobalKey _globalKey = GlobalKey();
  Uint8List? convertedImage;

  late InvoiceGeneratorFbDataSource invoiceGeneratorFbDataSource =
      InvoiceGeneratorFbDataSourceImpl();
  late InvoiceGeneratorRepository invoiceGeneratorRepository =
      InvoiceGeneratorRepoImpl(invoiceGeneratorFbDataSource);

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
    final docTypeProvider =
        Provider.of<InvoiceGeneratorProvider>(context, listen: false);
    docLen = 0;
    listOfDocLength.clear();
    String docType = docTypeProvider.customerDetails!.docType;
    listOfDocLength =
        await invoiceGeneratorRepository.getDocumentLengths(docType, date);
    setState(() {});
  }

  Future<void> getId() async {
    alreadyGeneratedId = await invoiceGeneratorRepository.getGeneratedIds();
    setState(() {});
  }

  String generateRandomString(int len) {
    var r = Random();
    const characters = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    return List.generate(
      len,
      (index) => characters[r.nextInt(characters.length)],
    ).join();
  }

  void getStaffDetail() async {
    final userProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    var data = userProvider.user!;
    setState(() {
      staffInfo = data;
    });
    }

  @override
  void initState() {
    documentDateController.text =
        DateFormat('yyyy-MM-dd').format(date).toString();
    getStaffDetail();
    getId();
    getDocLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gstNeed) {
      gst = vatPercent * widget.finalAmountWithoutGst.toDouble();
    }

    grandTotal = widget.finalAmountWithoutGst.toDouble() + (gst * 2);
    finalTotal = grandTotal - widget.advanceAmount;

    final invoiceProvider = Provider.of<InvoiceGeneratorProvider>(context);
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

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Preview of Document',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_rounded, color: Colors.white),
            onPressed: () async {
              DateTime? pickDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2101),
              );
              if (pickDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickDate);
                setState(() {
                  documentDateController.text =
                      formattedDate; //set output date to TextField value.
                });
              }
            },
          ),
        ],
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
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                color: AppColor.backGroundColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// Document Details
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                          vertical: 08,
                          horizontal: 03,
                        ),
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
                                  const Text(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '      Document Details',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    ' Date of Document : ${documentDateController.text.isNotEmpty ? documentDateController.text : "Select Date"}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    ' Doc-Type : #${customerDetails.docType}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    ' Category : ${customerDetails.docCategory}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              margin: const EdgeInsets.only(bottom: 3),
                              height: height * .05,
                              width: width * 1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color:
                                    CupertinoColors.systemGrey.withOpacity(0.4),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  tableHeading(
                                    width,
                                    'Items',
                                    width * .0005,
                                    true,
                                  ),
                                  tableHeading(
                                    width,
                                    'Qty',
                                    width * .0003,
                                    true,
                                  ),
                                  tableHeading(
                                    width,
                                    'Unit Price',
                                    width * .0006,
                                    true,
                                  ),
                                  tableHeading(
                                    width,
                                    'Total',
                                    width * .0005,
                                    false,
                                  ),
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
                                itemCount: productDetails.length,
                                itemBuilder: (BuildContext context, index) {
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
                                      ],
                                    ),
                                  );
                                },
                              ),
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
                                  totalAmountDetails(
                                    width,
                                    height,
                                    'Total  ',
                                    Utils.formatPrice(total.toDouble()),
                                  ),
                                  totalAmountDetails(
                                    width,
                                    height,
                                    'Discount ${widget.percentage} %  ',
                                    Utils.formatPrice(widget.discountAmount),
                                  ),
                                  totalAmountDetails(
                                    width,
                                    height,
                                    'Sub Total  ',
                                    Utils.formatPrice(
                                      widget.finalAmountWithoutGst,
                                    ),
                                  ),
                                  totalAmountDetails(
                                    width,
                                    height,
                                    'CGST %  ',
                                    Utils.formatPrice(gst),
                                  ),
                                  totalAmountDetails(
                                    width,
                                    height,
                                    'SGST %  ',
                                    Utils.formatPrice(gst),
                                  ),
                                  totalAmountDetails(
                                    width,
                                    height,
                                    'Grand Total  ',
                                    Utils.formatPrice(grandTotal),
                                  ),
                                  totalAmountDetails(
                                    width,
                                    height,
                                    'Advanced  ',
                                    Utils.formatPrice(widget.advanceAmount),
                                  ),
                                  totalAmountDetails(
                                    width,
                                    height,
                                    'Amount payable  ',
                                    Utils.formatPrice(finalTotal),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            /// PDF BUTTON
                            SizedBox(
                              width: width * .5,
                              height: height * .06,
                              child: AppButton(
                                child: const Text('Save'),
                                onPressed: () {
                                  getDocLength();
                                  _showDialog(
                                    context,
                                    customerDetails,
                                    productDetails,
                                  );
                                },
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
            ),
          ),
        ],
      ),
    );
  }

  Widget tableHeading(
    double width,
    String title,
    double widthVal,
    bool isTrue,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: width * widthVal,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(),
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
                  style: style,
                ),
              ),
            );
          },
        ).toList(),
      );

  Widget createCustomerDetails(
    double width,
    InvoiceGeneratorModel customerDetails,
    String key,
    String value,
    double val,
  ) {
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
                color: Colors.black,
                fontSize: 10,
              ),
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
            width: 150,
            child: Text(
              key,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          const Center(child: Text(':')),
          SizedBox(
            // color: Colors.transparent,
            width: 150,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showDialog(
    BuildContext context,
    InvoiceGeneratorModel clientModel,
    List<ListOfTable> productDetailsModel,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                      color: AppColor.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                  content: Material(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: fileNameController,
                          textInputType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          hintName: 'File Name',
                          icon: const Icon(Icons.file_present),
                          maxLength: 30,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'File Name Required';
                            }
                            return null;
                          },
                        ).textInputField(),
                        const SizedBox(
                          height: 5,
                        ),
                        clientModel.docType != 'QUOTATION'
                            ? const Text(
                                '  Date For Installation',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        clientModel.docType != 'QUOTATION'
                            ?  CustomTextField(
                          controller: estimateDateController,
                          textInputType: TextInputType.none,
                          textInputAction: TextInputAction.done,
                          hintName: 'Estimated Date',
                          icon: const Icon(Icons.date_range),
                          maxLength: 15,
                          readOnly: true,
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
                        ).textInputField()
                            : const SizedBox(),
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
                              return Center(
                                child: SizedBox(
                                  child: Lottie.asset(
                                    'assets/animations/loading.json',
                                  ),
                                ),
                              );
                            },
                          );
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
                            documentDate:
                                DateTime.parse(documentDateController.text),
                          );

                          DateTime currentPhoneDate = DateTime.now();
                          Timestamp myTimeStamp =
                              Timestamp.fromDate(currentPhoneDate);

                          final pdfFile = await x.generate(
                            clientModel,
                            productDetailsModel,
                            convertedImage!,
                          );
                          final dir = await getExternalStorageDirectory();
                          final file = File(
                            "${dir!.path}/${fileNameController.text}.pdf",
                          );

                          file.writeAsBytesSync(
                            pdfFile.readAsBytesSync(),
                            flush: true,
                          );

                          OpenFile.open(file.path).then((value) async {
                            ///...............FIREBASE..........////
                            /// INVOICE OR PROFORMA_INVOICE
                            if (clientModel.docType == "INVOICE" ||
                                clientModel.docType == "PROFORMA_INVOICE") {
                              String id = generateRandomString(5)
                                  .toUpperCase()
                                  .toString();
                              if (alreadyGeneratedId
                                  .any((element) => element == id)) {
                                dev.log('Already Id Created. Create New one');
                                id = generateRandomString(5)
                                    .toUpperCase()
                                    .toString();
                              } else {
                                var path =
                                    '${clientModel.docType}/${clientModel.docType == "INVOICE" ? "INV" : "PRO_INV"}${clientModel.docCategory}-${Utils.formatDummyDate(date)}${docLen.toString()}';
                                var downloadUrl =
                                    await invoiceGeneratorRepository
                                        .uploadDocumentAndGetUrl(path, pdfFile);

                                /// INSTALLATION-INVOICE......
                                final installationPdfFile =
                                    await InstallationPdf(
                                  documentLen: docLen,
                                  estimateDate: DateTime.parse(
                                    estimateDateController.text,
                                  ),
                                ).generate(clientModel, productDetailsModel);

                                var downloadUrlInstallation =
                                    await invoiceGeneratorRepository
                                        .uploadInstallationInvoice(
                                  installationPdfFile,
                                  clientModel.docCategory,
                                  date,
                                  docLen,
                                );

                                var invoice = {
                                  'Customer_name': clientModel.name,
                                  'Status': 'Processing',
                                  'TimeStamp': myTimeStamp.seconds,
                                  'CreatedBy': staffInfo!.email,
                                  'mobile_number': clientModel.phone,
                                  'document_link': downloadUrl,
                                  'installation_document_link':
                                      downloadUrlInstallation,
                                };
                                var proformaInvoice = {
                                  'Customer_name': clientModel.name,
                                  'id': "#$id",
                                  'Status': 'Processing',
                                  'TimeStamp': myTimeStamp.seconds,
                                  'CreatedBy': staffInfo!.email,
                                  'mobile_number': clientModel.phone,
                                  'document_link': downloadUrl,
                                  'installation_document_link':
                                      downloadUrlInstallation,
                                };

                                void saveDocument(
                                  InvoiceGeneratorModel clientModel,
                                  DateTime date,
                                  int docLen,
                                ) {
                                  dynamic document =
                                      clientModel.docType == 'INVOICE'
                                          ? invoice
                                          : proformaInvoice;
                                  invoiceGeneratorRepository
                                      .setDocument(
                                    clientModel,
                                    date,
                                    document,
                                    docLen,
                                  )
                                      .then((_) {
                                    // Handle success
                                  }).catchError((error) {
                                    Exception(
                                      'Caught error while uploading invoice/ proforma invoice in db! $error',
                                    );
                                  });
                                }

                                saveDocument(
                                  clientModel,
                                  date,
                                  docLen,
                                );
                              }
                            }

                            /// QUOTATION
                            else {
                              var downloadUrl = await invoiceGeneratorRepository
                                  .uploadQuotation(
                                pdfFile,
                                clientModel.docCategory,
                                date,
                                docLen,
                              );

                              var quotation = {
                                'Customer_name': clientModel.name,
                                'Status': 'Processing',
                                'TimeStamp': myTimeStamp.seconds,
                                'CreatedBy': staffInfo!.email,
                                'mobile_number': clientModel.phone,
                                'document_link': downloadUrl,
                              };

                              Future<void> createQuotation(
                                DateTime date,
                                InvoiceGeneratorModel clientModel,
                                dynamic quotation,
                              ) async {
                                await invoiceGeneratorRepository.saveQuotation(
                                  date,
                                  clientModel,
                                  quotation,
                                  docLen,
                                );
                              }

                              createQuotation(date, clientModel, quotation);
                            }
                          }).then((value) {
                            fileNameController.clear();
                            listOfDocLength.clear();
                            estimateDateController.clear();
                            grandTotal = 0;
                            gst = 0;
                            Provider.of<InvoiceGeneratorProvider>(
                              context,
                              listen: false,
                            ).clearAllData();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const UserHomeScreen(),
                              ),
                              (route) => false,
                            );
                            // Navigator.pushNamedAndRemoveUntil(context, '/InvoicePreviewScreen', (route) => false);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

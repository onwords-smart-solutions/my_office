import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:my_office/PR/invoice/Screens/Add_iterms_Screen.dart';
import 'package:my_office/PR/invoice/api/installation_pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';
import '../../../database/hive_operations.dart';
import '../../../home/user_home_screen.dart';
import '../../../models/staff_model.dart';
import '../../products/point_calculations.dart';
import '../api/pdf_invoice_api.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import '../provider_page.dart';
import '../utils.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class PreviewScreen extends StatefulWidget {
  final String docType;
  final String category;
  final int advanceAmt;

  final List<TableList> productDetails;
  final int finalAmount;
  final int listAmount;

  // final int labAndInstall;
  final int discountAmount;
  final bool gstValue;

  // final bool labValue;
  // final bool discountNeed;

  const PreviewScreen({
    Key? key,
    required this.docType,
    required this.category,
    required this.advanceAmt,
    // required this.labAndInstall,
    required this.gstValue,
    required this.discountAmount,
    // required this.discountNeed,
    required this.productDetails,
    required this.finalAmount,
    required this.listAmount,

    // required this.labValue,
  }) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final HiveOperations _hiveOperations = HiveOperations();
  StaffModel? staffInfo;
  final databaseReference = FirebaseDatabase.instance.ref();

  void getStaffDetail() async {
    final data = await _hiveOperations.getStaffDetail();
    setState(() {
      staffInfo = data;
    });
  }

  bool isVisible = false;
  final GlobalKey _globalKey = GlobalKey();
  Uint8List? convertedImage;

  Future<void> _convertImage() async {
    // print('called function _convertImage()');
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 10.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    // print('inside  Data is $convertedImage');
    setState(() {
      convertedImage = pngBytes;
    });

    // print('out side Data after is $convertedImage');
  }

  // double amount = 0.0;
  // double subTotal = 0.0;
  double amount = 0.0;
  double subTotal = 0.0;
  double gst = 0.0;
  double grandTotal = 0.0;

  int advance = 0;
  int labour = 0;

  int discount = 0;

  final date = DateTime.now();
  late SharedPreferences logData;
  TextEditingController accountName = TextEditingController();
  TextEditingController accountNo = TextEditingController();
  TextEditingController ifsc = TextEditingController();
  TextEditingController bank = TextEditingController();
  TextEditingController fileName = TextEditingController();
  TextEditingController quotNo = TextEditingController();

  TextEditingController estimateDate = TextEditingController();

  String supplierName = " ";
  String supplierStreet = " ";
  String supplierAddress = " ";
  int supplierPhone = 0;
  String supplierEmail = " ";
  String supplierWebsite = " ";
  String supplierGst = " ";

  // User? user;
  late DateTime currentPhoneDate;

  // var dataJson;
  final formKey = GlobalKey<FormState>();
  List quotLength = [];
  int quotLen = 0;
  NumberFormat formatter = NumberFormat("000");

  readData() async {
    logData = await SharedPreferences.getInstance();
    setState(() {
      // user = UserPreferences.getUser();
      // supplierName = logData.getString('ownerName')!;
      // supplierStreet = logData.getString('ownerStreet')!;
      // supplierAddress = logData.getString('ownerAddress')!;
      // supplierWebsite = logData.getString('ownerWebsite')!;
      // supplierEmail = logData.getString('ownerEmail')!;
      // supplierGst = logData.getString('ownerGst')!;
      // supplierPhone = logData.getInt('ownerPhone')!;
      accountName.text = "Onwords";
      accountNo.text = "5020-0065-403656";
      ifsc.text = "HDFC0000787";
      bank.text = "HDFC";
      // labour = widget.labAndInstall;
      // discount = widget.discountAmount;
      // advance = widget.advanceAmt;
    });
  }

  Future<void> fireData() async {
    quotLen = 0;
    quotLength.clear();

    databaseReference.child('QuotationAndInvoice').once().then((snap) async {
      try {
        for (var element in snap.snapshot.children) {
          // print("dataJson ${element.key} ");
          if (widget.docType == element.key) {
            // print("dataJson ${widget.docType} ");
            for (var elem in element.children) {
              for (var ele in elem.children) {
                // print(ele.key);
                if (ele.key == Utils.formatMonth(date)) {
                  for (var el in ele.children) {
                    quotLength.add(el.key);
                    // print('length ${quotLength.length}');
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        // print(e);
      }
    });
  }

  List alreadyGeneratedId = [];

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
    const characters =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    return List.generate(
        len, (index) => characters[r.nextInt(characters.length)]).join();
  }

  @override
  void initState() {
    getStaffDetail();
    getId();
    fireData();
    readData();
    super.initState();
  }
  @override
  void dispose() {
    estimateDate.dispose();
    quotNo.dispose();
    fileName.dispose();
    bank.dispose();
    ifsc.dispose();
    accountNo.dispose();
    accountName.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<TaskData>(builder: (context, taskData, child) {
      final task =
          taskData.tasks.length == 2 ? taskData.tasks[1] : taskData.tasks[0];
      final invoice = taskData.invoiceListData;
      final val = taskData.subTotalValue;
      // if (val.isEmpty) {
      if (widget.finalAmount.toDouble().toString().isEmpty) {
        // dev.log(" ");
      } else {
        // amount = val
        //     .map((e) => e.quantity * e.amount)
        //     .reduce((value, element) => value + element);
        amount = widget.finalAmount.toDouble();
        // dev.log('final amount  $amount');
        // dev.log('list amount  ${widget.listAmount}');
        const vatPercent = 0.09;
        if (widget.gstValue) {
          gst = vatPercent * amount;
        }
        // grandTotal = amount + (gst * 2) - advance;
        // grandTotal = amount + labour + (gst*2) - advance;
        grandTotal =
            // amount - widget.discountAmount + (gst * 2) - widget.advanceAmt;
            amount + (gst * 2) - widget.advanceAmt;
      }

      // final double a = grandTotal = amount - discount + (gst * 2) - advance;

      // print('grand total is $grandTotal');

      final upiDetails = UPIDetails(
          upiID: "onwordspay@ybl",
          payeeName: "Onwords Smart Solutions",
          amount: grandTotal < 80000 ? grandTotal : null,
          transactionNote: widget.category == 'GA'
              ? "Gate Automation"
              : widget.category == 'SH'
                  ? "Smart Home"
                  : widget.category == 'IT'
                      ? "APP or Web Development"
                      : widget.category == 'DL'
                          ? "Door Lock"
                          : widget.category == 'SS'
                              ? "Security System"
                              : widget.category == 'WTA'
                                  ? "Water Tank Automation"
                                  : widget.category == 'AG'
                                      ? "Agriculture Automation"
                                      : 'Onwords Smart Solutions');

      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffDDE6E8),
          elevation: 0,
          title: Text(
            "Invoice Preview",
            style: TextStyle(
                fontFamily: '',
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: height * 0.018),
          ),
          centerTitle: true,
          leading: GestureDetector(
            child: Image.asset(
              'assets/back arrow.png',
              scale: 2.3,
              color: const Color(0xff00bcd4),
            ),
            onTap: () {
              setState(() {
                Navigator.pop(context);
              });
            },
          ),

        ),
        backgroundColor: const Color(0xffDDE6E8),
        body: Form(
          key: formKey,
          child: Stack(
            children: [
              Positioned(
                top: 5,
                left: 0,
                right: 0,
                child: RepaintBoundary(
                  key: _globalKey,
                  child: UPIPaymentQRCode(
                    upiDetails: upiDetails,
                    size: 300,
                  ),
                ),
              ),
              Positioned(
                top: 5,
                left: 0,
                right: 0,
                child: Container(
                  color: const Color(0xffDDE6E8),
                  height: height * 1.0,
                  width: width * 1.0,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${widget.docType} ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.018,
                              fontFamily: '',
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(05),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black26,
                                    width: width * 0.002),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Date : ${DateFormat("dd.MM.yyyy").format(date)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: height * 0.012,
                                        fontFamily: '',
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: height * 0.050,
                                    width: width * 0.25,
                                    child: TextFormField(
                                      textInputAction: TextInputAction.done,
                                      controller: fileName,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'File Name required';
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: height * 0.012,
                                        fontFamily: '',
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        // border: InputBorder.none,
                                        hintText: 'File Name',
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.012,
                                          fontFamily: '',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            widget.docType == "QUOTATION"
                                ? Container()
                                : Container(
                                    padding: const EdgeInsets.all(05),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black26,
                                          width: width * 0.002),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Estimate Date For Installation',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: height * 0.012,
                                              fontFamily: '',
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: height * 0.050,
                                          width: width * 0.25,
                                          child: TextFormField(

                                            textInputAction:
                                                TextInputAction.done,
                                            controller: estimateDate,
                                            keyboardType:
                                                TextInputType.datetime,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Date required';
                                              }
                                              return null;
                                            },
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: height * 0.012,
                                              fontFamily: '',
                                            ),
                                            readOnly: true,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              // border: InputBorder.none,
                                              hintText: 'Estimate Date',
                                              hintStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: height * 0.012,
                                                fontFamily: '',
                                              ),
                                            ),
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
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
                                                  estimateDate.text =
                                                      formattedDate; //set output date to TextField value.
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Text(
                          "Bill To",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.013,
                              fontFamily: '',
                              color: Colors.black,
                          ),
                        ),
                        Text(
                          task.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              // fontSize: height * 0.018,
                              fontFamily: '',
                              color: Colors.black),
                        ),
                        Text(
                          "${task.street},${task.address}",
                          style: const TextStyle(
                              // fontWeight: FontWeight.w600,
                              // fontSize: height * 0.011,
                              fontFamily: '',
                              color: Colors.black),
                        ),
                        Text(
                          task.gst,
                          style: const TextStyle(
                              // fontWeight: FontWeight.w600,
                              // fontSize: height * 0.011,
                              fontFamily: '',
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          width: width * 0.9,
                          height: height * 0.06,
                          decoration: BoxDecoration(
                              color: const Color(0xff00bcd4),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Table(
                              children: [
                                buildRow(
                                    ['s.no', 'Items', 'Qty', 'Rate', 'Amount']),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          width: width * 0.9,
                          height: height * 0.4,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xff00bcd4), width: 1.0),
                              color: const Color(0xffDDE6E8),
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 5.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: widget.productDetails.length,
                              itemBuilder: (BuildContext context, int index) {
                                final amount = widget
                                        .productDetails[index].productQuantity *
                                    int.parse(widget
                                        .productDetails[index].productPrice);
                                // dev.log(amount);
                                return Table(
                                  // border: TableBorder.symmetric(inside: BorderSide.none,outside: BorderSide(width: 1.0)),
                                  children: [
                                    buildRow([
                                      '${index + 1}.',
                                      widget.productDetails[index].productName,
                                      widget
                                          .productDetails[index].productQuantity
                                          .toString(),
                                      widget.productDetails[index].productPrice,
                                      amount.toString(),
                                      // (invoice[index].description),
                                      // '${invoice[index].quantity}',
                                      // '${invoice[index].unitPrice}',
                                      // '${invoice[index].quantity * invoice[index].unitPrice}'
                                    ]),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 30,
                          ),
                          width: width * 0.9,
                          // color: Colors.cyanAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  List<InvoiceItem> invoiceData = [];
                                  final isValid =
                                      formKey.currentState?.validate();
                                  if (isValid!) {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        });
                                    await _convertImage();

                                    final date = DateTime.now();
                                    setState(() {
                                      quotLen = quotLength.length + 1;
                                    });
                                    for (var item in widget.productDetails) {
                                      final data = InvoiceItem(
                                          description: item.productName,
                                          quantity: item.productQuantity,
                                          unitPrice:
                                              double.parse(item.productPrice.toString()));
                                      invoiceData.add(data);
                                    }

                                    final invoice = Invoice(
                                      // labNeed: widget.labValue,
                                      // discountNeed: widget.discountNeed,
                                      gstNeed: widget.gstValue,
                                      quotNo: formatter.format(quotLen),
                                      fileName: fileName.text,
                                      supplier: Supplier(
                                        gst: supplierGst,
                                        name: supplierName,
                                        street: supplierStreet,
                                        address: supplierAddress,
                                        phone: supplierPhone,
                                        email: supplierEmail,
                                        website: supplierWebsite,
                                      ),
                                      customer: Customer(
                                        name: task.name,
                                        street: task.street,
                                        address: task.address,
                                        phone: task.phone,
                                        gst: task.gst,
                                      ),
                                      info: InvoiceInfo(
                                        date: date,
                                        // dueDate: dueDate,
                                        // description: 'Description...',
                                        // number: '${DateTime.now().year}-9999',
                                      ),
                                      // items: taskData.invoiceListData,
                                      items: invoiceData,
                                      docType: widget.docType,
                                      cat: widget.category,
                                      advancePaid: widget.advanceAmt,
                                      // labAndInstall: widget.labAndInstall,
                                      accountName: accountName.text,
                                      accountNumber: accountNo.text,
                                      ifscCode: ifsc.text,
                                      bankName: bank.text,
                                      discountAmount: widget.discountAmount,
                                      estimateDate: estimateDate.text,
                                    );

                                    currentPhoneDate = DateTime.now();
                                    Timestamp myTimeStamp =
                                        Timestamp.fromDate(currentPhoneDate);
                                    final databaseReference =
                                        FirebaseDatabase.instance.ref();
                                    final firebaseStorage =
                                        FirebaseStorage.instance;

                                    log(widget.finalAmount);
                                    log(widget.discountAmount);
                                    log(widget.advanceAmt);
                                    log(grandTotal);
                                    dev.log(Utils.formatPrice(gst),);

                                    PdfInvoiceApi x = PdfInvoiceApi(
                                        subTotal: widget.finalAmount,
                                        cgst: gst.toInt(),
                                        sgst: gst.toInt(),
                                        discount: widget.discountAmount,
                                        advance: widget.advanceAmt,
                                        granTotal: grandTotal.toInt(),
                                    );

                                    final pdfFile =
                                        await x.generate(
                                            invoice,
                                            // user!,
                                            convertedImage!);
                                    // log('path is ${pdfFile.path}');

                                    final dir =
                                        await getExternalStorageDirectory();
                                    final file = File(
                                        '${dir!.path}/${fileName.text}.pdf');
                                    file.writeAsBytesSync(
                                        pdfFile.readAsBytesSync(),
                                        flush: true);
                                    // log('new path is ${file.path} and absolute is ${file.absolute.path}');
                                    await OpenFile.open(file.path)
                                        .then((value) async {
                                      ///...............FIREBASE..........////
                                      /// INVOICE
                                      if (widget.docType == "INVOICE") {
                                        /// FINAL INVOICE
                                        var snapshot = await firebaseStorage
                                            .ref()
                                            .child(
                                                'INVOICE/INV${widget.category}-${Utils.formatDummyDate(date)}${formatter.format(quotLen)}')
                                            .putFile(pdfFile);
                                        var downloadUrl =
                                            await snapshot.ref.getDownloadURL();

                                        /// INSTALLATION-INVOICE......
                                        final installationPdfFile =
                                            await InstallationInvoicePdf
                                                .generate(
                                          invoice,
                                          // user,
                                        );

                                        var snapshotInstallation =
                                            await firebaseStorage
                                                .ref()
                                                .child(
                                                    'INSTALLATION-INVOICE/INV${widget.category}-${Utils.formatDummyDate(date)}${formatter.format(quotLen)}')
                                                .putFile(installationPdfFile);
                                        var downloadUrlInstallation =
                                            await snapshotInstallation.ref
                                                .getDownloadURL();

                                        var da = {
                                          'Customer_name': task.name,
                                          'Status': 'Processing',
                                          'TimeStamp': myTimeStamp.seconds,
                                          'CreatedBy': staffInfo?.email,
                                          'mobile_number': task.phone,
                                          'document_link': downloadUrl,
                                          'installation_document_link':
                                              downloadUrlInstallation,
                                        };
                                        databaseReference
                                            .child('QuotationAndInvoice')
                                            .child('INVOICE')
                                            .child('${Utils.formatYear(date)}')
                                            .child('${Utils.formatMonth(date)}')
                                            .child(
                                                'INV${widget.category}-${Utils.formatDummyDate(date)}${formatter.format(quotLen)}')
                                            .set(da);
                                      }

                                      /// PROFORMA_INVOICE
                                      else if (widget.docType ==
                                          "PROFORMA_INVOICE") {
                                        String id = generateRandomString(5)
                                            .toUpperCase()
                                            .toString();
                                        if (alreadyGeneratedId
                                            .any((element) => element == id)) {
                                          dev.log(
                                              'Already Id Created. Create New one');
                                          id = generateRandomString(5)
                                              .toUpperCase()
                                              .toString();
                                        } else {
                                          dev.log('Create New Id');
                                          var snapshot = await firebaseStorage
                                              .ref()
                                              .child(
                                                  'PROFORMA_INVOICE/PROFORMA_INV${widget.category}-${Utils.formatDummyDate(date)}${formatter.format(quotLen)}')
                                              .putFile(pdfFile);
                                          var downloadUrl = await snapshot.ref
                                              .getDownloadURL();

                                          /// INSTALLATION-INVOICE......
                                          final installationPdfFile =
                                              await InstallationInvoicePdf
                                                  .generate(
                                            invoice,
                                            // user,
                                          );

                                          var snapshotInstallation =
                                              await firebaseStorage
                                                  .ref()
                                                  .child(
                                                      'INSTALLATION-INVOICE/INV${widget.category}-${Utils.formatDummyDate(date)}${formatter.format(quotLen)}')
                                                  .putFile(installationPdfFile);
                                          var downloadUrlInstallation =
                                              await snapshotInstallation.ref
                                                  .getDownloadURL();

                                          var da = {
                                            'Customer_name': task.name,
                                            'id': "#$id",
                                            'Status': 'Processing',
                                            'TimeStamp': myTimeStamp.seconds,
                                            'CreatedBy': staffInfo?.email,
                                            'mobile_number': task.phone,
                                            'document_link': downloadUrl,
                                            'installation_document_link':
                                                downloadUrlInstallation,
                                          };
                                          databaseReference
                                              .child('QuotationAndInvoice')
                                              .child('PROFORMA_INVOICE')
                                              .child(
                                                  '${Utils.formatYear(date)}')
                                              .child(
                                                  '${Utils.formatMonth(date)}')
                                              .child(
                                                  'PROFORMA_INV${widget.category}-${Utils.formatDummyDate(date)}${formatter.format(quotLen)}')
                                              .set(da);
                                        }
                                      }

                                      /// QUOTATION
                                      else {
                                        var snapshot = await firebaseStorage
                                            .ref()
                                            .child(
                                                'QUOTATION/EST${widget.category}-${Utils.formatDummyDate(date)}${formatter.format(quotLen)}')
                                            .putFile(pdfFile);
                                        var downloadUrl =
                                            await snapshot.ref.getDownloadURL();
                                        var da = {
                                          'Customer_name': task.name,
                                          'Status': 'Processing',
                                          'TimeStamp': myTimeStamp.seconds,
                                          'CreatedBy': staffInfo?.email,
                                          'mobile_number': task.phone,
                                          'document_link': downloadUrl,
                                        };
                                        databaseReference
                                            .child('QuotationAndInvoice')
                                            .child('QUOTATION')
                                            .child('${Utils.formatYear(date)}')
                                            .child('${Utils.formatMonth(date)}')
                                            .child(
                                                'EST${widget.category}-${Utils.formatDummyDate(date)}${formatter.format(quotLen)}')
                                            .set(da);
                                      }

                                      fileName.clear();
                                      quotNo.clear();
                                      estimateDate.clear();
                                    }).then((value) => {
                                              setState(() {
                                                /// if(!mounted) return;
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              const UserHomeScreen(),
                                                        ),
                                                        (route) => false);
                                                Provider.of<TaskData>(context,
                                                        listen: false)
                                                    .invoiceListData
                                                    .clear();
                                                Provider.of<TaskData>(context,
                                                        listen: false)
                                                    .value
                                                    .clear();
                                                Provider.of<TaskData>(context,
                                                        listen: false)
                                                    .deleteCustomerDetails(0);
                                              }),
                                            });
                                  } else {
                                    showSnackBar(
                                        message: 'Please Fill All Filed',
                                        color: Colors.red);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  width: 130,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    // color: const Color(0xffFF7E44),
                                    color: const Color(0xff00bcd4),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: const Offset(8, 8),
                                          blurRadius: 10,
                                          spreadRadius: 0)
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Save As',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            fontFamily: '',
                                            color: Colors.white),
                                      ),
                                      Image.asset(
                                        'assets/pdf.png',
                                        scale: 3.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Sub Total :  ${widget.finalAmount}",
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  widget.gstValue
                                      ? Text(
                                          "IGST 9% : ${Utils.formatPrice(gst)}",
                                          style: const TextStyle(fontSize: 10),
                                        )
                                      : Text(
                                          "IGST 9% : ${Utils.formatPrice(0.0)}",
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                  widget.gstValue
                                      ? Text(
                                          "CGST  9% : ${Utils.formatPrice(gst)}",
                                          style: const TextStyle(fontSize: 10),
                                        )
                                      : Text(
                                          "IGST 9% : ${Utils.formatPrice(0.0)}",
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                  Text(
                                    "Discount :        ${widget.discountAmount}",
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    "Advance :       ${widget.advanceAmt}",
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    "Grand Total  : $grandTotal",
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // if (isVisible)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
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
              style: const TextStyle(fontFamily: ''),
            ),
          ),
        ),
      ),
    );
  }

  TableRow buildRow(List<String> cells, {bool isHeader = false}) => TableRow(
        children: cells.map(
          (cell) {
            const style = TextStyle(
              color: Colors.black,
            );
            return Padding(
              padding: const EdgeInsets.all(1),
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
}

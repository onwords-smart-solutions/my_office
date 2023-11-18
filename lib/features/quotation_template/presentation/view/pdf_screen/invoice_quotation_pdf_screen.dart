import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '../../../../../core/utilities/custom_widgets/custom_main_pdf.dart';
import '../../../../../core/utilities/custom_widgets/custom_utils.dart';
import '../../../model/client_model.dart';
import '../../../utils/list_of_table_utils.dart';

class InvAndQtnPdf {
  late double total;
  late int grandTotal;
  late DateTime documentDate;

  InvAndQtnPdf({
    required this.total,
    required this.grandTotal,
    required this.documentDate,
  });

  Future<File> generate(
    ClientModel clientModel,
    List<ListOfTable> productDetailsModel,
    Uint8List pic,
  ) async {
    final pdf = Document();

    var assetImage = pw.MemoryImage(
      (await rootBundle.load('assets/logo1.png')).buffer.asUint8List(),
    );

    final qrImage = pw.MemoryImage(pic);

    pdf.addPage(
      MultiPage(
        header: (context) => buildLogo(
          assetImage,
          clientModel,
        ),
        build: (context) => [
          SizedBox(height: 2 * PdfPageFormat.mm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              supplierDetails(),
              SizedBox(width: 30 * PdfPageFormat.mm),
              customerDetails(clientModel),
            ],
          ),
          SizedBox(height: 3 * PdfPageFormat.mm),
          productTable(productDetailsModel),
          Divider(),
          totalAmountDetails(
            total,
            // cgst,
            // sgst,
            grandTotal,
            qrImage,
            clientModel,
          ),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '** NOTE : GST & LABOUR COST WILL BE CHARGED SEPARATELY **',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: PdfColors.red,
                ),
              ),
            ],
          ),
          buildTermsAndConditions(clientModel),
        ],
        footer: (context) => buildFooter(clientModel),
      ),
    );
    return MainPDFClass.saveDocument(
      fileName: '${clientModel.name}.${clientModel.docType}.pdf',
      pdf: pdf,
    );
  }

  Widget buildLogo(MemoryImage img, ClientModel customerDetails) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(top: -30),
                height: 100, //150,
                width: 100, //150,
                child: pw.Image(img),
              ),
              Container(
                margin: const EdgeInsets.only(top: -20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'QUOTATION',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: PdfColors.red500,
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      "Date :  ${Utils.formatDate(documentDate)}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "#EST${customerDetails.docCategory}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );

  Widget builderQR(pw.MemoryImage img) {
    return Container(
      margin: const EdgeInsets.only(left: -7),
      height: 100, //150,
      width: 80, //150,
      child: pw.Image(img),
    );
  }

  Widget buildPaidImg(MemoryImage img) {
    return Container(
      margin: const EdgeInsets.only(left: -7),
      height: 100, //150,
      width: 80, //150,
      child: pw.Image(img),
    );
  }

  Widget customerDetails(ClientModel customerDetails) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          createText('To', customerDetails.name, false, 10, 0),
          SizedBox(height: 3),
          createText('Address', customerDetails.address, false, 10, 0),
          SizedBox(height: 3),
          createText('Location', customerDetails.street, false, 10, 0),
          createText('Phone', customerDetails.phone.toString(), false, 10, 0),
          SizedBox(height: 1 * PdfPageFormat.mm),
          customerDetails.gst.toString().isNotEmpty
              ? createText(
                  'GSTIN',
                  customerDetails.gst.toString(),
                  false,
                  10,
                  0,
                )
              : SizedBox.shrink(),
        ],
      );

  Widget supplierDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          createText('From', 'Onwords Smart Solutions', false, 10, 0),
          SizedBox(height: 3),
          createText('Address', '1/1 RR Garden, Zamin Muthur,', false, 10, 0),
          SizedBox(height: 3),
          createText(
            'Location',
            'Pollachi, Coimbatore,\nTamilNadu - 642 005',
            false,
            10,
            0,
          ),
          SizedBox(height: 3),
          createText('Phone', '+91 7708630275', false, 10, 0),
          createText('Email', 'cs@onwords.in', false, 10, 0),
          createText('Website', 'www.onwords.in', false, 10, 0),
          createText('GSTIN', '33BTUPN5784J1ZT', false, 10, 0),
        ],
      );

  Widget productTable(List<ListOfTable> productDetailsModel) {
    final headers = ['Products Name', 'Quantity', 'Unit Price', 'Total'];

    final data = productDetailsModel.map((item) {
      return [
        item.productName,
        item.productQuantity,
        item.productPrice,
        item.subTotalList,
      ];
    }).toList();
    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      cellStyle: const TextStyle(fontSize: 9),
      border: const TableBorder(),
      headerStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 10,
        color: PdfColors.white,
      ),
      headerDecoration: const BoxDecoration(color: PdfColors.red700),
      cellHeight: 25,
      columnWidths: {
        0: const FixedColumnWidth(230.0), // fixed to 100 width
        1: const FlexColumnWidth(50.0),
        2: const FixedColumnWidth(80.0), //fixed to 100 width
        3: const FixedColumnWidth(80.0), //fixed to 100 width
      },
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
      oddRowDecoration: const BoxDecoration(color: PdfColors.red50),
    );
  }

  Widget totalAmountDetails(
    double total,
    int grandTotal,
    pw.MemoryImage img,
    ClientModel customerDetails,
  ) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bankDetails(builderQR(img), customerDetails),
          SizedBox(width: 120),
          Expanded(
            // flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                finalTotal(
                  'Total',
                  Utils.formatPrice(total.toDouble()),
                  false,
                  10,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, width: 180, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, width: 180, color: PdfColors.grey400),
                SizedBox(height: 0.8 * PdfPageFormat.mm),
                finalTotal('Grand Total', Utils.formatPrice(total), true, 12),
                SizedBox(height: 0.8 * PdfPageFormat.mm),
                Container(height: 1, width: 180, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, width: 180, color: PdfColors.grey400),
                SizedBox(height: 2 * PdfPageFormat.mm),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bankDetails(Widget qr, ClientModel customerDetails) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          createText('Acc.Name', 'Onwords', false, 10, 0),
          createText('Bank', 'HDFC', false, 10, 0),
          createText('Acc.No', '50-2000-6540-3656', false, 10, 0),
          createText('IFSC Code', 'HDFC0000787', false, 10, 0),
          createText('UPI', 'onwordspay@ybl', false, 10, 0),
          SizedBox(height: 3 * PdfPageFormat.mm),
          Row(
            children: [
              createText('Scan To Pay', '', true, 10, 0),
              SizedBox(width: 1 * PdfPageFormat.mm),
              qr,
            ],
          ),
        ],
      );

  Widget buildFooter(ClientModel customerDetails) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildBodyText("In Sync with the Smarter World", true),
          SizedBox(height: 1 * PdfPageFormat.mm),
          // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
        ],
      );

  Widget buildTermsAndConditions(
    ClientModel customerDetails,
  ) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customerDetails.docCategory.contains('-GA')
              ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildBodyText("Terms and Conditions", true),
                      buildBodyText(
                        "It is recommended by the Company to use INVERTER (UPS) of 1KVA for our control modules and theSame shall be in Client's  Scope.",
                        true,
                      ),
                      buildBodyText(
                        "The following facilities and services are to be provided by the client.",
                        true,
                      ),
                      buildBodyText(
                        "1. Site Preparation including fabricator,carpentry, welder, civil and Masonry work.\n"
                        "2. Provision for suitable Wiring, Electricity Supply with suitable plugs, socket etc.\n"
                        "3. Cable identification and Termination of the cables laid by Client's Contractor on the Distribution Board etc. Dedicated Earth Connection required.\n"
                        "4. Wire cost and material cost, other than motor and control box which comes within the package.",
                        false,
                      ),
                      Center(
                        child: buildBodyText(
                          "*** Any additional work on behalf of client  will be quoted extra separately ***",
                          true,
                        ),
                      ),
                      buildBodyText("Warranty:", true),
                      buildBodyText(
                        'Service and replacement warranty will be provided for the products up to 1 year from the date of installation.',
                        false,
                      ),
                      buildBodyText(
                        'The warranty will cover the failures for the following reasons:',
                        true,
                      ),
                      buildBodyText(
                        "1. Defects caused at the time of installation; \n"
                        "2. Defects caused by manufacture; \n"
                        "3. Defects caused by application / programming; \n",
                        false,
                      ),
                      buildBodyText(
                        'The warranty will not cover the failures for the following reasons:',
                        true,
                      ),
                      buildBodyText(
                        "1. Damage or defect caused by transportation, accident, misuse, lack of maintenance, improper usage or negligence on the part of Client; \n"
                        "2. Wilful damage or negligence, normal wear and tear;\n"
                        "Abuse or misuse of equipment/product;\n"
                        "3. Damage or defect caused by  earthquake  or other similar natural disasters;\n"
                        "4. Damage or defect caused by alteration, modification, conversion not authorised by Company in writing;\n"
                        "5. Repairs carried out by personnel other than Company's authorised service personnel's;\n"
                        "6. Defects or damages due to any other external means or causes are not covered under warranty.",
                        false,
                      ),
                      buildBodyText("Payment:", true),
                      buildBodyText(
                        "50% of order amount should be paid as advance, balance 50% should be paid at the date of installation, There should not be any negotiation in final payment before handing over the Remote and other accessories.",
                        false,
                      ),
                      buildBodyText("Delivery Period:", true),
                      buildBodyText(
                        "1-2 weeks after receipt of commercially & technically clear order with advance of 50%.",
                        false,
                      ),
                      buildBodyText("Cancellation of Order: ", true),
                      buildBodyText(
                        "If the Order placed is cancelled by Client then the cancellation charges of 30% of the Order value shall be charged as  a Termination fee.",
                        false,
                      ),
                      buildBodyText("Scope of Work: ", true),
                      buildBodyText(
                        "1. Instruction and Supervision of conduit work at the initial level and there after completion of conduit work and wiring  work  final inspection will be done.\n"
                        "2. Once the contractor finishes the Electrical work and civil work, we will start Installation of GateAutomation Modules.\n"
                        "3. Programming of all the above mentioned components.\n"
                        "4. Delivery to the client and mobile application integration if needed.",
                        false,
                      ),
                    ],
                  ),
                )
              : customerDetails.docCategory == 'SS'
                  ? Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildBodyText("Terms and Conditions", true),
                          buildBodyText(
                            "It is recommended by the Company to use INVERTER (UPS) of 1KVA for our control modules and theSame shall be in Client's  Scope.",
                            true,
                          ),
                          buildBodyText(
                            "The following facilities and services are to be provided by the client.",
                            true,
                          ),
                          buildBodyText(
                            "1. Site Preparation including fabricator,carpentry, welder, civil and Masonry work.\n"
                            "2. Provision for suitable Wiring, Electricity Supply with suitable plugs, socket etc.\n"
                            "3. Cable identification and Termination of the cables laid by Client's Contractor on the Distribution Board etc. Dedicated Earth Connection required.\n"
                            "4. Wire cost and material cost, other than motor and control box which comes within the package.",
                            false,
                          ),
                          Center(
                            child: buildBodyText(
                              "*** Any additional work on behalf of client  will be quoted extra separately ***",
                              true,
                            ),
                          ),
                          buildBodyText("Warranty:", true),
                          buildBodyText(
                            'Service and replacement warranty will be provided for the products up to 1 year from the date of installation.',
                            false,
                          ),
                          buildBodyText(
                            'The warranty will not cover the failures for the following reasons:',
                            true,
                          ),
                          buildBodyText(
                            "1. Damage or defect caused by transportation, accident, misuse, lack of maintenance, improper usage or negligence on the part of Client; \n"
                            "2. Wilful damage or negligence, normal wear and tear;\n"
                            "Abuse or misuse of equipment/product;\n"
                            "3. Damage or defect caused by  earthquake  or other similar natural disasters;\n"
                            "4. Damage or defect caused by alteration, modification, conversion not authorised by Company in writing;\n"
                            "5. Repairs carried out by personnel other than Company's authorised service personnel's;\n"
                            "6. Defects or damages due to any other external means or causes are not covered under warranty.",
                            false,
                          ),
                          buildBodyText("Payment:", true),
                          buildBodyText(
                            "50% of order amount should be paid as advance, balance 50% should be paid at the date of installation, There should not be any negotiation in final payment before handing over the Remote and other accessories.",
                            false,
                          ),
                          buildBodyText("Delivery Period:", true),
                          buildBodyText(
                            "1-2 weeks after receipt of commercially & technically clear order with advance of 50%.",
                            false,
                          ),
                          buildBodyText("Cancellation of Order: ", true),
                          buildBodyText(
                            "If the Order placed is cancelled by Client then the cancellation charges of 30% of the Order value shall be charged as  a Termination fee.",
                            false,
                          ),
                          buildBodyText("Scope of Work: ", true),
                          buildBodyText(
                            "1. Instruction and Supervision of conduit work at the initial level and there after completion of conduit work and wiring  work  final inspection will be done.\n"
                            "2. Once the contractor finishes the Electrical work and civil work, we will start Installation of GateAutomation Modules.\n"
                            "3. Programming of all the above mentioned components.\n"
                            "4. Delivery to the client and mobile application integration if needed.",
                            false,
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
        ],
      );

  pw.Text buildBodyText(String text, bool isHead) => Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isHead ? FontWeight.bold : FontWeight.normal,
        ),
      );

  Widget createText(
    String title,
    String subTitle,
    bool isHead,
    double size,
    double val,
  ) =>
      Row(
        children: [
          Container(
            // color: PdfColors.blue,
            width: 25 * PdfPageFormat.mm,
            child: Text(
              title,
              style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
            ),
          ),
          Text(':  '),
          Container(
            // color: PdfColors.red,
            width: isHead ? val : 40 * PdfPageFormat.mm,
            child: Text(
              subTitle,
              textAlign: pw.TextAlign.left,
              style: TextStyle(
                fontSize: size,
                fontWeight: isHead ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      );
}

Widget finalTotal(String title, String subTitle, bool isHead, double size) =>
    Row(
      children: [
        Container(
          // color: PdfColors.green,
          width: 30 * PdfPageFormat.mm,
          child: Text(
            title,
            style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
          ),
        ),
        Text(':  '),
        Container(
          // color: PdfColors.purple,
          width: 25 * PdfPageFormat.mm,
          child: Text(
            subTitle,
            textAlign: pw.TextAlign.right,
            style: TextStyle(
              fontSize: size,
              fontWeight: isHead ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );

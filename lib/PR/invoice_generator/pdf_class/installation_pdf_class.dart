import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '../models/client_model.dart';
import '../models/table_list.dart';
import '../models/utils.dart';
import 'main_pdf_class.dart';

class InstallationPdf {
  late int documentLen;
  late DateTime estimateDate;

  InstallationPdf({
    required this.documentLen,
    required this.estimateDate,
  });


  Future<File> generate(ClientModel clientModel,
      List<ListOfTable> productDetailsModel) async {
    final pdf = Document();

    var assetImage = pw.MemoryImage(
        (await rootBundle.load('assets/logo1.png')).buffer.asUint8List());

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
              ]),
          SizedBox(height: 3 * PdfPageFormat.mm),
          productTable(productDetailsModel),
          Divider(),
        ],
        footer: (context) => buildFooter(),
      ),
    );
    return MainPDFClass.saveDocument(
        fileName: '${clientModel.name}.${clientModel.docType}.pdf', pdf: pdf);
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
                Text(customerDetails.docType,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: PdfColors.red500,
                        fontSize: 20.0)),
                Text("Date :  ${Utils.formatDate(DateTime.now())}",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                SizedBox(height: 3),
                customerDetails.docType == "QUOTATION"
                    ? Text(
                  "#EST${customerDetails.docCategory}-${Utils.formatDummyDate(DateTime.now())}${documentLen.toString()}",
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                )
                    : customerDetails.docType == "INVOICE"
                    ? Text(
                    "#INV_${customerDetails.docCategory}-${Utils.formatDummyDate(DateTime.now())}${documentLen.toString()}",
                    style: const TextStyle(fontSize: 10))
                    : Text(
                    "#PRO_INV_${customerDetails.docCategory}-${Utils.formatDummyDate(DateTime.now())}${documentLen.toString()}",
                    style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    ],
  );

  Widget customerDetails(ClientModel customerDetails) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      createText('To', customerDetails.name, false, 10,0),
      SizedBox(height: 3),
      createText('Address', customerDetails.address, false, 10,0),
      SizedBox(height: 3),
      createText('Location', customerDetails.street, false, 10,0),
      createText('Phone', customerDetails.phone.toString(), false, 10,0),
      SizedBox(height: 1 * PdfPageFormat.mm),
      createText('GSTIN', customerDetails.gst.toString(), false, 10,0),
    ],
  );

  Widget supplierDetails() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      createText('From', 'Onwords Smart Solutions', false, 10 ,0),
      SizedBox(height: 3),
      createText('Address', '1/1 RR Garden, Zamin Muthur,', false, 10,0),
      SizedBox(height: 3),
      createText('Location',
          'Pollachi, Coimbatore,\nTamilNadu - 642 005', false, 10,0),
      SizedBox(height: 3),
      createText('Phone', '+91 7708630275', false, 10,0),
      createText('Email', 'cs@onwords.in', false, 10,0),
      createText('Website', 'www.onwords.in', false, 10,0),
      createText('GSTIN', '33BTUPN5784J1ZT', false, 10,0),
    ],
  );

  Widget productTable(List<ListOfTable> productDetailsModel) {
    final headers = ['Products Name', 'Quantity'];

    final data = productDetailsModel.map((item) {
      return [
        item.productName,
        item.productQuantity,
      ];
    }).toList();
    return Table.fromTextArray(
        headers: headers,
        data: data,
        cellStyle: const TextStyle(fontSize: 9),
        border: const TableBorder(
          // left: BorderSide(),
          // right: BorderSide(),
          // top: BorderSide(),
          // bottom: BorderSide(),
          // horizontalInside: BorderSide(),
          // verticalInside: BorderSide(),
        ),
        headerStyle: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 10, color: PdfColors.white),
        headerDecoration: const BoxDecoration(color: PdfColors.red700),
        cellHeight: 25,
        // headerAlignments: {
        //   0: Alignment.center,
        //   1: Alignment.center,
        //   2: Alignment.center,
        //   3: Alignment.center,
        //   4: Alignment.center,
        //   5: Alignment.center,
        // },
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
        oddRowDecoration: const BoxDecoration(color: PdfColors.red50));
  }

  Widget buildFooter() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      Divider(),
      SizedBox(height: 2 * PdfPageFormat.mm),
      buildBodyText("In Sync, with Smart World", true),
      SizedBox(height: 1 * PdfPageFormat.mm),
      // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
    ],
  );

  pw.Text buildBodyText(String text, bool isHead) => Text(text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: isHead ? FontWeight.bold : FontWeight.normal,
      ));


  Widget createText(String title, String subTitle, bool isHead, double size,double val) =>
      Row(children: [
        Container(
          // color: PdfColors.blue,
            width: 25 * PdfPageFormat.mm,
            child: Text(
              title,
              style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
            )),
        Text(':  '),
        Container(
          // color: PdfColors.red,
          width: isHead ? val : 40 * PdfPageFormat.mm,
          child: Text(
            subTitle,
            textAlign: pw.TextAlign.left,
            style: TextStyle(
              fontSize: size,
              fontWeight: isHead ? FontWeight.bold : FontWeight.normal,),
          ),
        ),
      ]);
}



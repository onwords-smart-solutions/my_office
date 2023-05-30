import 'dart:io';
import 'package:flutter/services.dart';
import 'package:my_office/PR/invoice/api/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import '../utils.dart';

double total = 0;

class PdfInvoiceApi {

   late int subTotal;
   late int cgst;
   late int sgst;
   late int discount;
   late int advance;
   late int granTotal;

   PdfInvoiceApi({
     required this.subTotal,
     required this.cgst,
     required this.sgst,
     required this.discount,
     required this.advance,
     required this.granTotal,
   });


   Future<File> generate(
      Invoice invoice,
      // User user,
      Uint8List pic) async {
    final pdf = Document();
    var assetImage = pw.MemoryImage(
        (await rootBundle.load('assets/logo1.png')).buffer.asUint8List());

    final image = pw.MemoryImage(pic);

    // var asset qrImage = pw.MemoryImage(
    //     (await rootBundle.load('assets/qr_pic.jpg')).buffer.asUint8List());

    // var assetImages = pw.MemoryImage(Fil e(user.imagePath).readAsBytesSync());

    pdf.addPage(
      MultiPage(
        header: (context) => builderLogo(assetImage, invoice.info, invoice),
        build: (context) => [
          buildHeader(invoice),
          SizedBox(height: 2.0 * PdfPageFormat.cm),
          buildInvoice(invoice),
          Divider(),
          buildTotal(invoice,subTotal,cgst,sgst,discount,advance,granTotal),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          Text('Scan to Pay', style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold)),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          builderQR(image),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          buildTermsAndConditions(invoice),
        ],
        footer: (context) => buildFooter(invoice),
      ),
    );

    return PdfApi.saveDocument(name: '${invoice.fileName}.pdf', pdf: pdf);
  }

  static Widget builderLogo(
      MemoryImage img, InvoiceInfo info, Invoice invoice) =>
      Column(
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
                    Text(invoice.docType,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: PdfColors.red500,
                            fontSize: 20.0)),
                    invoice.docType == "QUOTATION"
                        ? Text(
                      "#EST${invoice.cat}-${Utils.formatDummyDate(info.date)}${invoice.quotNo}",
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    )
                        : Text(
                        "#INV${invoice.cat}-${Utils.formatDummyDate(info.date)}${invoice.quotNo}",
                        style: const TextStyle(fontSize: 10)),
                    Text("Date :  ${Utils.formatDate(info.date)}",
                        style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
        ],
      );

  static builderQR(pw.MemoryImage img) {
    // final qr = UPIPaymentQRCode(upiDetails: upiDetails,size: 100,);
    return Container(
      margin: const EdgeInsets.only(left: -7),
      height: 100, //150,
      width: 100, //150,
      child: pw.Image(img),
    );
  }

  static Widget buildHeader(Invoice invoice) => Row(
    // crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      buildSupplierAddress(invoice.supplier),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     buildSupplierAddress(invoice.supplier),
      //     buildInvoiceInfo(invoice.info),
      //   ],
      // ),
      ///
      // Container(
      //   height: 50,
      //   width: 50,
      //   child: BarcodeWidget(
      //     barcode: Barcode.qrCode(),
      //     data: invoice.info.number,
      //   ),
      // ),
      SizedBox(width: 3.5 * PdfPageFormat.cm),
      // SizedBox(height: 2.5 * PdfPageFormat.cm),
      buildCustomerAddress(invoice.customer),
    ],
  );

  static Widget buildCustomerAddress(Customer customer) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Bill To:", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 0.1 * PdfPageFormat.cm),
      Container(
        color: PdfColors.white,
        width: 150,
        child: Text(customer.name,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ),
      Container(
        color: PdfColors.white,
        width: 150,
        child: Text(
          customer.street,
          style: const TextStyle(fontSize: 10),
        ),
      ),
      Container(
        color: PdfColors.white,
        width: 150,
        child: Text(
          customer.address,
          style: const TextStyle(fontSize: 10),
        ),
      ),
      Container(
        color: PdfColors.white,
        width: 150,
        child: Text(
          "Phone: ${customer.phone}",
          style: const TextStyle(fontSize: 10),
        ),
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      Container(
        color: PdfColors.white,
        width: 150,
        child: Text(
          "GSTIN: ${customer.gst}",
          style: const TextStyle(fontSize: 10.0),
        ),
      ),
    ],
  );

  static Widget buildSupplierAddress(Supplier supplier) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2 * PdfPageFormat.mm),
      Text("Street: 1/1 RR Garden,Zamin Muthur",
          style: const TextStyle(fontSize: 10)),
      Text("Address: Pollachi, Coimbatore, Tamilnadu - 642-005",
          style: const TextStyle(fontSize: 10)),
      Text("Phone: +91 7708630275", style: const TextStyle(fontSize: 10)),
      Text("Email: cs@onwords.in", style: const TextStyle(fontSize: 10)),
      Text(
        "Website: www.onwords.in",
        style: const TextStyle(fontSize: 10),
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      Text(
        "GSTIN: 33BTUPN5784J1ZT",
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
      ),

      ///
      // Text(supplier.street),
      // Text(supplier.address),
      // Text("Phone: ${supplier.phone}"),
      // Text("Email: ${supplier.email}"),
      // Text("Website: ${supplier.website}"),
      // SizedBox(height: 0.5 * PdfPageFormat.cm),
      // Text("GSTIN: ${supplier.gst}", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15.0)),
    ],
  );

  static Widget buildInvoice(Invoice invoice) {
    final headers = ['Item & Description', 'Quantity', 'Unit Price', 'Total'];

    final data = invoice.items.map((item) {
      // final total = item.unitPrice * item.quantity * ( 1 + item.vat);
      final total = item.unitPrice * item.quantity;
      return [
        item.description,
        // Utils.formatDate(item.date),
        '${item.quantity}',
        '${item.unitPrice}',
        // '${0} %',
        // '${item.vat} %',
        (total.toStringAsFixed(2)),
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

  static Widget buildBankDetails(Invoice invoice) => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Acc.Name: Onwords",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
        ),
        Text(
          "Bank : HDFC",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
        ),
        Text(
          "Acc.No: 5020-0065-403656",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
        ),
        Text(
          "IFSC Code: HDFC0000787",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
        ),
        Text(
          "UPI : onwordspay@ybl",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
        ),

        // Text("Acc.Name: ${invoice.accountName}", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15.0)),
        // Text("Acc.No: ${invoice.accountNumber}", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15.0)),
        // Text("IFSC Code: ${invoice.ifscCode}", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15.0)),
        // Text("Bank : ${invoice.bankName}", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15.0)),
      ]);

  static Widget buildTermsAndConditions(Invoice invoice) => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeadText("Terms and Conditions"),

        buildSubText(
            "It is recommended by the Company to use INVERTER (UPS) of 1KVA for our control modules and theSame shall be in Client's  Scope."),

        buildSubText(
            "The following facilities and services are to be provided by the client."),

        buildSubText(
            "1. Site Preparation including fabricator,carpentry, welder, civil and Masonry work.\n"
                "2. Provision for suitable Wiring, Electricity Supply with suitable plugs, socket etc.\n"
                "3. Cable identification and Termination of the cables laid by Client's Contractor on the Distribution Board etc. Dedicated Earth Connection required.\n"
                "4. Wire cost and material cost, other than motor and control box which comes within the package."),

        Center(
          child: buildSubText(
              "*** Any additional work on behalf of client  will be quoted extra separately ***"),
        ),

        buildHeadText("Warranty:"),

        buildSubText(
            'Service and replacement warranty will be provided for the products up to 1 year from the date of installation.'),

        buildHeadText(
            'The warranty will  cover the failures for the following reasons:'),

        buildSubText(
            "1. Damage or defect caused by transportation, accident, misuse, lack of maintenance, improper usage or negligence on the part of Client; \n"
                "2. Wilful damage or negligence, normal wear and tear;\n"
                "Abuse or misuse of equipment/product;\n"
                "3. Damage or defect caused by  earthquake  or other similar natural disasters;\n"
                "4. Damage or defect caused by alteration, modification, conversion not authorised by Company in writing;\n"
                "5. Repairs carried out by personnel other than Company's authorised service personnel's;\n"
                "6. Defects or damages due to any other external means or causes are not covered under warranty."),
        buildHeadText("Payment:"),
        buildSubText(
            "50% of order amount should be paid as advance, balance 50% should be paid at the date of installation, There should not be any negotiation in final payment before handing over the Remote and other accessories."),
        buildHeadText("Delivery Period:"),

        buildSubText(
            "1-2 weeks after receipt of commercially & technically clear order with advance of 50%."),

        buildHeadText("Cancellation of Order: "),
        buildSubText(
            "If the Order placed is cancelled by Client then the cancellation charges of 30% of the Order value shall be charged as  a Termination fee."),
        buildHeadText("Scope of Work: "),
        buildSubText(
            "1. Instruction and Supervision of conduit work at the initial level and there after completion of conduit work and wiring  work  final inspection will be done.\n"
                "2. Once the contractor finishes the Electrical work and civil work, we will start Installation of GateAutomation Modules.\n"
                "3. Programming of all the above mentioned components.\n"
                "4. Delivery to the client and mobile application integration if needed."),
      ]);

  static Widget buildTotal(Invoice invoice,  int subTotal,
    int igst,
    int cgst,
    int discount,
    int advance,
    int grandTotal,) {


    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    // final vatPercent = invoice.items.first.vat;
    const vatPercent = 0.09;
    final vat = netTotal * vatPercent;
    final iVat = netTotal * vatPercent;
    final discount = invoice.discountAmount;
    // final labAndIns = invoice.labAndInstall;
    // final total = netTotal + vat + iVat + labAndIns;

    // final total = invoice.gstNeed ? netTotal + vat + iVat : netTotal;

    // final total = invoice.gstNeed?netTotal + vat + iVat + labAndIns: netTotal+ labAndIns;
    total = invoice.gstNeed
        ? netTotal + vat + iVat - discount
        : netTotal - discount;
    // val = invoice.gstNeed
    //     ? netTotal + vat + iVat - discount
    //     : netTotal - discount;
    final advanceAmt = invoice.advancePaid;
    final balanceAmt = total - advanceAmt;
    final discounts = invoice.discountAmount;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          buildBankDetails(invoice),
          Spacer(flex: 3),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildText(
                  title: 'Sub total',
                  // value: Utils.formatPrice(netTotal),
                  value: Utils.formatPrice(subTotal.toDouble()),
                  // value: subTotal.toString(),
                  unite: true,
                ),
                invoice.gstNeed
                    ? buildText(
                  title: 'CGST ${vatPercent * 100} %',
                  value: Utils.formatPrice(cgst.toDouble()),
                  unite: true,
                )
                    : Text(""),
                invoice.gstNeed
                    ? buildText(
                  title: 'IGST ${vatPercent * 100} %',
                  value: Utils.formatPrice(igst.toDouble()),
                  unite: true,
                )
                    : Text(""),
                SizedBox(height: 2 * PdfPageFormat.mm),
                // (invoice.docType == "INVOICE")||(invoice.labNeed)?buildText(
                //   title: 'LABOUR & INSTALLATION ',
                //   titleStyle: TextStyle(
                //     fontSize: 12,
                //     fontWeight: FontWeight.normal,
                //   ),
                //   value: Utils.formatPrice(labAndIns.toDouble()),
                //   unite: true,
                // )
                //     :Text(""),
                SizedBox(height: 2 * PdfPageFormat.mm),
                discounts != 0
                    ? buildText(
                  title: 'Discount Amount ',
                  titleStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(discount.toDouble()),
                  unite: true,
                )
                    : Text(""),
                advanceAmt != 0
                    ? buildText(
                  title: 'Advance Paid ',
                  titleStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                  ),
                  value: advance.toString(),
                  unite: true,
                )
                    : Text(""),

                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                buildText(
                  title: 'Grand total ',
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(grandTotal.toDouble()),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 2 * PdfPageFormat.mm),
                //
                // SizedBox(height: 2 * PdfPageFormat.mm),
                // advanceAmt != 0
                //     ? buildText(
                //   title: 'Balance Amount',
                //   titleStyle: TextStyle(
                //     fontSize: 10,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   value: Utils.formatPrice(balanceAmt.toDouble()),
                //   unite: true,
                // )
                //     : Text(""),
                //

              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      invoice.docType == "QUOTATION"
          ? ((invoice.gstNeed == false))
          ? Text("*All Amount mentioned are exclusive of GST ",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 12.0))
          : Text('')
          : Text(''),

      // ((invoice.gstNeed==true)&&(invoice.labNeed == false))?Text("*All Amount mentioned are exclusive of Labour & Installation ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)):
      // ((invoice.gstNeed==false)&&(invoice.labNeed == true))?Text ("*All Amount mentioned are exclusive of GST ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)):
      // ((invoice.gstNeed==false)&&(invoice.labNeed == false))?Text("*All Amount mentioned are exclusive of GST & Labour & Installation "):Text(""):Text(""),

      // invoice.docType == "QUOTATION"? invoice.gstNeed ?Text("*All Amount mentioned are exclusive of Labour & Installation ",
      //     style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)):Text ("*All Amount mentioned are exclusive of GST, Labour & Installation ",
      //     style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)):Text(""),
      Divider(),
      SizedBox(height: 2 * PdfPageFormat.mm),
      buildSimpleText(title: '', value: "In Sync, with Smart World"),
      SizedBox(height: 1 * PdfPageFormat.mm),
      // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
    ],
  );

  static pw.Padding buildSubText(String text) =>Padding(padding: const EdgeInsets.symmetric(vertical: 5),child: Text(text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.normal,
      )));

  static pw.Text buildHeadText(String text) => Text(text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ));

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style =
        titleStyle ?? TextStyle(fontWeight: FontWeight.bold, fontSize: 10);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: style),
          ),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

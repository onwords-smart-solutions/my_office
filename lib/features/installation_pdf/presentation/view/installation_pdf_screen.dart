import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '../../../../core/utilities/custom_widgets/custom_main_pdf.dart';
import '../../../../core/utilities/custom_widgets/custom_pdf_utils.dart';
import 'installation_details.dart';

class InstallationDetailsScreen {
  late String customerName;
  late String id;
  late int number;
  late String address;

  late DateTime entryDate;
  late DateTime installationDate;
  late String gateType;
  late String needApp;
  late String needAjax;
  late String needGate;
  late String email;
  late String userID;
  late String password;
  late String motorId;
  late int extraRemote;
  late String r1;
  late String r2;
  late String r3;
  late String r4;
  late List<String> nameList;
  late List<String> deviceList;
  late List<String> channel8List;
  late List<String> channel4List;
  late List ajaxProductList;
  late List heavyAndFanBoardDetails;
  late String ajaxUId;

  late String routerID;
  late String routerPassword;
  late String wifiName;
  late String wifiPassword;
  late String server;
  late String portForwarding;
  late double localIp;
  late double staticIp;
  late double serverPort;
  late String needSmartHome;
  late String voiceConfig;
  late String voiceUID;
  late String voicePass;
  late String bSNL;
  late String bSNLUid;
  late String bSNLPass;
  late String motorBrand;

  InstallationDetailsScreen({
    required this.customerName,
    required this.id,
    required this.number,
    required this.address,
    required this.entryDate,
    required this.installationDate,
    required this.needApp,
    required this.needAjax,
    required this.needGate,
    required this.email,
    required this.userID,
    required this.password,
    required this.gateType,
    required this.motorId,
    required this.extraRemote,
    required this.r1,
    required this.r2,
    required this.r3,
    required this.r4,
    required this.nameList,
    required this.deviceList,
    required this.routerID,
    required this.routerPassword,
    required this.wifiName,
    required this.wifiPassword,
    required this.server,
    required this.portForwarding,
    required this.localIp,
    required this.staticIp,
    required this.serverPort,
    required this.needSmartHome,
    required this.voiceConfig,
    required this.voiceUID,
    required this.voicePass,
    required this.bSNL,
    required this.bSNLUid,
    required this.bSNLPass,
    required this.channel8List,
    required this.channel4List,
    required this.heavyAndFanBoardDetails,
    required this.ajaxUId,
    required this.ajaxProductList,
    required this.motorBrand,
  });

  Future<File> generate(List<AjaxListModel> productDetailsModel,) async {
    final pdf = Document();

    var assetImage = pw.MemoryImage(
      (await rootBundle.load('assets/logo1.png')).buffer.asUint8List(),);

    pdf.addPage(
      MultiPage(
        header: (context) => buildLogo(assetImage),
        build: (context) => [
          customerDetails(),
          SizedBox(height: 1 * PdfPageFormat.mm),
          if(needSmartHome == 'Yes') routerAndServerDetails(),
          SizedBox(height: 1 * PdfPageFormat.mm),
          if(needSmartHome == 'Yes')channel8List.isEmpty ? SizedBox() : light8ChannelOutputs(),
          SizedBox(height: 1 * PdfPageFormat.mm),
          if(needSmartHome == 'Yes') channel4List.isEmpty ? SizedBox() : light4ChannelOutputs(),
          SizedBox(height: 1 * PdfPageFormat.mm),
          if(needSmartHome == 'Yes') heavyAndFanBoardDetails.isEmpty ? SizedBox() : heavyAndFanBoard(),
          if(needAjax == "Yes") productTable(productDetailsModel),
          if(needGate == "Yes") gateChannelOutputs(),
          SizedBox(height: 1 * PdfPageFormat.mm),
          deviceList.isEmpty ? SizedBox() : deviceNameList(),
          nameList.isEmpty ? SizedBox() : teamNameList(),
          SizedBox(height: 1 * PdfPageFormat.mm),
        ],
        footer: (context) => buildFooter(),
      ),
    );
    return MainPDFClass.saveDocument(fileName: '${'name'}.${''}.pdf', pdf: pdf);
  }

  Widget buildLogo(
      MemoryImage img,
      ) =>
      Column(
        children: [
          pw.Center(
            child:   Text(
              needSmartHome == 'Yes'
                  ? 'Smart Home Installation Details'
                  : needSmartHome == 'No' && needGate == "Yes" && needAjax == "No" ? 'Gate Installation Details'
                  : needSmartHome == 'No' && needGate == "No" && needAjax == "Yes" ? 'Ajax Installation Details' : "Installation Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // margin: const EdgeInsets.only(top: 30),
                height: 100, //150,
                width: 100, //150,
                child: pw.Image(img),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  createText('Customer Id', id, true, 10, 65, 30),
                  SizedBox(height: 1),
                  createText('Date', Utils.formatDate(entryDate), true, 10,
                    65, 30,),
                  SizedBox(height: 1),
                ],
              ),
            ],
          ),
          Divider(
            color: PdfColors.black,
            height: 5,
          ),
          SizedBox(height: 3 * PdfPageFormat.mm),
        ],);

  Widget customerDetails() => Column(children: [
    Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: PdfColors.red500, borderRadius: BorderRadius.circular(5),),
      child: Center(
        child: buildBodyText('Customer Details', true),
      ),
    ),
    createText('Customer Name', customerName, false, 10, 0, 30),
    SizedBox(height: 3),
    createText('Number', number.toString(), false, 10, 0, 30),
    SizedBox(height: 3),
    createText('Address', address, false, 10, 0, 30),
    SizedBox(height: 3),
    createText('Email', email, false, 10, 0, 30),
    SizedBox(height: 3),
    createText('Installation Date',
      Utils.formatDate(installationDate).toString(), false, 10, 0, 30,),
    SizedBox(height: 3),
    if(needAjax == 'Yes')createText('Ajax User ID', ajaxUId, false, 10, 0, 30),
    SizedBox(height: 3),
  ],);

  Widget gateChannelOutputs() => Column(children: [
    Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: PdfColors.red500, borderRadius: BorderRadius.circular(5),),
      child: Center(
        child: buildBodyText('Gate Details', true),
      ),
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          createText('Gate Type', gateType, false, 10, 0, 30),
          SizedBox(height: 3),
          createText('Motor Model', motorId, false, 10, 0, 30),
          SizedBox(height: 3),
          createText('Brand name', motorBrand, false, 10, 0, 30),
          SizedBox(height: 3),
          createText(
            'Extra Remote', extraRemote.toString(), false, 10, 0, 30,),
          SizedBox(height: 3),
          createText('App Control', needApp, false, 10, 0, 30),
          needSmartHome == 'No' && needApp == 'Yes'
              ? createText('User Id', userID, false, 10, 0, 30)
              : SizedBox(),
          needSmartHome == 'No' && needApp == 'Yes'
              ? createText('Password', password, false, 10, 0, 30)
              : SizedBox(),
          SizedBox(height: 3),
        ],),
        needApp == 'Yes' && needGate == 'Yes'
            ? Column(children: [
          createText('R1', r1, false, 10, 0, 8),
          SizedBox(height: 3),
          createText('R2', r2, false, 10, 0, 8),
          SizedBox(height: 3),
          createText('R3', r3.toString(), false, 10, 0, 8),
          SizedBox(height: 3),
          createText('R4', r4, false, 10, 0, 8),
        ],)
            : SizedBox(),
      ],
    ),
  ],);

  Widget light8ChannelOutputs() => Column(children: [
    Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: PdfColors.red500, borderRadius: BorderRadius.circular(5),),
      child: Center(child: buildBodyText('Light 8 Channel', true)),
    ),
    SizedBox(
      height: 100,
      child: GridView(
        crossAxisCount: 2,
        children: List.generate(
          channel8List.length,
              (index) => createText(
            "R${index + 1}", channel8List[index], false, 13, 0, 8,),
        ),
      ),
    ),
  ],);

  Widget light4ChannelOutputs() => Column(children: [
    Container(
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: PdfColors.red500, borderRadius: BorderRadius.circular(5),),
      child: Center(child: buildBodyText('Light 4 Channel', true)),
    ),
    SizedBox(
      height: 80,
      child: GridView(
        crossAxisCount: 2,
        children: List.generate(
          channel4List.length,
              (index) => createText(
            "R${index + 1}", channel4List[index], false, 13, 0, 8,),
        ),
      ),
    ),
  ],);

  Widget heavyAndFanBoard() => Column(children: [
    Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: PdfColors.red500, borderRadius: BorderRadius.circular(5),),
      child: Center(child: buildBodyText('Heavy and Fan Board', true)),
    ),
    SizedBox(
      height: 80,
      child: GridView(
        crossAxisCount: 2,
        children: List.generate(
          heavyAndFanBoardDetails.length,
              (index) => createText(
            "R${index + 1}", heavyAndFanBoardDetails[index], false, 13, 0, 8,),
        ),
      ),
    ),
  ],);

  Widget routerAndServerDetails() => Column(children: [
    Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: PdfColors.red500, borderRadius: BorderRadius.circular(5),),
      child:
      Center(child: buildBodyText('Router and Server Details', true)),
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          createText('Router UID', routerID.toString(), false, 10, 0, 30),
          SizedBox(height: 3),
          createText('Router Password', routerPassword, false, 10, 0, 30),
          SizedBox(height: 3),
          createText('Wifi Name', wifiName, false, 10, 0, 30),
          SizedBox(height: 3),
          createText(
            'Wifi Password', wifiPassword.toString(), false, 10, 0, 30,),
          SizedBox(height: 3),
          createText('User Id', userID, false, 10, 0, 30),
          SizedBox(height: 3),
          createText('Password', password, false, 10, 0, 30),
          SizedBox(height: 3),
          createText('BSNL', bSNL.toString(), false, 10, 0, 30),
          SizedBox(height: 3),
          if (bSNL == 'Yes')
            createText('User ID', bSNLUid.toString(), false, 10, 0, 30),
          SizedBox(height: 3),
          if (bSNL == 'Yes')
            createText(
              'Password', bSNLPass.toString(), false, 10, 0, 30,),
        ],),
        Column(children: [
          createText('Server', server, false, 10, 0, 30),
          SizedBox(height: 3),
          createText(
            'Port forwarding', portForwarding, false, 10, 0, 30,),
          SizedBox(height: 3),
          createText('Local IP', localIp.toString(), false, 10, 0, 30),
          SizedBox(height: 3),
          createText('Static IP', staticIp.toString(), false, 10, 0, 30),
          SizedBox(height: 3),
          createText(
            'Server Port', serverPort.toString(), false, 10, 0, 30,),
          SizedBox(height: 3),
          createText(
            'Voice Config', voiceConfig.toString(), false, 10, 0, 30,),
          SizedBox(height: 3),
          if (bSNL == 'Yes')
            createText(
              'User ID', voiceUID.toString(), false, 10, 0, 30,),
          SizedBox(height: 3),
          if (bSNL == 'Yes')
            createText('Password', voicePass.toString(), false,
              10, 0, 30,),
        ],),
      ],
    ),
  ],);

  Widget teamNameList() => Column(children: [
    Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: PdfColors.red500, borderRadius: BorderRadius.circular(5),),
      child: Center(child: buildBodyText('Crew Members', true)),
    ),
    SizedBox(height: 3),
    ListView.builder(
      itemCount: nameList.length,
      itemBuilder: (context, int index) {
        return Column(children: [
          createText("${index + 1}", nameList[index], false, 13, 0, 5),
          SizedBox(height: 2 * PdfPageFormat.mm),
        ],);
      },),
  ],);

  Widget deviceNameList() => Column(children: [
    Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
        color: PdfColors.red500, borderRadius: BorderRadius.circular(5),),
      child: Center(child: buildBodyText('Extra Devices', true)),
    ),
    SizedBox(height: 3),
    ListView.builder(
      itemCount: deviceList.length,
      itemBuilder: (context, int index) {
        return Column(children: [
          createText("${index + 1}", deviceList[index], false, 13, 0, 5),
          SizedBox(height: 2 * PdfPageFormat.mm),
        ],);
      },),
  ],);


  Widget productTable(List<AjaxListModel> productDetailsModel) {
    final headers = ['Products Name', 'Quantity',];

    final data = productDetailsModel.map((item) {
      return [
        item.productName,
        item.qty,

      ];
    }).toList();
    return  TableHelper.fromTextArray(
      headers: headers,
      data: data,
      cellStyle: const TextStyle(fontSize: 9),
      border: const TableBorder(
      ),
      headerStyle: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 10, color: PdfColors.white,),
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
      oddRowDecoration: const BoxDecoration(color: PdfColors.red50),);
  }

  Widget buildFooter() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Divider(),
      SizedBox(height: 2 * PdfPageFormat.mm),
      buildBodyText("In Sync with the Smarter World", true),
      SizedBox(height: 1 * PdfPageFormat.mm),
    ],
  );

  pw.Text buildBodyText(String text, bool isHead) => Text(text,
    style: TextStyle(
      fontSize: 16,
      fontWeight: isHead ? FontWeight.bold : FontWeight.normal,
    ),);

  Widget createText(String title, String subTitle, bool isHead, double size,
      double valueWidth, double keyWidth,) =>
      Row(children: [
        Container(
          // color: PdfColors.blue,
          width: keyWidth * PdfPageFormat.mm,
          child: Text(
            title,
            style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
          ),),
        Text(':  '),
        Container(
          // color: PdfColors.red,
          width: isHead ? valueWidth : 50 * PdfPageFormat.mm,
          child: Text(
            subTitle,
            textAlign: pw.TextAlign.left,
            style: TextStyle(
              fontSize: size,
              fontWeight: isHead ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],);
}

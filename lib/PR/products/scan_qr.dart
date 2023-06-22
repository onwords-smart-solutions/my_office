import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_office/PR/invoice_generator/widgets/button_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../Constant/fonts/constant_font.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  bool isResult = false;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.resumeCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    String note = '0.0';
    if (result != null) {
      Uri uri = Uri.parse(result!.code.toString());
      note = uri.queryParameters['note'].toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan to get PR points',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: ConstantFonts.poppinsRegular,
        ),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: isResult ? 0 : 350,
            margin: const EdgeInsets.all(30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ),

          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration:  BoxDecoration(
                color: Color(0xff3b444b),
              borderRadius: BorderRadius.only(topRight: Radius.circular(20,),topLeft: Radius.circular(30))
            ),
            height: isResult ? 500 : 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Center(
                  child: (result != null)
                      ? Text(
                          'PR point is  : $note',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )
                      : const Text('Scan a QR code', style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),),
                ),
                isResult ?  Button('Done', () {
                  setState(() {
                    isResult = false;
                    result = null;
                  });
                }).button() : const SizedBox(),
                const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        isResult = true;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

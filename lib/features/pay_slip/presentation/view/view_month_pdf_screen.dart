import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ViewMonthPdf extends StatefulWidget {
  final String name;
  final String pdf;
  final String month;

  const ViewMonthPdf({
    super.key,
    required this.name,
    required this.pdf,
    required this.month,
  });

  @override
  State<ViewMonthPdf> createState() => _ViewMonthPdfState();
}

class _ViewMonthPdfState extends State<ViewMonthPdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.month,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 25,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const PDF(
        fitPolicy: FitPolicy.BOTH,
        swipeHorizontal: true,
      ).cachedFromUrl(widget.pdf),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).cardColor,
        tooltip: 'Download Pay slip',
        onPressed: downloadAndSharePDF,
        child: Icon(
          Icons.share_rounded,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Future<void> downloadAndSharePDF() async {
    try {
      // Create a temporary directory
      Directory appDocDir = await getTemporaryDirectory();

      // Create a file path
      String filePath = '${appDocDir.path}/${widget.month}_payslip.pdf';

      // Download the PDF file
      var response = await http.get(Uri.parse(widget.pdf));
      File pdfFile = File(filePath);
      await pdfFile.writeAsBytes(response.bodyBytes);

      // Share the PDF file
      await Share.shareXFiles([XFile(filePath)]);
    } catch (e) {
      print('Error downloading or sharing PDF file: $e');
    }
  }
}

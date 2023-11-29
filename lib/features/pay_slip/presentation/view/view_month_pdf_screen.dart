import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class ViewMonthPdf extends StatefulWidget {
  final String name;
  final String pdf;
  final String month;
  const ViewMonthPdf({super.key, required this.name, required this.pdf, required this.month});

  @override
  State<ViewMonthPdf> createState() => _ViewMonthPdfState();

}
class _ViewMonthPdfState extends State<ViewMonthPdf> {

  Future<String?> chooseDownloadDirectory(BuildContext context) async {
    try {
      String? result = await FilePicker.platform.getDirectoryPath();
      if (result != null) {
        return result;
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  void downloadFile(String fileURL, String fileName, BuildContext context) async {
    String? storagePath = await chooseDownloadDirectory(context);
    if (storagePath != 'Directory not found' && storagePath != 'Error finding directory') {
      final taskId = await FlutterDownloader.enqueue(
        url: fileURL,
        savedDir: storagePath!,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );
      print(taskId);
    }
  }


  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  void initState() {
    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const PDF(
          swipeHorizontal: true,
        ).cachedFromUrl(widget.pdf),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Download Pay slip',
        child: const Icon(Icons.download),
        onPressed: (){
          downloadFile(widget.pdf, '${widget.name} ${widget.month} Pay slip ${DateTime.now().millisecondsSinceEpoch}.pdf', context);
        },
      ),
    );
  }
}
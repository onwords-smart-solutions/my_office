import 'dart:isolate';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:gap/gap.dart';

class ViewMonthPdf extends StatefulWidget {
  final String name;
  final String pdf;
  final String month;
  const ViewMonthPdf({super.key, required this.name, required this.pdf, required this.month});

  @override
  State<ViewMonthPdf> createState() => _ViewMonthPdfState();

}
class _ViewMonthPdfState extends State<ViewMonthPdf> {
  final ReceivePort _port = ReceivePort();

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
      await FlutterDownloader.open(taskId: taskId!);
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
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
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
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.month, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 22),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 25,),
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
        child: Icon(Icons.download, color: Theme.of(context).primaryColor,),
        onPressed: (){
          downloadFile(widget.pdf, '${widget.name} ${widget.month} Pay slip ${DateTime.now().millisecondsSinceEpoch}.pdf', context);
        },
      ),
    );
  }
}
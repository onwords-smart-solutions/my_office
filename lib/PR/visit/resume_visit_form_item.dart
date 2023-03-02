import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/PR/visit/product_detail_screen.dart';
import 'package:my_office/PR/visit/summary_notes.dart';
import 'package:my_office/PR/visit/visit_verification_screen.dart';
import 'package:my_office/database/hive_operations.dart';
import 'package:my_office/models/visit_model.dart';

import '../../Constant/fonts/constant_font.dart';

class ResumeVisitFormItem extends StatefulWidget {
  final VisitModel visitDetail;

  const ResumeVisitFormItem({Key? key, required this.visitDetail})
      : super(key: key);

  @override
  State<ResumeVisitFormItem> createState() => _ResumeVisitFormItemState();
}

class _ResumeVisitFormItemState extends State<ResumeVisitFormItem> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> deleteFolder(String folderPath) async {
    final ListResult result = await storage.ref(folderPath).listAll();
    final List<Reference> allFiles = result.items.toList();
    final List<Reference> allFolders = result.prefixes.toList();

    // Delete all files in the folder
    for (final Reference ref in allFiles) {
      print('file is $ref');
      await ref.delete();
    }

    // Delete all sub-folders in the folder
    for (final Reference ref in allFolders) {
      await deleteFolder(ref.fullPath);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.visitDetail.customerPhoneNumber),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        if (widget.visitDetail.storagePath != null) {
          try {
            showBottomDialog();
            await deleteFolder('${widget.visitDetail.storagePath}');
            HiveOperations().deleteVisitEntry(
                phoneNumber: widget.visitDetail.customerPhoneNumber);
          } catch (e) {
            print(e);
            showSnackBar(
                message: 'Unable to delete data from cloud', color: Colors.red);
          }
        } else {
          HiveOperations().deleteVisitEntry(
              phoneNumber: widget.visitDetail.customerPhoneNumber);
        }
      },
      background: background(),
      child: Container(
        margin: const EdgeInsets.all(5.0),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: () {
              switch (widget.visitDetail.stage) {
                case 'visitScreen':
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => VisitVerificationScreen(
                          customerData: widget.visitDetail)));
                  break;

                case 'verification':
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(
                            visitData: widget.visitDetail,
                          )));
                  break;
                case 'product':
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          VisitSummaryScreen(visitData: widget.visitDetail)));
                  break;
              }
            },
            minLeadingWidth: 0.0,
            enableFeedback: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            tileColor: Colors.grey.withOpacity(.25),
            leading: const Icon(Icons.edit_note_rounded),
            title: Text(widget.visitDetail.customerName,
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsBold, fontSize: 15.0)),
            subtitle: Text(
                DateFormat('y-MM-dd').format(widget.visitDetail.dateTime),
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium, fontSize: 12.0)),
            trailing: Text(DateFormat.jm().format(widget.visitDetail.dateTime),
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium, fontSize: 12.0)),
          ),
        ),
      ),
    );
  }

  Widget background() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), color: Colors.red),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Delete',
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium, color: Colors.white),
          ),
          const Icon(Icons.delete_rounded, color: Colors.white),
        ],
      ),
    );
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
              style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
            ),
          ),
        ),
      ),
    );
  }

  void showBottomDialog() =>

      showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape:const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
      builder: (ctx) {

        Future.delayed(const Duration(seconds: 6),(){
          Navigator.of(ctx).pop();
        });

        return WillPopScope(
          onWillPop: ()async{
            return false;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            height: MediaQuery.of(context).size.height*.1,
            child: Row(
              children: [
                const SizedBox(
                  height: 20,
                  width: 20,
                  child:   CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 10.0),
                Text('Deleting',style: TextStyle(fontFamily: ConstantFonts.poppinsMedium,color: Colors.red),),
              ],
            ),
          ),
        );
      });
}

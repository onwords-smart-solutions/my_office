import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/PR/visit/loading_screen.dart';
import 'package:my_office/util/screen_template.dart';
import '../../models/visit_model.dart';
import '../../util/custom_rect_tween.dart';
import '../../util/hero_dialog_route.dart';

class VisitSubmitScreen extends StatefulWidget {
  final VisitModel visitData;
  final int endKm;
  final String summaryNotes;
  final File endKmImage;
  final String dateOfInstallation;

  const VisitSubmitScreen(
      {Key? key,
      required this.visitData,
      required this.dateOfInstallation,
      required this.endKmImage,
      required this.endKm,
      required this.summaryNotes})
      : super(key: key);

  @override
  State<VisitSubmitScreen> createState() => _VisitSubmitScreenState();
}

class _VisitSubmitScreenState extends State<VisitSubmitScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(bodyTemplate: buildMain(), title: 'Submit');
  }

  Widget buildMain() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          //visit full data
          Expanded(
            child: buildVisitSummary(),
          ),
          //submit button
          Hero(
            transitionOnUserGestures: true,
            tag: 'visitFrom',
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin!, end: end!);
            },
            child: SizedBox(
              width: size.width,
              child: ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).push(HeroDialogRoute(
                      builder: (ctx) {
                        return  LoadingScreen(dateOfInstallation: widget.dateOfInstallation,endKm: widget.endKm,endKmImage: widget.endKmImage,summaryNotes: widget.summaryNotes,visitData: widget.visitData,);
                      },
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ConstantColor.backgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0))),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVisitSummary() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customerDetail(),
          const SizedBox(height: 10.0),
          prDetails(),
          const SizedBox(height: 10.0),
          productDetail(),
          const SizedBox(height: 10.0),
          travelDetail(),
          const SizedBox(height: 10.0),
          summaryNotes(),
        ],
      ),
    );
  }

  Widget customerDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '   Customer Detail',
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 15.0,
              color: Colors.black54.withOpacity(.6)),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    fontSize: 12.0,
                    color: Colors.grey),
              ),
              Text(
                widget.visitData.customerName,
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Phone Number',
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    fontSize: 12.0,
                    color: Colors.grey),
              ),
              Text(
                widget.visitData.customerPhoneNumber,
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget prDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '   PR Detail',
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 15.0,
              color: Colors.black54.withOpacity(.6)),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //in charge
              textImage(
                  title: 'In Charge',
                  name: widget.visitData.inChargeDetail!.keys.first,
                  imageLink: widget.visitData.inChargeDetail!.values.first),
              const SizedBox(height: 10.0),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.visitData.supportCrewNames!.length,
                  itemBuilder: (ctx, i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: textImage(
                          title: 'Support Crew ${i + 1}',
                          name: widget.visitData.supportCrewNames![i],
                          imageLink:
                              widget.visitData.supportCrewImageLinks![i]),
                    );
                  })
            ],
          ),
        ),
      ],
    );
  }

  Widget productDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '   Product Detail',
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 15.0,
              color: Colors.black54.withOpacity(.6)),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Products',
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    fontSize: 12.0,
                    color: Colors.grey),
              ),
              Text(
                widget.visitData.productName.toString().substring(
                    1, widget.visitData.productName.toString().length - 1),
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Quotation or Invoice Number',
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    fontSize: 12.0,
                    color: Colors.grey),
              ),
              Text(
                widget.visitData.quotationInvoiceNumber.toString(),
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Product Images',
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    fontSize: 12.0,
                    color: Colors.grey),
              ),
              SizedBox(
                height: 85,
                child: ListView.builder(
                    itemCount: widget.visitData.productImageLinks!.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, i) {
                      return Container(
                        height: 80,
                        width: 80,
                        margin: const EdgeInsets.only(right: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.visitData.productImageLinks![i],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                              value: downloadProgress.progress,
                              strokeWidth: 1.5,
                              color: ConstantColor.backgroundColor,
                            ),
                            errorWidget: (context, url, error) => showError(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget travelDetail() {
    final startKm = widget.visitData.startKm ?? 0;
    final totalKm = widget.endKm - startKm;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '   Travel Detail',
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 15.0,
              color: Colors.black54.withOpacity(.6)),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textImage(
                  name: widget.visitData.startKm.toString(),
                  title: 'Start KM',
                  imageLink: widget.visitData.startKmImageLink.toString()),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'End KM',
                        style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
                            fontSize: 12.0,
                            color: Colors.grey),
                      ),
                      Text(
                        widget.endKm.toString(),
                        style: TextStyle(
                          fontFamily: ConstantFonts.poppinsBold,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.file(widget.endKmImage, fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Text(
                'Total Travel KM',
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    fontSize: 12.0,
                    color: Colors.grey),
              ),
              Text(
                totalKm.toString(),
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget summaryNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '   Summary Notes',
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              fontSize: 15.0,
              color: Colors.black54.withOpacity(.6)),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.white),
          child: Text(
            widget.summaryNotes,
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsBold,
              fontSize: 15.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget textImage(
      {required String title,
      required String name,
      required String imageLink}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium,
                  fontSize: 12.0,
                  color: Colors.grey),
            ),
            Text(
              name,
              style: TextStyle(
                fontFamily: ConstantFonts.poppinsBold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 80,
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: imageLink,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: ConstantColor.backgroundColor,
                      value: downloadProgress.progress),
              errorWidget: (context, url, error) => showError(),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget showError() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
            size: 15.0,
          ),
          Text(
            'Unable to load image',
            style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium,
              color: Colors.red,
              fontSize: 8.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );



}

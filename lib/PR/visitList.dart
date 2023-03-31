import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/models/view_visit_model.dart';
import 'package:my_office/util/screen_template.dart';

class VisitList extends StatefulWidget {
  final VisitViewModel visitList;

  const VisitList({
    Key? key,
    required this.visitList,
  }) : super(key: key);

  @override
  State<VisitList> createState() => _VisitListState();
}

class _VisitListState extends State<VisitList> {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(bodyTemplate: buildMain(), title: 'Visit Details');
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
        Row(
          children: [
            Text(
              '   Customer Detail',
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium,
                  fontSize: 15.0,
                  color: Colors.black54.withOpacity(.6)),
            ),
            const Spacer(),
            Text(
              '${DateFormat('yyyy-MM-dd').format(widget.visitList.dateTime)}  ${widget.visitList.visitTime}',
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 15.0,
                  color: Colors.black54.withOpacity(.6)),
            ),
          ],
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
                widget.visitList.customerName,
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
                widget.visitList.customerPhoneNumber,
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
                  name: widget.visitList.inChargeDetail.keys.first,
                  imageLink: widget.visitList.inChargeDetail.values.first),
              const SizedBox(height: 10.0),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.visitList.supportCrewNames.length,
                  itemBuilder: (ctx, i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: textImage(
                          title: 'Support Crew ${i + 1}',
                          name: widget.visitList.supportCrewNames[i].toString(),
                          imageLink: widget.visitList.supportCrewImageLinks[i]
                              .toString()),
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
                widget.visitList.productName.toString().substring(
                    1, widget.visitList.productName.toString().length - 1),
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Quotation (or) Invoice Number',
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    fontSize: 12.0,
                    color: Colors.grey),
              ),
              Text(
                widget.visitList.quotationInvoiceNumber.toString(),
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsBold,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Date of installation',
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    fontSize: 12.0,
                    color: Colors.grey),
              ),
              Text(
                widget.visitList.dateOfInstallation,
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
                    itemCount: widget.visitList.productImageLinks.length,
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
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => InteractiveViewer(
                                  clipBehavior: Clip.none,
                                  maxScale: 4,
                                  minScale: 1,
                                  child: CachedNetworkImage(
                                    imageUrl: widget
                                        .visitList.productImageLinks[i]
                                        .toString(),
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        const Icon(Icons
                                            .production_quantity_limits_outlined),
                                    errorWidget: (context, url, error) =>
                                        showError(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: CachedNetworkImage(
                                imageUrl: widget.visitList.productImageLinks[i]
                                    .toString(),
                                progressIndicatorBuilder: (context, url,
                                        downloadProgress) =>
                                    const Icon(Icons
                                        .production_quantity_limits_outlined),
                                errorWidget: (context, url, error) =>
                                    showError(),
                                fit: BoxFit.cover,
                              ),
                            ),
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
    final startKm = widget.visitList.startKm ?? 0;
    final totalKm = widget.visitList.endKm - startKm;

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
                  name: widget.visitList.startKm.toString(),
                  title: 'Start KM',
                  imageLink: widget.visitList.startKmImageLink.toString()),
              const SizedBox(height: 10.0),
              textImage(
                  name: widget.visitList.endKm.toString(),
                  title: 'End KM',
                  imageLink: widget.visitList.endKmImage.toString()),
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
            widget.visitList.note,
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
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => InteractiveViewer(
                    clipBehavior: Clip.none,
                    minScale: 1,
                    maxScale: 4,
                    child: CachedNetworkImage(
                      imageUrl: imageLink,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const Icon(Icons.person_pin),
                      errorWidget: (context, url, error) => showError(),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              child: SizedBox(
                height: 80,
                width: 80,
                child: CachedNetworkImage(
                  imageUrl: imageLink,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const Icon(Icons.person_pin),
                  errorWidget: (context, url, error) => showError(),
                  fit: BoxFit.cover,
                ),
              ),
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

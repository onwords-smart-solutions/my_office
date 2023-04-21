import 'package:flutter/material.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/PR/visit/resume_visit_form_item.dart';
import 'package:my_office/PR/visit/visit_screen.dart';
import 'package:my_office/database/hive_operations.dart';
import 'package:my_office/models/visit_model.dart';
import 'package:my_office/util/screen_template.dart';

class VisitFromScreen extends StatefulWidget {
  const VisitFromScreen({Key? key}) : super(key: key);

  @override
  State<VisitFromScreen> createState() => _VisitFromScreenState();
}

class _VisitFromScreenState extends State<VisitFromScreen> {
  @override
  void initState() {
    HiveOperations().getVisitEntry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(bodyTemplate: buildScreen(), title: 'Visit Form');
  }

  Widget buildScreen() {
    return Column(
      children: [
        buildNewFormButton(),
        const Divider(height: 0.0),
        Expanded(
          child: buildResumeEditForm(),
        )
      ],
    );
  }

  Widget buildNewFormButton() {
    return TextButton.icon(
      onPressed: () =>        Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const VisitScreen())),
      style: TextButton.styleFrom(foregroundColor: const Color(0xffF1F2F8),backgroundColor: Colors.black.withOpacity(0.2)),
      label: Text(
        'Create new visit form',
        style:
        TextStyle(fontFamily: ConstantFonts.poppinsMedium, fontSize: 16.0,color: Colors.black),
      ),
      icon: const Icon(
        Icons.add_circle_rounded,
        size: 25.0,
      ),
    );
  }

  Widget buildResumeEditForm() {
    return ValueListenableBuilder(
        valueListenable: prVisits,
        builder: (BuildContext ctx, List<VisitModel> visitList, Widget? child) {
          return visitList.isNotEmpty
              ? buildUnfinishedVisitEntries(visitList: visitList)
              : Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border:
                    Border.all(width: 1, color: Colors.black)),
                child: Text(
                  'No pending visit entry',
                  style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      fontSize: 14.0,color: Colors.black
                  ),
                ),
              ));
        });
  }

  Widget buildUnfinishedVisitEntries({required List<VisitModel> visitList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          margin: const EdgeInsets.only(top: 15.0, left: 5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color(0xff8355B7)),
          child: Text(
            'Incomplete visit forms',
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                fontSize: 14.0,
                color: Colors.white),
          ),
        ),
        Expanded(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: visitList.length,
                itemBuilder: (ctx, i) {
                  return ResumeVisitFormItem(visitDetail: visitList[i]);
                }))
      ],
    );
  }
}
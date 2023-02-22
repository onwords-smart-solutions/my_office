import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const VisitScreen())),
      style: TextButton.styleFrom(foregroundColor: const Color(0xff8355B7)),
      label: Text(
        'Create new visit form',
        style:
            TextStyle(fontFamily: ConstantFonts.poppinsMedium, fontSize: 16.0),
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
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: visitList.length,
                  itemBuilder: (ctx, i) {
                    return ResumeVisitFormItem(
                        name: visitList[i].customerName,
                        date: visitList[i].date,
                        time: visitList[i].time,
                        number: visitList[i].customerPhoneNumber);
                  })
              : Center(
                  child: Text('No pending visit entry',
                      style: TextStyle(
                          fontFamily: ConstantFonts.poppinsMedium,
                          fontSize: 16.0)));
        });
  }
}

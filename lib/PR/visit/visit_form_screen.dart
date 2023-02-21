import 'package:flutter/material.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/PR/visit/visit_screen.dart';
import 'package:my_office/util/screen_template.dart';

class VisitFromScreen extends StatefulWidget {
  const VisitFromScreen({Key? key}) : super(key: key);

  @override
  State<VisitFromScreen> createState() => _VisitFromScreenState();
}

class _VisitFromScreenState extends State<VisitFromScreen> {
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
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (ctx, i) {
          return Text('Resume Visit form ${i + 1}');
        });
  }
}

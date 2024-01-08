import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_app_button.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_snack_bar.dart';
import 'package:my_office/features/suggestions/data/data_source/suggestion_fb_data_source_impl.dart';
import 'package:my_office/features/suggestions/data/repository/suggestion_repo_impl.dart';
import 'package:my_office/features/suggestions/domain/use_case/add_suggestion_use_case.dart';
import '../../../../core/utilities/constants/app_main_template.dart';
import '../../../notifications/presentation/notification_view_model.dart';

class SuggestionScreen extends StatefulWidget {
  final String uid;
  final String name;

  const SuggestionScreen({Key? key, required this.uid, required this.name})
      : super(key: key);

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  TextEditingController suggestionsController = TextEditingController();
  int characterCount = 0;

  @override
  void initState() {
    suggestionsController.addListener(() {
      setState(() {
        characterCount = suggestionsController.text.length;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    suggestionsController.dispose();
    super.dispose();
  }

  Future<void> sendNotification(
    String userId,
    String title,
    String body,
  ) async {
    final tokens = await NotificationService().getDeviceFcm(userId: userId);
    final dTokens = await NotificationService().getDeviceFcm(
      userId: '58JIRnAbechEMJl8edlLvRzHcW52',
    );
    final jTokens = await NotificationService().getDeviceFcm(
      userId: 'Ae6DcpP2XmbtEf88OA8oSHQVpFB2',
    );
    tokens.addAll(dTokens);
    tokens.addAll(jTokens);

    for (var token in tokens) {
      await NotificationService().sendNotification(
        title: title,
        body: body,
        token: token,
        type: NotificationType.suggestion,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Suggestion',
      templateBody: suggestions(),
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget suggestions() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                ),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                controller: suggestionsController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(.3),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color:  Theme.of(context).primaryColor.withOpacity(.5),
                      width: 2,
                    ),
                  ),
                  hintText: 'Fill up some useful suggestions!!',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor.withOpacity(.3),
                  ),
                ),
              ),
              const Gap(15),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '  Character count: $characterCount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(30),
        AppButton(
            onPressed: addSuggestionToDatabase,
            child: Text(
              "Submit",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
        ),
      ],
    );
  }

  void addSuggestionToDatabase() async {
    final suggestionFbDataSource = SuggestionFbDataSourceImpl();
    final suggestionRepository = SuggestionRepoImpl(suggestionFbDataSource);
    final suggestionCase =
        AddSuggestionCase(suggestionRepository: suggestionRepository);
    if (suggestionsController.text.trim().isEmpty) {
      CustomSnackBar.showErrorSnackbar(
        message: 'Suggestions should not be empty!',
        context: context,
      );
    } else if (suggestionsController.text.length < 20) {
      CustomSnackBar.showErrorSnackbar(
        message: 'Too short for a Suggestion!',
        context: context,
      );
    } else {
      suggestionCase.execute(
        widget.uid,
        suggestionsController.text,
      );
      sendNotification(
        'Vhbt8jIAfiaV1HxuWERLqJh7dbj2',
        'Suggestion',
        'New suggestion has been arrived',
      );
      suggestionsController.clear();
      CustomSnackBar.showSuccessSnackbar(
        message: 'Your suggestion has been submitted',
        context: context,
      );
    }
  }
}

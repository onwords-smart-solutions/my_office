import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_app_button.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_snack_bar.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_text_field.dart';
import 'package:my_office/features/hr_access/domain/use_case/create_account_use_case.dart';

import '../../data/data_source/hr_access_fb_data_source.dart';
import '../../data/data_source/hr_access_fb_data_source_impl.dart';
import '../../data/repository/hr_access_repo_impl.dart';
import '../../domain/repository/hr_access_repository.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController name = TextEditingController();
  TextEditingController dep = TextEditingController();
  TextEditingController email = TextEditingController();

  late HrAccessFbDataSource hrAccessFbDataSource = HrAccessFbDataSourceImpl();
  late HrAccessRepository hrAccessRepository =
  HrAccessRepoImpl(hrAccessFbDataSource);
  late CreateAccountCase createAccountCase =
  CreateAccountCase(hrAccessRepository: hrAccessRepository);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * .25,
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade400,
              ),
              child: SafeArea(
                minimum: const EdgeInsets.only(
                    left: 10, right: 10, top: 30, bottom: 30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 18,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const Text(
                            'BACK',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      const Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          'Create new staff credentials',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(30),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: CustomTextField(
                controller: name,
                textInputType: TextInputType.name,
                textInputAction: TextInputAction.next,
                hintName: 'Staff name',
                maxLength: 100,
              ).textInputField(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: CustomTextField(
                textCapitalizationWords: TextCapitalization.characters,
                controller: dep,
                textInputType: TextInputType.name,
                textInputAction: TextInputAction.next,
                hintName: 'Department',
                maxLength: 100,
              ).textInputField(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: CustomTextField(
                textCapitalizationWords: TextCapitalization.none,
                controller: email,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                hintName: 'Email id',
                maxLength: 100,
              ).textInputField(),
            ),
            const Gap(50),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                height: size.height * .065,
                width: size.width,
                child: AppButton(
                  onPressed: submitForm,
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                    fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitForm() async {
    if(name.text.isNotEmpty && email.text.isNotEmpty && dep.text.isNotEmpty){
      await createAccountCase.execute(
        name: name.text,
        email: email.text,
        dep: dep.text,
      );
      if(!mounted) return;
      name.clear();
      email.clear();
      dep.clear();
      CustomSnackBar.showSuccessSnackbar(
          message: 'New staff credentials has been created',
          context: context,
      );
    }else{
      CustomSnackBar.showErrorSnackbar(
        message: 'All the fields are required!',
        context: context,
      );
    }
  }
}

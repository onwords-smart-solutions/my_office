import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
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
  TextEditingController phone = TextEditingController();
  TextEditingController dob = TextEditingController();
  final ValueNotifier<DateTime?> _birthday = ValueNotifier(null);


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
                color: Colors.deepPurple.shade300,
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
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Text(
                              'BACK',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
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
              ).textInputField(context),
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
              ).textInputField(context),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: CustomTextField(
                textCapitalizationWords: TextCapitalization.none,
                controller: email,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                hintName: 'Email id',
                maxLength: 100,
              ).textInputField(context),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: CustomTextField(
                textCapitalizationWords: TextCapitalization.none,
                controller: phone,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.next,
                hintName: 'Mobile number',
                maxLength: 10,
              ).textInputField(context),
            ),
            const Gap(5),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ValueListenableBuilder(
                valueListenable: _birthday,
                builder: (ctx, birthday, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        onTap: () =>
                            _showDatePicker(context, MediaQuery.sizeOf(context)),
                        title: Text(
                          birthday == null
                              ? 'DOB'
                              : _dateFormat(birthday),
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(
                            color:Theme.of(context).primaryColor.withOpacity(.3),
                            width: 2,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Gap(50),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                height: size.height * .065,
                width: size.width,
                child: AppButton(
                  onPressed: submitForm,
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
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

  String _dateFormat(DateTime date) => DateFormat('dd-MM-yyyy').format(date);

  //Date picker
  void _showDatePicker(BuildContext context, Size size) {
    _showDialog(
      CupertinoDatePicker(
        initialDateTime: DateTime.now(),
        mode: CupertinoDatePickerMode.date,
        use24hFormat: false,
        showDayOfWeek: true,
        maximumDate: DateTime.now(),
        onDateTimeChanged: (DateTime newDate) {
          _birthday.value = newDate;
        },
      ),
      context,
      size,
    );
  }

  //show dialog
  void _showDialog(Widget child, BuildContext context, Size size) {
    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) => Container(
        height: size.height * .4,
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Column(
          children: [
            Expanded(child: child),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Ok',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Db save function
  void submitForm() async {
    if(name.text.isNotEmpty && email.text.isNotEmpty && dep.text.isNotEmpty &&  phone.text.isNotEmpty && phone.text.length >= 10 && _birthday.value != null){
      await createAccountCase.execute(
        name: name.text,
        email: email.text,
        dep: dep.text,
        phone: int.parse(phone.text),
        dob: _birthday.value!,
      );
      if(!mounted) return;
      name.clear();
      email.clear();
      dep.clear();
      phone.clear();
      _birthday.value = null;
      CustomSnackBar.showSuccessSnackbar(
        message: 'New staff credentials has been created',
        context: context,
      );
    } else{
      CustomSnackBar.showErrorSnackbar(
        message: 'Fill all the fields without exception',
        context: context,
      );
    }

  }
}

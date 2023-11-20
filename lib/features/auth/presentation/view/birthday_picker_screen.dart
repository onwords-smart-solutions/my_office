import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:my_office/features/auth/data/data_source/auth_fb_data_souce_impl.dart';
import 'package:my_office/features/auth/data/data_source/auth_fb_data_source.dart';
import 'package:my_office/features/auth/data/data_source/auth_local_data_source.dart';
import 'package:my_office/features/auth/data/repository/auth_repo_impl.dart';
import 'package:my_office/features/auth/domain/repository/auth_repository.dart';
import 'package:my_office/features/home/presentation/provider/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utilities/custom_widgets/custom_snack_bar.dart';
import '../../../../main.dart';
import '../provider/auth_provider.dart';

class BirthdayPickerScreen extends StatelessWidget {
  final ValueNotifier<DateTime?> _birthday = ValueNotifier(null);
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  BirthdayPickerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Pick Birthday',
          style:
              TextStyle(fontWeight: FontWeight.w700, color: Colors.deepPurple),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          SvgPicture.asset(
            'assets/birthday.svg',
            height: MediaQuery.of(context).size.height * .4,
          ),
          const Text(
            'Join us in commemorating your birthday with Onwords, where the fun and festivities never end. It\'s going to be an unforgettable celebration',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15.0),
          const Align(
            alignment: AlignmentDirectional.center,
            child: Text(
              'Choose your date of birth',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                color: Colors.deepPurple,
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _birthday,
            builder: (ctx, birthday, child) {
              return Column(
                children: [
                  ListTile(
                    onTap: () =>
                        _showDatePicker(context, MediaQuery.sizeOf(context)),
                    title: Text(
                      birthday == null
                          ? 'Pick birthday'
                          : _dateFormat(birthday),
                      style: TextStyle(
                        fontWeight: birthday == null
                            ? FontWeight.w500
                            : FontWeight.w700,
                        color: birthday == null ? Colors.grey : Colors.black,
                      ),
                    ),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    trailing: const Icon(
                      Icons.cake_rounded,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  if (birthday != null)
                    ValueListenableBuilder(
                      valueListenable: _loading,
                      builder: (ctx, loading, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: loading
                              ? const CircleAvatar(
                                  backgroundColor: Colors.deepPurple,
                                  child: SizedBox(
                                    width: 30.0,
                                    height: 30.0,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                  ),
                                )
                              : FilledButton(
                                  onPressed: () => _submitForm(context),
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

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

  Future<void> _submitForm(BuildContext context) async {
    late FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    late  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    late  AuthFbDataSource authFbDataSource = AuthFbDataSourceImpl(firebaseDatabase, firebaseAuth);
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    late AuthLocalDataSourceImpl authLocalDataSourceImpl = AuthLocalDataSourceImpl(sharedPreferences);
    late AuthRepository authRepository = AuthRepoImpl(authFbDataSource, authLocalDataSourceImpl);

    _loading.value = true;
    final userProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_birthday.value == null) {
      CustomSnackBar.showErrorSnackbar(
        message: 'Please choose your date of birth',
        context: context,
      );
      _loading.value = false;
    } else {
       await authRepository.updateUserDOB(userProvider.user!.uid, _birthday.value!);
       userProvider.updateDOB(_birthday.value!);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const AuthenticationScreen(),
        ),
            (route) => false,
      );
    }
  }

  String _dateFormat(DateTime date) => DateFormat('dd-MM-yyyy').format(date);

}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'features/home/presentation/provider/home_provider.dart';
import 'main.dart';

final ValueNotifier<bool> _loading = ValueNotifier(false);

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            const SizedBox(height: 20),
            const Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/contact_info.svg',
              height: MediaQuery.sizeOf(context).height * .4,
            ),
            const SizedBox(height: 20),
            const Text(
              'As part of our efforts to streamline communication and enhance collaboration within the company, we would like to update our contact information for all employees.',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              controller: phoneController,
              onChanged: (value){
                setState(() {});
              },
              maxLines: 1,
              maxLength: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                ),
                hintText: 'Enter your mobile number',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if(phoneController.text.isNotEmpty)
            ValueListenableBuilder(
              valueListenable: _loading,
              builder: (ctx, loading, child) {
                return loading ?
                  const CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  ),
                ) :
                  FilledButton(
                    onPressed: () => homeProvider.phoneNumberSubmitForm(context),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

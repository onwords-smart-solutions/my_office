import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/PR/visit/product_detail_screen.dart';
import 'package:my_office/database/hive_operations.dart';
import 'package:my_office/models/visit_model.dart';

import '../../util/screen_template.dart';

class VisitScreen extends StatefulWidget {
  const VisitScreen({Key? key}) : super(key: key);

  @override
  State<VisitScreen> createState() => _VisitScreenState();
}

class _VisitScreenState extends State<VisitScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isLoading = false;
  Map<Object?, Object?> customerData = {};
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bodyTemplate: buildScreen(),
      title: 'New Visit Form',
    );
  }

  Widget buildScreen() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCustomerNumberSearch(),
          buildSearchButton(),
          if (customerData.isNotEmpty) buildCustomerDetailSection(),
          const SizedBox(height: 80.0),
          if (customerData.isNotEmpty) buildNextButton(),
        ],
      ),
    );
  }

  Widget buildCustomerNumberSearch() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('Customer Phone No :',
                style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium,
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: const ValueKey('password'),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  //validator
                  validator: (data) {
                    if (data!.trim().isEmpty) {
                      return 'Enter a phone number';
                    } else if (data.trim().length < 10) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    phoneNumber = value.toString().trim();
                  },
                  style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),

                  //decoration
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    hintText: 'Phone number',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.grey.withOpacity(.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 1.5,
                        color: Colors.purple,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(width: 1, color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 1.5,
                        color: Colors.purple,
                      ),
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

  Widget buildSearchButton() {
    return SizedBox(
      height: 38.0,
      width: 120.0,
      child: ElevatedButton(
          onPressed: isLoading ? null : submitPhoneNumber,
          style: ElevatedButton.styleFrom(
              disabledBackgroundColor: ConstantColor.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              backgroundColor: ConstantColor.backgroundColor),
          child: isLoading
              ? Lottie.asset("assets/animations/loading.json")
              : const Text('Search')),
    );
  }

  Widget buildCustomerDetailSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.white),
      child: Column(
        children: [
          //name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Name'),
              const SizedBox(width: 20.0),
              Expanded(
                child: Text(
                  customerData['name'].toString(),
                  textAlign: TextAlign.end,
                  style: TextStyle(fontFamily: ConstantFonts.poppinsBold),
                ),
              ),
            ],
          ),

          //email id
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Email Id'),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Text(
                    customerData['email_id'].toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontFamily: ConstantFonts.poppinsBold),
                  ),
                ),
              ],
            ),
          ),

          //city
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('City'),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Text(
                    customerData['city'].toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontFamily: ConstantFonts.poppinsBold),
                  ),
                ),
              ],
            ),
          ),

          //Lead in charge
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Lead in Charge'),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Text(
                    customerData['LeadIncharge'].toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontFamily: ConstantFonts.poppinsBold),
                  ),
                ),
              ],
            ),
          ),

          //enquired for
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Enquired For'),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Text(
                    customerData['inquired_for'].toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontFamily: ConstantFonts.poppinsBold),
                  ),
                ),
              ],
            ),
          ),

          //status
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status'),
                const SizedBox(width: 50.0),
                Expanded(
                  child: Text(
                    customerData['customer_state'].toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontFamily: ConstantFonts.poppinsBold),
                  ),
                ),
              ],
            ),
          ),

          //data fetched by
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Data fetched By'),
                const SizedBox(width: 50.0),
                Expanded(
                  child: Text(
                    customerData['data_fetched_by'].toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontFamily: ConstantFonts.poppinsBold),
                  ),
                ),
              ],
            ),
          ),

          //
        ],
      ),
    );
  }

  Widget buildNextButton() {
    return SizedBox(
      height: 38.0,
      width: 120.0,
      child: ElevatedButton(
          onPressed: () async {
            final nav = Navigator.of(context);
            final today = DateTime.now();
            final date = '${today.year}-${today.month}-${today.day}';
            final time = '${today.hour}:${today.minute}';
            final visitData = VisitModel(
                date: date,
                time: time,
                customerPhoneNumber: phoneNumber,
                customerName: customerData['name'].toString(),stage: 'visitScreen');

            await HiveOperations().addVisitEntry(visit: visitData);
            nav.push(
                MaterialPageRoute(builder: (_) => const ProductDetailScreen()));
          },
          style: ElevatedButton.styleFrom(
              disabledBackgroundColor: ConstantColor.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              backgroundColor: ConstantColor.backgroundColor),
          child: const Text('Next')),
    );
  }

  void submitPhoneNumber() {
    final valid = _formKey.currentState!.validate();
    if (valid) {
      FocusScope.of(context).unfocus();
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();
      getCustomerDetail();
    }
  }

  void getCustomerDetail() {
    final ref = FirebaseDatabase.instance.ref('customer/$phoneNumber');
    ref.once().then((value) {
      final data = value.snapshot.value;
      if (data == null) {
        setState(() {
          isLoading = false;
          showSnackBar(
              message: 'No customer found with this phone number',
              color: Colors.red);
        });
      } else {
        setState(() {
          isLoading = false;
          customerData = data as Map<Object?, Object?>;
        });
      }
    });
  }

  void showSnackBar({required String message, required Color color}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        padding: const EdgeInsets.all(0.0),
        content: Container(
            height: 50.0,
            color: color,
            child: Center(
                child: Text(
              message,
              style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
            )))));
  }
}

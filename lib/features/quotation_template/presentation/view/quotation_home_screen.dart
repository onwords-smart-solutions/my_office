import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_app_button.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_text_field.dart';
import 'package:my_office/features/quotation_template/presentation/view/quotation_preview_screen.dart';
import 'package:provider/provider.dart';
import '../../model/client_model.dart';
import '../provider/invoice_provider.dart';

class Client1Details extends StatefulWidget {
  const Client1Details({Key? key}) : super(key: key);

  @override
  State<Client1Details> createState() => _Client1DetailsState();
}

class _Client1DetailsState extends State<Client1Details> {
  final formKey = GlobalKey<FormState>();

  TextEditingController clientName = TextEditingController();
  TextEditingController clientStreet = TextEditingController();
  TextEditingController clientAddress = TextEditingController();
  TextEditingController clientPhone = TextEditingController();
  TextEditingController clientGst = TextEditingController();

  String dropdownDocTypeValue = 'QUOTATION';
  String dropdownCategoryValue = 'GA';

  List<String> category = [
    'SL-GA',
    'SW-GA',
    'SH',
  ];
  List<String> docType = [
    'QUOTATION',
  ];

  @override
  void dispose() {
    clientName.dispose();
    clientStreet.dispose();
    clientAddress.dispose();
    clientGst.dispose();
    clientPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Client Details',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.02),
                  height: size.height * 0.72,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomTextField(
                          controller: clientName,
                          textInputType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          hintName: 'Client Name',
                          icon: const Icon(Icons.person),
                          maxLength: 50,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Customer Name';
                            }
                            return null;
                          },
                        ).textInputField(),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomTextField(
                          controller: clientStreet,
                          textInputType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          hintName: 'Client Location',
                          icon: const Icon(Icons.location_on),
                          maxLength: 50,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Customer Street';
                            }
                            return null;
                          },
                        ).textInputField(),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomTextField(
                          controller: clientAddress,
                          textInputType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          hintName: 'Client Address',
                          icon: const Icon(Icons.location_city),
                          maxLength: 100,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Customer Address';
                            }
                            return null;
                          },
                        ).textInputField(),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomTextField(
                          controller: clientPhone,
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          hintName: 'Phone Number',
                          icon: const Icon(Icons.call),
                          maxLength: 10,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length != 10) {
                              return 'Please enter customer number';
                            }
                            return null;
                          },
                        ).textInputField(),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        CustomTextField(
                          controller: clientGst,
                          textInputType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          hintName: 'GST (optional)',
                          icon: const Icon(Icons.comment_bank),
                          maxLength: 20,
                        ).textInputField(),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: size.width * 0.4,
                              child: DropdownButtonFormField<String>(
                                style: const TextStyle(
                                  color: CupertinoColors.label,
                                  fontSize: 16,
                                ),
                                hint: const Text(
                                  "Category",
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(5.0),
                                  border: myInputBorder(),
                                  enabledBorder: myInputBorder(),
                                  fillColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  // hoverColor: Colors.black,
                                  focusedBorder: myFocusBorder(),
                                  errorStyle: const TextStyle(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Select Doc-Category';
                                  }
                                  return null;
                                },
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownCategoryValue = newValue!;
                                  });
                                },
                                items: category.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                AppButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Provider.of<Invoice1Provider>(context, listen: false)
                          .addCustomerDetails(
                        ClientModel(
                          name: clientName.text,
                          street: clientStreet.text,
                          address: clientAddress.text,
                          phone: int.parse(clientPhone.text),
                          // docType: dropdownDocTypeValue.toString(),
                          docType: 'QUOTATION',
                          docCategory: dropdownCategoryValue.toString(),
                          gst: clientGst.text,
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InvoicePreviewScreen(
                            type: dropdownCategoryValue.toString(),
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: size.width * 0.5,
                    height: size.height * .06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder myInputBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.5),
        width: 1.5,
      ),
    );
  }

  OutlineInputBorder myFocusBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.5),
        width: 1.5,
      ),
    );
  }
}


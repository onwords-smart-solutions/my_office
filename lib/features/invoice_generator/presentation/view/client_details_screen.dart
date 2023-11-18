import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../../core/utilities/constants/app_color.dart';
import '../../../../core/utilities/custom_widgets/custom_app_button.dart';
import '../../../../core/utilities/custom_widgets/custom_text_field.dart';
import '../../data/model/invoice_generator_model.dart';
import '../provider/invoice_generator_provider.dart';
import 'add_products_screen.dart';

class ClientDetails extends StatefulWidget {
  const ClientDetails({Key? key}) : super(key: key);

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  final formKey = GlobalKey<FormState>();

  TextEditingController clientName = TextEditingController();
  TextEditingController clientStreet = TextEditingController();
  TextEditingController clientAddress = TextEditingController();
  TextEditingController clientPhone = TextEditingController();
  TextEditingController clientGst = TextEditingController();

  String dropdownDocTypeValue = 'QUOTATION';
  String dropdownCategoryValue = 'GA';

  List<String> category = [
    'GA',
    'SH',
    'IT',
    'DL',
    'SS',
    'WTA',
    'AG',
    'VC',
  ];
  List<String> docType = ['QUOTATION', 'PROFORMA_INVOICE', 'INVOICE'];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<InvoiceGeneratorProvider>(context, listen: false).clearAllData();
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Client Details',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColor.primaryColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () {
              Provider.of<InvoiceGeneratorProvider>(context, listen: false)
                  .clearAllData();
              Navigator.pop(context);
            },
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    height: 560,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: clientName,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            hintName: 'Client Name',
                            icon: const Icon(Icons.person),
                            maxLength: 45,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Customer Name';
                              }
                              return null;
                            },
                          ).textInputField(),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextField(
                            controller: clientStreet,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            hintName: 'Client Location',
                            icon: const Icon(Iconsax.location5),
                            maxLength: 50,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Customer Street';
                              }
                              return null;
                            },
                          ).textInputField(),
                          const SizedBox(
                            height: 15,
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
                          const SizedBox(
                            height: 15,
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
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextField(
                            controller: clientGst,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                            hintName: 'GST (optional)',
                            icon: const Icon(Icons.comment_bank),
                            maxLength: 15,
                          ).textInputField(),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 160,
                                child: DropdownButtonFormField<String>(
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  hint: const Text(
                                    "Doc-Type",
                                    style: TextStyle(),
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(5.0),
                                    border: myInputBorder(),
                                    enabledBorder: myInputBorder(),
                                    focusedBorder: myFocusBorder(),
                                    // isDense: true,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Select Doc-Type';
                                    }
                                    return null;
                                  },
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownDocTypeValue = newValue!;
                                    });
                                  },
                                  items: docType.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                width: 160,
                                child: DropdownButtonFormField<String>(
                                  style: const TextStyle(
                                    color: CupertinoColors.label,
                                    fontSize: 16,
                                  ),
                                  hint: const Text(
                                    "Category",
                                    style: TextStyle(),
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(5.0),
                                    border: myInputBorder(),
                                    enabledBorder: myInputBorder(),
                                    fillColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    // hoverColor: Colors.black,
                                    focusedBorder: myFocusBorder(),
                                    // isDense: true,
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
                                            fontWeight: FontWeight.w600,),
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
                      child: const Text('Next'),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Provider.of<InvoiceGeneratorProvider>(context,
                                  listen: false,)
                              .addCustomerDetails(
                            InvoiceGeneratorModel(
                              name: clientName.text,
                              street: clientStreet.text,
                              address: clientAddress.text,
                              phone: int.parse(clientPhone.text),
                              docType: dropdownDocTypeValue.toString(),
                              docCategory: dropdownCategoryValue.toString(),
                              gst: clientGst.text,
                            ),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddProductScreen(),
                            ),
                          );
                        }
                      },
                  ),
                ],
              ),
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

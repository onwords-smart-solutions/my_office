import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
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
            ),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
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
                    margin: const EdgeInsets.only(top: 20),
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
                            icon: Icon(Icons.person, color: Theme.of(context).primaryColor,),
                            maxLength: 45,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Customer Name';
                              }
                              return null;
                            },
                          ).textInputField(context),
                          CustomTextField(
                            controller: clientStreet,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            hintName: 'Client Location',
                            icon:  Icon(Iconsax.location5,color: Theme.of(context).primaryColor,),
                            maxLength: 50,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Customer Street';
                              }
                              return null;
                            },
                          ).textInputField(context),
                          CustomTextField(
                            controller: clientAddress,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            hintName: 'Client Address',
                            icon: Icon(Icons.location_city,color: Theme.of(context).primaryColor,),
                            maxLength: 100,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Customer Address';
                              }
                              return null;
                            },
                          ).textInputField(context),
                          CustomTextField(
                            controller: clientPhone,
                            textInputType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            hintName: 'Phone Number',
                            icon: Icon(Icons.call,color: Theme.of(context).primaryColor,),
                            maxLength: 10,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length != 10) {
                                return 'Please enter customer number';
                              }
                              return null;
                            },
                          ).textInputField(context),
                          CustomTextField(
                            controller: clientGst,
                            textInputType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                            hintName: 'GST (optional)',
                            icon: Icon(Icons.comment_bank,color: Theme.of(context).primaryColor,),
                            maxLength: 15,
                          ).textInputField(context),
                          const Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 160,
                                child: DropdownButtonFormField<String>(
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  hint: Text(
                                    "Doc-Type",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
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
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                width: 160,
                                child: DropdownButtonFormField<String>(
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                  ),
                                  hint: Text(
                                    "Category",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor,
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
                      child: Text('Next', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500,),),
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
        color: Theme.of(context).primaryColor.withOpacity(0.3),
        width: 1.5,
      ),
    );
  }

  OutlineInputBorder myFocusBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor.withOpacity(0.3),
        width: 1.5,
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Constant/fonts/constant_font.dart';
import '../model/client_model.dart';
import '../provider/providers.dart';
import 'document_preview_screen.dart';

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
    // 'IT',
    // 'DL',
    // 'SS',
    // 'WTA',
    // 'AG',
    // 'VC',
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
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Client Details',
          style: TextStyle(
           
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
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
                        TextFiledWidget(
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
                        ).textInputFiled(),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextFiledWidget(
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
                        ).textInputFiled(),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextFiledWidget(
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
                        ).textInputFiled(),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextFiledWidget(
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
                        ).textInputFiled(),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextFiledWidget(
                          controller: clientGst,
                          textInputType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          hintName: 'GST (optional)',
                          icon: const Icon(Icons.comment_bank),
                          maxLength: 20,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter Customer GST';
                          //   }
                          //   return null;
                          // },
                        ).textInputFiled(),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: size.width * 0.4,
                              child: DropdownButtonFormField<String>(
                                style: TextStyle(
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
                                    errorStyle: TextStyle(
                                         )),
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
                                          fontWeight: FontWeight.w600),
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
                GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      Provider.of<Invoice1Provider>(context, listen: false)
                          .addCustomerDetails(ClientModel(
                              name: clientName.text,
                              street: clientStreet.text,
                              address: clientAddress.text,
                              phone: int.parse(clientPhone.text),
                              // docType: dropdownDocTypeValue.toString(),
                              docType: 'QUOTATION',
                              docCategory: dropdownCategoryValue.toString(),
                              gst: clientGst.text));

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
                    height: size.height * 0.06,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
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

class TextFiledWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final String hintName;
  final Icon icon;
  final int maxLength;
  final bool? isEnable;
  final bool? isOptional;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;

  const TextFiledWidget({
    Key? key,
    required this.controller,
    required this.textInputType,
    required this.textInputAction,
    required this.hintName,
    required this.icon,
    required this.maxLength,
    this.validator,
    this.isEnable,
    this.isOptional,
    this.onTap,
  });

  Widget textInputFiled() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      maxLength: maxLength,
      enabled: isEnable,
      style: TextStyle(
        color: Colors.black,
       
      ),
      decoration: InputDecoration(
        counterText: '',
        prefixIcon: icon,
        hintText: hintName,
        labelText: hintName,
        labelStyle: TextStyle(
          color: Colors.black,
         
        ),
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.6),
         
        ),
        errorStyle: TextStyle(
         
        ),
        border: myInputBorder(),
        enabledBorder: myInputBorder(),
        focusedBorder: myFocusBorder(),
        disabledBorder: myDisabledBorder(),
      ),
      validator: validator,
      onTap: onTap,
    );
  }

  OutlineInputBorder myInputBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.3),
        width: 2,
      ),
    );
  }

  OutlineInputBorder myFocusBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.3),
        width: 2,
      ),
    );
  }

  OutlineInputBorder myDisabledBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.3),
        width: 2,
      ),
    );
  }
}

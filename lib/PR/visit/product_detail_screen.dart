import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:my_office/PR/visit/summary_notes.dart';
import 'package:my_office/util/screen_template.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _quotationController = TextEditingController();

  Map<String, bool> products = {
    'Smart Home': false,
    'Gate': false,
    'Door': false,
    'Tank': false,
    'Server': false,
    'Window': false,
  };

  @override
  void dispose() {
    _invoiceController.dispose();
    _quotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(bodyTemplate: buildScreen(), title: 'Product Detail');
  }

  Widget buildScreen() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * .35,
              child: buildProductSelection()),
          const Divider(height: 0.0),
          Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              child: buildQuotationInvoice()),
          const Divider(height: 0.0),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              child: buildProductImage()),
          const SizedBox(height: 30.0),
          buildNextButton(),
        ],
      ),
    );
  }

  Widget buildProductSelection() {
    return Column(
      children: [
        Text(
          'Choose Products',
          style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(0.0),
            physics: const BouncingScrollPhysics(),
            children: products.keys.map((String key) {
              return SizedBox(
                height: 38.0,
                child: CheckboxListTile(
                  checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  enableFeedback: true,
                  title: Text(
                    key,
                    style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),
                  ),
                  value: products[key],
                  onChanged: (data) {
                    setState(() {
                      products.update(key, (value) => data!);
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildProductImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          CircleAvatar(
              backgroundColor: ConstantColor.backgroundColor,
              radius: 20.0,
              child: IconButton(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    uploadProductImage();
                  },
                  icon: const Icon(
                    Icons.photo_camera_rounded,
                    color: Colors.white,
                    size: 20.0,
                  ))),
          Text(
            'Upload product image',
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium, fontSize: 15.0),
          ),
        ],
      ),
    );
  }

  Widget buildQuotationInvoice() {
    return Column(
      children: [
        //invoice
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Invoice'),
            const SizedBox(width: 20.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * .63,
              child: TextField(
                  controller: _invoiceController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    hintText: 'Invoice number',
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
                  ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10.0),
        //quotation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Quotation'),
            const SizedBox(width: 20.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * .63,
              child: TextField(
                  controller: _quotationController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    hintText: 'Quotation number',
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
                  )),
            )
          ],
        )
      ],
    );
  }

  Widget buildNextButton() {
    return SizedBox(
      height: 38.0,
      width: 120.0,
      child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const SummaryAndNotes()));
          },
          style: ElevatedButton.styleFrom(
              disabledBackgroundColor: ConstantColor.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              backgroundColor: ConstantColor.backgroundColor),
          child: const Text('Next')),
    );
  }

  //Dialog bottom
  void uploadProductImage() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    Navigator.of(ctx).pop();
                  },
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: SizedBox(
                    height: 70,
                    child: Row(
                      children: const [
                        SizedBox(width: 10),
                        Icon(Icons.photo_library_rounded,
                            color: Color(0xff8355B7)),
                        SizedBox(width: 15),
                        Text(
                          "Choose from library",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    Navigator.of(ctx).pop();
                  },
                  child: SizedBox(
                    height: 70,
                    child: Row(
                      children: const [
                        SizedBox(width: 10),
                        Icon(Icons.camera_alt_rounded,
                            color: Color(0xff8355B7)),
                        SizedBox(width: 15),
                        Text(
                          "Take photo",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

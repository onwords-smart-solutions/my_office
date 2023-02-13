import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timelines/timelines.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class SearchLeadsScreen extends StatefulWidget {
  const SearchLeadsScreen({Key? key}) : super(key: key);

  @override
  State<SearchLeadsScreen> createState() => _SearchLeadsScreenState();
}

class _SearchLeadsScreenState extends State<SearchLeadsScreen> {


  TextEditingController numberEditingController = TextEditingController();

  String? selectedValue;
  List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: height * 0.0,
            left: width * 0.0,
            right: width * 0.0,
            bottom: height * 0.06,
            child: Container(
              height: height * 0.95,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ConstantColor.background1Color,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Stack(
                children: [
                  /// Top circle
                  Positioned(
                    top: height * 0.05,
                    // left: width * 0.05,
                    right: width * 0.05,
                    child: const CircleAvatar(
                      backgroundColor: ConstantColor.backgroundColor,
                      radius: 20,
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  ///Top Text...
                  Positioned(
                    top: height * 0.05,
                    left: width * 0.05,
                    // right: width*0.0,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Hi Ganesh\n',
                            style: TextStyle(
                              fontFamily: ConstantFonts.poppinsMedium,
                              color: ConstantColor.blackColor,
                              fontSize: height * 0.030,
                            ),
                          ),
                          TextSpan(
                            text: 'Search leads here!',
                            style: TextStyle(
                              fontFamily: ConstantFonts.poppinsMedium,
                              color: ConstantColor.blackColor,
                              fontSize: height * 0.020,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Search Fields
                  Positioned(
                    top: height * 0.14,
                    left: width * 0.05,
                    right: width*0.05,
                    child: Container(
                      height: height*0.08,
                      width: width*0.5,
                      decoration: BoxDecoration(
                        color: ConstantColor.background1Color,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black.withOpacity(0.3),width: width*0.005)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: height*0.08,
                            width: width*0.7,
                            color: Colors.transparent,
                            child: Center(
                              child: TextFormField(
                                controller: numberEditingController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: ConstantFonts.poppinsMedium,fontSize: height*0.03,color: Colors.black),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: InputDecoration(
                                  suffixIcon: Image.asset('assets/search.png',scale: 3.5,),
                                  border: InputBorder.none,
                                  hintText: 'Search via phone number',
                                  hintStyle: TextStyle(fontFamily: ConstantFonts.poppinsMedium,fontSize: height*0.02,color: Colors.black.withOpacity(0.3))
                                ),
                              ),
                            ),
                          ),
                          VerticalDivider(
                            thickness: 1,
                            indent: height*0.02,
                            endIndent: height*0.02,
                            color: Colors.black,
                          ),
                         GestureDetector(
                             onTap: (){
                               setState(() {
                                 setState(() {
                                   showDialog(
                                     context: context,
                                     builder: (BuildContext context) {
                                       return AlertDialog(
                                         insetPadding: EdgeInsets.zero,
                                         backgroundColor: Colors.transparent,
                                         elevation: 0,
                                         content: StatefulBuilder(builder:
                                             (BuildContext context, StateSetter setState) {
                                           return Container(
                                             margin: EdgeInsets.only(top: height * 0.0),
                                             height: height * 0.6,
                                             width: width * 0.95,
                                             decoration: BoxDecoration(
                                               color: ConstantColor.background1Color,
                                                 borderRadius: BorderRadius.circular(20),
                                                ),
                                             child: Column(
                                               children: [
                                                 Padding(
                                                   padding: EdgeInsets.only(top: height*0.03),
                                                   child: DropdownButtonHideUnderline(
                                                     child: DropdownButton2(
                                                       isExpanded: true,
                                                       hint: Row(
                                                         children:  [
                                                           Icon(
                                                             Icons.list,
                                                             size: height*0.03,
                                                             color: ConstantColor.blackColor,
                                                           ),
                                                           SizedBox(
                                                             width: width*0.06,
                                                           ),
                                                           AutoSizeText(
                                                             'Select Item',
                                                             style: TextStyle(
                                                               fontSize: height*0.02,
                                                               fontFamily: ConstantFonts.poppinsMedium,
                                                               color: ConstantColor.blackColor,
                                                             ),
                                                             // overflow: TextOverflow.ellipsis,
                                                           ),
                                                         ],
                                                       ),
                                                       items: items
                                                           .map((item) =>
                                                           DropdownMenuItem<String>(
                                                             value: item,
                                                             alignment: Alignment.center,
                                                             child: AutoSizeText(
                                                               item,
                                                               style: TextStyle(
                                                                   fontSize: height*0.02,
                                                                   color: ConstantColor.blackColor,
                                                                   fontFamily: ConstantFonts.poppinsMedium
                                                               ),
                                                               // overflow: TextOverflow.ellipsis,
                                                             ),
                                                           ),
                                                       )
                                                           .toList(),
                                                       value: selectedValue,
                                                       onChanged: (value) {
                                                         setState(() {
                                                           selectedValue = value as String;
                                                         });
                                                       },
                                                       icon: const Icon(
                                                         Icons.arrow_forward_ios,
                                                       ),
                                                       iconSize: height*0.02,
                                                       iconEnabledColor: ConstantColor.blackColor,
                                                       iconDisabledColor: Colors.grey,
                                                       buttonHeight: height*0.08,
                                                       buttonWidth: width*0.6,
                                                       buttonPadding: const EdgeInsets.only(left: 10, right: 10),
                                                       buttonDecoration: BoxDecoration(
                                                         borderRadius: BorderRadius.circular(14),
                                                         border: Border.all(
                                                           color: Colors.black26,
                                                         ),
                                                         color: ConstantColor.background1Color,
                                                       ),
                                                       itemHeight: height*0.05,
                                                       itemPadding:  EdgeInsets.only(left: width*0.2, right: width*0.2),
                                                       dropdownMaxHeight: height*0.5,
                                                       dropdownWidth: width*0.63,
                                                       dropdownPadding: null,
                                                       dropdownDecoration: BoxDecoration(
                                                           borderRadius: BorderRadius.circular(20)
                                                       ),
                                                       //
                                                       // elevation: 8,
                                                       style: TextStyle(fontFamily: ConstantFonts.poppinsMedium,fontSize: height*0.02,color: Colors.black.withOpacity(0.3)),
                                                       scrollbarRadius: const Radius.circular(20),
                                                       scrollbarThickness: 5,
                                                       scrollbarAlwaysShow: true,
                                                       offset: const Offset(-6, 0),
                                                     ),
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           );
                                         }),
                                       );
                                     },
                                   );
                                 });
                               });
                         },
                             child: Image.asset('assets/filter.png',scale: 3.5,))
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: height * 0.25,
                    left: width * 0.01,
                    right: width*0.01,
                    bottom: height * 0.008,
                    child: contentContainer(height, width),
                  ),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GridView contentContainer(double height, double width) {
    return GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 1 / 0.1,
                          mainAxisExtent: 40 / 0.1,
                      ),
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(

                          height: height * 0.3,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ConstantColor.background1Color,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(-0.0, 5.0),
                                blurRadius: 8,
                              )
                            ],
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(vertical: height*0.02),
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FixedTimeline.tileBuilder(
                                  theme: TimelineThemeData(color: ConstantColor.backgroundColor.withOpacity(0.8),connectorTheme: ConnectorThemeData(color: ConstantColor.blackColor.withOpacity(0.3))),
                                  builder: TimelineTileBuilder.connectedFromStyle(
                                    contentsAlign: ContentsAlign.basic,
                                    contentsBuilder: (context, index) =>  Container(
                                      margin: EdgeInsets.only(top: height*0.01,left: width*0.02),
                                      width: width*0.4,
                                      height: height*0.038,
                                      color: Colors.transparent,
                                      child: AutoSizeText(
                                        'opposite contents', style: TextStyle(
                                        fontFamily: ConstantFonts.poppinsMedium,
                                        color: ConstantColor.blackColor,
                                      ),
                                        maxFontSize: 18,
                                        minFontSize: 10,
                                      ),
                                    ),
                                    oppositeContentsBuilder: (context, index) => Container(
                                      margin: EdgeInsets.only(top: height*0.01),
                                    width: width*0.4,
                                    height: height*0.038,
                                    color: Colors.transparent,
                                    child: AutoSizeText(
                                    'opposite contents', style: TextStyle(
                                    fontFamily: ConstantFonts.poppinsMedium,
                                    color: ConstantColor.blackColor,
                                    ),
                                      maxFontSize: 18,
                                      minFontSize: 10,
                                    ),
                                  ),
                                    connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
                                    indicatorStyleBuilder: (context, index) => IndicatorStyle.outlined,

                                    itemCount: 10,
                                ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
  }
}


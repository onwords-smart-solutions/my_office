import 'package:flutter/material.dart';

import '../Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
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
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Hi Admin\n',
                    style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      color: ConstantColor.blackColor,
                      fontSize: height * 0.030,
                    ),
                  ),
                  TextSpan(
                    text: 'Onyx Announcement',
                    style: TextStyle(
                      fontFamily: ConstantFonts.poppinsMedium,
                      color: ConstantColor.blackColor,
                      fontSize: height * 0.020,
                    ),
                  ),
                ]),
              ),
            ),
            Positioned(
              top: height *  0.28,
              // left: width * 0.05,
              right: width * 0.33,
              child: Image.asset('assets/human with speaker.png',scale: 2.9,),),
            Positioned(
              top: height * 0.13,
              left: width * 0.05,
              right: width * 0.05,
              bottom: height * 0,
              child: textFieldWidget(height, width, 'Type Here', '', Image.asset('assets/speaker.png',scale: 3.0,), textEditingController, TextInputType.text, TextInputAction.done)),


          ],
        ),
      ),
    );
  }

  Widget textFieldWidget(
      double height,
      double width,
      String name,
      String title,
      Image image,
      TextEditingController textEditingController,
      TextInputType inputType,
      TextInputAction action) {
    return Container(
      height: height * 0.15,
      width: width * 0.8,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: ConstantColor.blackColor,
              fontFamily: ConstantFonts.poppinsMedium,
            ),
          ),
          SizedBox(
            height: height*0.07,
            child: TextFormField(
              controller: textEditingController,
              textInputAction: action,
              keyboardType: inputType,
              autocorrect: true,
              style: TextStyle(
                color: ConstantColor.blackColor,
                fontFamily: ConstantFonts.poppinsMedium,
              ),
              decoration: InputDecoration(
                hintText: name,
                suffixIcon: GestureDetector(
                  onTap: (){
                    setState(() {
                      print('hiii');
                    });
                  },
                  child: image,

                ),

                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.2),
                    fontFamily: ConstantFonts.poppinsMedium),
                filled: true,
                fillColor: ConstantColor.background1Color,
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}

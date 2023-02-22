

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/util/screen_template.dart';

import '../../Constant/fonts/constant_font.dart';

class SummaryAndNotes extends StatefulWidget {
  const SummaryAndNotes({Key? key}) : super(key: key);

  @override
  State<SummaryAndNotes> createState() => _SummaryAndNotesState();
}

class _SummaryAndNotesState extends State<SummaryAndNotes> {

  File? image;

  TextEditingController summaryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController totalKMController = TextEditingController();

  Future picImageFromGallery() async {
    try{
      final image =  await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      e;
    }



  }

  Future picImageFromCamara() async {
    try{
      final image =  await ImagePicker().pickImage(source: ImageSource.camera);
      if(image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      e;
    }



  }

  void uploadKMImage(double height, double width) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Container(
          margin:  EdgeInsets.symmetric(horizontal: width*0.01),
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
                    picImageFromGallery();
                    Navigator.of(ctx).pop();
                  },
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: SizedBox(
                    height: height*0.07,
                    child: Row(
                      children:  [
                        SizedBox(width: width * 0.05),
                        const Icon(Icons.photo_library_rounded,
                            color: Color(0xff8355B7)),
                        SizedBox(width: width * 0.05),
                        Text(
                          "Choose from library",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: ConstantFonts.poppinsMedium,
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
                    picImageFromCamara();
                    Navigator.of(ctx).pop();
                  },
                  child: SizedBox(
                    height: height *0.07,
                    child: Row(
                      children:  [
                        SizedBox(width: width * 0.05),
                        const Icon(Icons.camera_alt_rounded,
                            color: Color(0xff8355B7)),
                        SizedBox(width: width * 0.05),
                        Text(
                          "Take photo",
                          style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium,
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ScreenTemplate(bodyTemplate: bodyContent(height, width), title: 'Summary And Notes');
  }
  Widget bodyContent(double height,double width){
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          summaryFiled(height, width),
          dateFiled(height, width),
          kmAndImagePicWidget(height, width),
          totalKmFiled(height, width),
          submitButtonWidget(height, width),
        ],
      ),
    );
  }

  Widget summaryFiled(double height, double width) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height*0.01),
      height: height*0.25,
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        children: [
          TextField(
              controller: summaryController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              maxLines: 8,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: 'Add Summary',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    width: width*0.003,
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
        ],
      ),
    );
  }

  Widget dateFiled(double height, double width) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height*0.01),
      padding: EdgeInsets.symmetric(horizontal: width*0.03),
      height: height*0.08,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12,width: width*0.003)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Estimate Date\nof Installation',style: TextStyle(fontFamily: ConstantFonts.poppinsMedium,fontSize: 10),),
          Text(':',style: TextStyle(fontFamily: ConstantFonts.poppinsMedium,fontSize: 18),),
          SizedBox(
            width: width*0.6,
            child: TextFormField(
              controller: dateController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.datetime,
              textAlign: TextAlign.center,
              readOnly: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: 'Enter Date',
                hintStyle: TextStyle(
                  fontSize: 13,
                  fontFamily: ConstantFonts.poppinsMedium,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    width: width*0.003,
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
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context, initialDate: DateTime.now(),
                  firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101),
                );
                if(pickedDate != null ){
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    dateController.text = formattedDate; //set output date to TextField value.
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget submitButtonWidget(double height, double width) {
    return GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(top: height * 0.10),
            height: height * 0.07,
            width: width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Color(0xffD136D4),
                  Color(0xff7652B2),
                ],
              ),
            ),
            child: Center(
              child: Text(
                'Submit',
                style: TextStyle(
                    fontFamily: ConstantFonts.poppinsMedium,
                    fontSize: height * 0.025,
                    color: Colors.white),
              ),
            ),
          ),
        );
  }

  Widget kmAndImagePicWidget(double height, double width) {
    return Container(
            margin: EdgeInsets.symmetric(vertical: height*0.02),
            // padding: const EdgeInsets.all(10),
            // height: height*0.1,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                endKmFiled(height, width),
                uploadImageWidget(height, width),
              ],
            ),
          );
  }

  Widget endKmFiled(double height, double width) {
    return Container(
        height: height*0.13,
        width: width*0.55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12,width: width*0.003)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('End Km',style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: totalKMController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 3,
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    hintText: 'Enter End of Km',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      fontFamily: ConstantFonts.poppinsMedium,
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
                  )),
            ),
          ],
        )
    );
  }

  Widget uploadImageWidget(double height, double width) {
    return Container(
                height: height*0.13,
                width: width*0.35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),

                    border: Border.all(color: Colors.black12,width: width*0.003),
                ),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [

                   image != null ? Container(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(30),),
                     child: Image.file(image!,
                       height: height*0.08,
                       width: width*0.25,
                       fit: BoxFit.cover,
                     ),
                   ) : CircleAvatar(
                        backgroundColor: ConstantColor.backgroundColor,
                        radius: 20.0,
                        child:  IconButton(
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              uploadKMImage(height, width);
                            },
                            icon: const Icon(
                              Icons.photo_camera_rounded,
                              color: Colors.white,
                              size: 20.0,
                            ),),),
                    Center(
                      child: Text(
                        'Upload End Km Pic',
                        style: TextStyle(
                            fontFamily: ConstantFonts.poppinsMedium, fontSize: 10.0),
                      ),
                    ),
                  ],
                ),
              );
  }

  Widget totalKmFiled(double height, double width) {
    return Container(
        margin: EdgeInsets.only(top: height*0.01),
        height: height*0.05,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12,width: width*0.003)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Total Km is  :',style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),),
            Text('150 Km',style: TextStyle(fontFamily: ConstantFonts.poppinsMedium),),
          ],
        )
    );
  }


}

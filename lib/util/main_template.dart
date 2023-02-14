import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import '../Constant/fonts/constant_font.dart';

class MainTemplate extends StatelessWidget {
  final Widget templateBody;
  final String name;
  final String subtitle;
  final Color bgColor;
  final Widget? bottomImage;

  const MainTemplate(
      {Key? key,
      required this.name,
      required this.subtitle,
      required this.templateBody,
      required this.bgColor,
      this.bottomImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Positioned(
              top: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * .93,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top * 1.5),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Name and subtitle
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi $name',
                                  style: TextStyle(
                                    fontFamily: ConstantFonts.poppinsMedium,
                                    fontSize: 24.0,
                                  ),
                                ),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    fontFamily: ConstantFonts.poppinsMedium,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),

                            //Profile icon
                            const CircleAvatar(
                              radius: 20.0,
                              backgroundColor: ConstantColor.backgroundColor,
                              foregroundColor: Colors.white,
                              child: Icon(Iconsax.user),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25.0),

                      //Custom widget section
                      Expanded(child: templateBody),
                    ],
                  ),
                ),
              ),
            ),
            //Illustration at the bottom
            if(bottomImage!=null)
            bottomImage!,
          ],
        ),
      ),
    );
  }
}

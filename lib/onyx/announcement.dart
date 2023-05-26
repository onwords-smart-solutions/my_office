
import 'package:flutter/material.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  TextEditingController textEditingController = TextEditingController();
  final PageController pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _updateCurrentPageIndex(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  bool _isLastPage() {
    return _currentPageIndex ==  _list.length -1;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: const BouncingScrollPhysics(),
              allowImplicitScrolling: true,
              scrollDirection: Axis.horizontal,
              controller: pageController,
              onPageChanged: _updateCurrentPageIndex,
              children: _list,
            ),
          ),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      if (_isLastPage()) {
                        setState(() {
                          // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>UserHomeScreen()), (route) => false);
                        });
                      } else {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 30,
                    ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  final List<Widget> _list = <Widget>[
    Pages(
        title: 'Set up Devices Easily',
        subTitle:
            'Link your home devices by plugging them and connect to Wi-Fi Control them all using smart things app',
        image: Image.asset('assets/intro_1.png')),
    Pages(
        title: 'Automate Easier',
        subTitle:
            'Create scenes you like Switch through different scenes and quick actions and make your life smarter',
        image: Image.asset('assets/intro_3.png')),
    Pages(
        title: 'Single tab control',
        subTitle:
            'Control your home from any where in as Single touch with smart things app ',
        image: Image.asset('assets/intro_2.png')),
  ];

// Container(
//   height: height * 0.95,
//   width: double.infinity,
//   decoration: const BoxDecoration(
//       color: ConstantColor.background1Color,
//       borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30))),
//   child: Stack(
//     children: [
//       /// Top circle
//       Positioned(
//         top: height * 0.05,
//         // left: width * 0.05,
//         right: width * 0.05,
//         child: const CircleAvatar(
//           backgroundColor: ConstantColor.backgroundColor,
//           radius: 20,
//           child: Icon(
//             Icons.person_rounded,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       ///Top Text...
//       Positioned(
//         top: height * 0.05,
//         left: width * 0.05,
//         // right: width*0.0,
//         child: RichText(
//           text: TextSpan(children: [
//             TextSpan(
//               text: 'Hi Admin\n',
//               style: TextStyle(
//                 fontFamily: ConstantFonts.poppinsMedium,
//                 color: ConstantColor.blackColor,
//                 fontSize: height * 0.030,
//               ),
//             ),
//             TextSpan(
//               text: 'Onyx Announcement',
//               style: TextStyle(
//                 fontFamily: ConstantFonts.poppinsMedium,
//                 color: ConstantColor.blackColor,
//                 fontSize: height * 0.020,
//               ),
//             ),
//           ]),
//         ),
//       ),
//       Positioned(
//         top: height *  0.28,
//         // left: width * 0.05,
//         right: width * 0.33,
//         child: Image.asset('assets/human with speaker.png',scale: 2.9,),),
//       Positioned(
//         top: height * 0.13,
//         left: width * 0.05,
//         right: width * 0.05,
//         bottom: height * 0,
//         child: textFieldWidget(height, width, 'Type Here', '', Image.asset('assets/speaker.png',scale: 3.0,), textEditingController, TextInputType.text, TextInputAction.done)),
//
//
//     ],
//   ),
// ),
// Widget textFieldWidget(
//     double height,
//     double width,
//     String name,
//     String title,
//     Image image,
//     TextEditingController textEditingController,
//     TextInputType inputType,
//     TextInputAction action) {
//   return Container(
//     height: height * 0.15,
//     width: width * 0.8,
//     color: Colors.transparent,
//     child: Column(
//       crossAxisAlignment:CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             color: ConstantColor.blackColor,
//             fontFamily: ConstantFonts.poppinsMedium,
//           ),
//         ),
//         SizedBox(
//           height: height*0.07,
//           child: TextFormField(
//             controller: textEditingController,
//             textInputAction: action,
//             keyboardType: inputType,
//             autocorrect: true,
//             style: TextStyle(
//               color: ConstantColor.blackColor,
//               fontFamily: ConstantFonts.poppinsMedium,
//             ),
//             decoration: InputDecoration(
//               hintText: name,
//               suffixIcon: GestureDetector(
//                 onTap: (){
//                   setState(() {
//                     print('hiii');
//                   });
//                 },
//                 child: image,
//
//               ),
//
//               hintStyle: TextStyle(
//                   color: Colors.black.withOpacity(0.2),
//                   fontFamily: ConstantFonts.poppinsMedium),
//               filled: true,
//               fillColor: ConstantColor.background1Color,
//               enabledBorder: const OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                 borderSide: BorderSide(color: Colors.black, width: 1),
//               ),
//               focusedBorder: const OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                 borderSide: BorderSide(color: Colors.black, width: 1),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

}

class Pages extends StatelessWidget {
  final String title;
  final String subTitle;
  final Image image;

  const Pages(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 450,
          width: double.infinity,
          // color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(child: image),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20),
          height: 180,
          width: double.infinity,
          // color: Colors.cyan,
          child: Center(
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(children: [
                TextSpan(
                    text: '$title\n\n',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25)),
                TextSpan(
                    text: subTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black26,
                        fontSize: 15))
              ]),
            ),
          ),
        ),
      ],
    );
  }
}

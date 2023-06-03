import 'dart:developer';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:my_office/database/hive_operations.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Account/account_screen.dart';
import '../Constant/fonts/constant_font.dart';

class MainTemplate extends StatefulWidget {
  final Widget templateBody;
  final String subtitle;
  final Color bgColor;
  final Widget? bottomImage;

  const MainTemplate(
      {Key? key,
      required this.subtitle,
      required this.templateBody,
      required this.bgColor,
      this.bottomImage})
      : super(key: key);

  @override
  State<MainTemplate> createState() => _MainTemplateState();
}

class _MainTemplateState extends State<MainTemplate> {
  final HiveOperations _hiveOperations = HiveOperations();
  StaffModel? staffInfo;

  void getStaffDetail() async {
    final data = await _hiveOperations.getStaffDetail();
    setState(() {
      staffInfo = data;
    });
  }

  SharedPreferences? preferences;

  String preferencesImageUrl = '';

  // String preferencesImageUrl2 = '';

  Future getImageUrl() async {
    preferences = await SharedPreferences.getInstance();
    // String? image = preferences?.getString('imageValue');
    String? imageNet = preferences?.getString('imageValueNet');
    if (imageNet == null) return;
    setState(() {
      // preferencesImageUrl = image.toString();
      preferencesImageUrl = imageNet;
      // print(preferencesImageUrl2);
    });
  }

  @override
  void initState() {
    getStaffDetail();
    getImageUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffDDE6E8),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Positioned(
              top: 0,
              child: Container(
                height: height * 1,
                width: width,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top * 1.1),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(0.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                color: Colors.transparent,
                                depth: 5,
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(20),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Name and subtitle
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          staffInfo == null
                                              ? 'Hi'
                                              : 'Hi ${staffInfo!.name}',
                                          style: TextStyle(
                                              fontFamily: ConstantFonts
                                                  .poppinsRegular,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                                  .withOpacity(0.8)),
                                        ),
                                        Text(
                                          widget.subtitle,
                                          style: TextStyle(
                                              fontFamily:
                                                  ConstantFonts.poppinsMedium,
                                              fontSize: 14.0,
                                              color: Colors.black
                                                  .withOpacity(0.8)),
                                        ),
                                      ],
                                    ),

                                    //Profile icon
                                    GestureDetector(
                                      onTap: () {
                                        // getImageUrl();
                                        HapticFeedback.mediumImpact();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) => AccountScreen(
                                                    staffDetails:
                                                        staffInfo!)));
                                      },
                                      child: SizedBox(
                                        height: height * 0.065,
                                        width: height * 0.065,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: StreamBuilder(
                                              stream: FirebaseDatabase
                                                  .instance
                                                  .ref(
                                                      'staff/${staffInfo?.uid ?? 0}')
                                                  .onValue,
                                              builder: (ctx, snapShot) {
                                                if (snapShot.hasData) {
                                                  if(snapShot.data!.snapshot.value != null){
                                                    final data = snapShot.data!
                                                        .snapshot.value
                                                    as Map<Object?,
                                                        Object?>;
                                                    final url =
                                                    data['profileImage'];
                                                    if (url != null) {
                                                      return CachedNetworkImage(
                                                        imageUrl:
                                                        url.toString(),
                                                        fit: BoxFit.cover,
                                                        progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                            CircularProgressIndicator(
                                                                value: downloadProgress
                                                                    .progress),
                                                        errorWidget: (context,
                                                            url, error) =>
                                                        const Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                }
                                                return const Image(
                                                    image: AssetImage(
                                                        'assets/profile_icon.jpg'));
                                              },
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.001),
                      //Custom widget section
                      Expanded(child: widget.templateBody),
                    ],
                  ),
                ),
              ),
            ),
            //Illustration at the bottom
            if (widget.bottomImage != null) widget.bottomImage!,
          ],
        ),
      ),
    );
  }
}

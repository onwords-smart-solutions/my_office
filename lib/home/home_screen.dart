import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/leave_approval/leave_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Absentees/absentees.dart';
import '../Constant/fonts/constant_font.dart';
import '../leads/search_leads.dart';
import '../leave_apply/leave_apply_screen.dart';
import '../onyx/announcement.dart';
import '../refreshment/refreshment.dart';
import '../work_done/work_complete.dart';
import '../work_manager/work_entry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final staff = FirebaseDatabase.instance.ref().child("staff");
  final fingerPrint = FirebaseDatabase.instance.ref().child("fingerPrint");
  final user = FirebaseAuth.instance.currentUser;


  String? nowUser;
  // ignore: prefer_typing_uninitialized_variables
  var firebaseData;
  // ignore: prefer_typing_uninitialized_variables
  var userName;
  // ignore: prefer_typing_uninitialized_variables
  var department;

  bool fingerPrintStatus = false;

  String? name = '';
  String email = '';
  SharedPreferences? preferences;


  getNameAndDep() {
    staff.child(user!.uid).once().then((value) => {
      firebaseData = value.snapshot.value,
      if (firebaseData["email"] == nowUser){
        setState(() {
            userName = firebaseData['name'];
            department = firebaseData['department'];
          }),
        }
    }).then((value) => setValues());
  }


  Future setValues() async {
    preferences = await SharedPreferences.getInstance();
    preferences?.setString('name', '$userName');
    preferences?.setString('email', '$nowUser');
    preferences?.setString('department', '$department');
    String? names = preferences?.getString('name');
    setState(() {
      name = names!;
      // print(name);
    });
  }




  @override
  void initState() {
    setValues();
    // todayDate();
    // getFingerPrint();
    // getConnectivity();
    nowUser = user?.email;
    getNameAndDep();
    super.initState();
  }

  @override
  void dispose() {
    // subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Container(
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
                  right: width*0.30,
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: userName == null ? 'Hii\n' :'Hi $userName\n',
                        style: TextStyle(
                          fontFamily: ConstantFonts.poppinsMedium,
                          color: ConstantColor.blackColor,
                          fontSize: height * 0.030,
                        ),
                      ),
                      TextSpan(
                        text: 'Choose your destination here !',
                        style: TextStyle(
                          fontFamily: ConstantFonts.poppinsMedium,
                          color: ConstantColor.blackColor,
                          fontSize: height * 0.020,
                        ),
                      ),
                    ]),
                  ),
                ),

                ///Grid View...
                Positioned(
                  top: height * 0.13,
                  left: width * 0.05,
                  right: width * 0.05,
                  bottom: height * 0.01,
                  child: GridView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 3 / 0.3,
                            mainAxisSpacing: 4 / 0.3,
                            mainAxisExtent: 20 / 0.1
                            // childAspectRatio: 3.0

                            ),
                    children: [
                      buttonContainerWidget(
                          height,
                          width,
                          'Work Manager',
                          Image.asset(
                            'assets/work_entry.png',
                            scale: 3.5,
                          ),
                          const WorkEntryScreen()),
                      buttonContainerWidget(
                          height,
                          width,
                          'Refreshment',
                          Image.asset(
                            'assets/refreshment.png',
                            scale: 3.8,
                          ),
                          const RefreshmentsScreen()),
                      buttonContainerWidget(
                          height,
                          width,
                          'Leave form',
                          Image.asset('assets/leave_apply.png'),
                          const LeaveApplyScreen()),
                      buttonContainerWidget(
                          height,
                          width,
                          'Search leads',
                          Image.asset(
                            'assets/lead search.png',
                            scale: 3.0,
                          ),
                          const SearchLeadsScreen()),
                      // buttonContainerWidget(
                      //     height,
                      //     width,
                      //     'View leads',
                      //     Image.asset(
                      //       'assets/view_leads.png',
                      //       scale: 3.0,
                      //     ),
                      //     const LoginScreen()),
                      buttonContainerWidget(
                          height,
                          width,
                          'Onyx',
                          Image.asset(
                            'assets/onxy.png',
                            scale: 3.4,
                          ),
                          const AnnouncementScreen()),
                      buttonContainerWidget(
                          height,
                          width,
                          'Work done',
                          Image.asset(
                            'assets/work_entry.png',
                            scale: 3.5,
                          ),
                          const WorkCompleteViewScreen()),
                      buttonContainerWidget(
                          height,
                          width,
                          'Absent Details',
                          Image.asset(
                            'assets/lead search.png',
                            scale: 3.0,
                          ),
                          const AbsenteeScreen()),
                      buttonContainerWidget(
                          height,
                          width,
                          'Leave Approval page',
                          Image.asset(
                            'assets/leave form.png',
                            scale: 4.0,
                          ),
                          const LeaveApprovalScreen(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buttonContainerWidget(
      double height, double width, String name, Image image, Widget page) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffDAD6EE).withOpacity(0.5),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(child: image),
            AutoSizeText(
              name,
              style: TextStyle(
                fontFamily: ConstantFonts.poppinsMedium,
                color: ConstantColor.blackColor,
                // fontSize: height * 0.02,
              ),
              maxFontSize: 18,
              minFontSize: 10,
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/utilities/custom_widgets/custom_snack_bar.dart';
import '../../../../core/utilities/custom_widgets/custom_text_field.dart';
import 'installation_pdf_screen.dart';

class InstallationDetails extends StatefulWidget {
  const InstallationDetails({super.key});

  @override
  State<InstallationDetails> createState() => _InstallationDetailsState();
}

class _InstallationDetailsState extends State<InstallationDetails> {
  final formKey = GlobalKey<FormState>();

  List<AjaxListModel> ajaxDeviceDetails = [];

  TextEditingController customerIdController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController dateOfInstallationController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordsController = TextEditingController();
  TextEditingController motorModelNumController = TextEditingController();
  TextEditingController extraRemoteController = TextEditingController();
  TextEditingController installationMembersController = TextEditingController();
  TextEditingController addDataToListController = TextEditingController();
  TextEditingController otherDeviceNameController = TextEditingController();
  TextEditingController wifiNameController = TextEditingController();
  TextEditingController wifiPasswordNameController = TextEditingController();
  TextEditingController routerUidController = TextEditingController();
  TextEditingController routerPasswordController = TextEditingController();
  TextEditingController serverController = TextEditingController();
  TextEditingController localIpController = TextEditingController();
  TextEditingController staticIpController = TextEditingController();
  TextEditingController serverPortController = TextEditingController();
  TextEditingController voiceConfigUIDController = TextEditingController();
  TextEditingController voiceConfigPassController = TextEditingController();
  TextEditingController bSNLUIDController = TextEditingController();
  TextEditingController bSNLPassController = TextEditingController();
  TextEditingController heavyLoadR1Controller = TextEditingController();
  TextEditingController heavyLoadR2Controller = TextEditingController();
  TextEditingController fanR1Controller = TextEditingController();
  TextEditingController fanR2Controller = TextEditingController();
  TextEditingController ajaxAccountUidController = TextEditingController();
  TextEditingController ajaxItemController = TextEditingController();
  TextEditingController ajaxItemCountController = TextEditingController();
  TextEditingController motorBrandNameController = TextEditingController();

  List<String> teamMembersName = [];
  List<String> extraDevice = [];
  List<String> lightBoard8ChannelDetails = [];
  List<String> lightBoard4ChannelDetails = [];
  List<String> heavyBoard2Channel = [];
  List<String> fanBoard = [];

  String selectedGAType = '';
  String needApp = '';
  String needSmartHome = '';
  String needGate = '';
  String needAjax = '';
  String portForwarding = '';
  String voiceConfig = '';
  String bSNL = '';
  String r1 = '';
  String r2 = '';
  String r3 = '';
  String r4 = '';
  List<String> gateType = [
    'ARM-GA',
    'SLIDING-GA',
    'ROLLER-GA',
  ];
  List<String> optionValue = [
    'Yes',
    'No',
  ];
  List<String> channelPointOut = [
    'Open',
    'Close',
    'Pause',
    'Single Gate',
    'Double Gate',
    'Nothing',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDDE6E8),
        centerTitle: true,
        title: const Text(
          'Installation Details',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      backgroundColor: const Color(0xffDDE6E8),
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(10),
              children: [
                customerDetails(),
                if (needSmartHome == 'Yes') wifiAndRouterDetails(context),
                if (needSmartHome == 'Yes') serverDetails(context),
                if (needGate == 'Yes') gateDetails(context),
                if (needSmartHome == 'Yes') light8ChannelDetails(context),
                if (needSmartHome == 'Yes') light4ChannelDetails(context),
                if (needSmartHome == 'Yes') heavyAndFanDetails(context),
                if (needAjax == 'Yes') ajaxItemDetails(context),
                crewMembersDetails(context),
                otherDeviceDetails(context),
                SizedBox(
                  height: size.height * 0.1,
                ),
              ],
            ),
            pdfButton(),
          ],
        ),
      ),
    );
  }

  Widget pdfButton() {
    final size = MediaQuery.sizeOf(context);
    return Positioned(
      bottom: 15,
      right: 15,
      child: teamMembersName.isEmpty
          ? const SizedBox()
          // : GestureDetector(
          : ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Material(
                child: InkWell(
                  highlightColor: Colors.cyanAccent.withAlpha(100),
                  splashColor: Colors.black,
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      InstallationDetailsScreen data =
                          InstallationDetailsScreen(
                        customerName: customerNameController.text,
                        id: customerIdController.text,
                        number: int.parse(phoneNumController.text),
                        address: addressController.text,
                        // entryDate: DateTime.parse(dateController.text),
                        installationDate:
                            DateTime.parse(dateOfInstallationController.text),
                        needApp: needApp.toString(),
                        email: emailController.text,
                        password: passwordsController.text,
                        gateType: selectedGAType.toString(),
                        motorId: motorModelNumController.text.toUpperCase(),
                        extraRemote: extraRemoteController.text.isNotEmpty
                            ? int.parse(extraRemoteController.text)
                            : 0,
                        r1: r1.toString(),
                        r2: r2.toString(),
                        r3: r3.toString(),
                        r4: r4.toString(),
                        nameList: teamMembersName.toList(),
                        deviceList: extraDevice.toList(),
                        userID: userIdController.text,
                        routerID: routerUidController.text,
                        routerPassword: routerPasswordController.text,
                        wifiName: wifiNameController.text,
                        wifiPassword: wifiPasswordNameController.text,
                        server: serverController.text,
                        portForwarding: portForwarding.toString(),
                        localIp: localIpController.text.isNotEmpty
                            ? double.parse(localIpController.text.toString())
                            : 0,
                        staticIp: staticIpController.text.isNotEmpty
                            ? double.parse(staticIpController.text)
                            : 0,
                        serverPort: serverPortController.text.isNotEmpty
                            ? double.parse(serverPortController.text)
                            : 0,
                        needSmartHome: needSmartHome,
                        voiceConfig: voiceConfig,
                        voiceUID: voiceConfigUIDController.text,
                        voicePass: voiceConfigPassController.text,
                        bSNL: bSNL,
                        bSNLUid: bSNLUIDController.text,
                        bSNLPass: bSNLPassController.text,
                        channel8List: lightBoard8ChannelDetails.toList(),
                        channel4List: lightBoard4ChannelDetails.toList(),
                        heavyR1: heavyLoadR1Controller.text,
                        heavyR2: heavyLoadR2Controller.text,
                        fanR1: fanR1Controller.text,
                        fanR2: fanR2Controller.text,
                        ajaxProductList: ajaxDeviceDetails,
                        needAjax: needAjax,
                        needGate: needGate,
                        ajaxUId: ajaxAccountUidController.text,
                        motorBrand: motorBrandNameController.text,
                      );

                      final pdfFile = await data.generate(ajaxDeviceDetails);
                      final dir = await getExternalStorageDirectory();
                      final file = File(
                        "${dir!.path}/${customerNameController.text}.pdf",
                      );

                      file.writeAsBytesSync(
                        pdfFile.readAsBytesSync(),
                        flush: true,
                      );

                      OpenFile.open(file.path).then((value) {
                        // Navigator.pop(context);
                      });
                      // log(teamMembersName.length.toString());
                    } else {
                      const snackBar = SnackBar(
                        content: Center(
                          child: Text('Fill Required Field'),
                        ),
                        backgroundColor: (Colors.redAccent),
                        // action: SnackBarAction(
                        //   label: 'dismiss',
                        //   onPressed: () {
                        //   },
                        // ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  // child: Container(
                  child: Ink(
                    height: size.height * 0.06,
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                      color: const Color(0xff5AC8FA),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.save,
                        ),
                        Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget otherDeviceDetails(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          collapsedBackgroundColor: const Color(0xff5AC8FA).withAlpha(100),
          title: const Text(
            "Other Device",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: const Icon(
            Icons.devices,
            color: Colors.black,
          ),
          //add icon
          children: [
            Container(
              height: size.height * 0.35,
              decoration: BoxDecoration(
                // color: Colors.blueGrey.withAlpha(50),
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(color: Colors.black12, width: .5),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ///Add Team Members
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Add Other Device Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: const Color(0xff5AC8FA),
                          radius: 20,
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                addDataToList(
                                  context,
                                  'Other Device',
                                  CustomTextField(
                                    controller: addDataToListController,
                                    textInputType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    hintName: 'Device Name',
                                    icon: const Icon(Icons.person_2),
                                    maxLength: 50,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                  ).textInputField(context),
                                  addDataToListController,
                                  extraDevice,
                                );
                              },
                              icon: const Icon(
                                Icons.add,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                
                    const Divider(
                      endIndent: 1,
                      indent: 1,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: size.height * 0.2,
                      child: extraDevice.isNotEmpty
                          ? ListView.builder(
                              itemCount: extraDevice.length,
                              itemBuilder: (context, int index) {
                                return Center(
                                  child: ListTile(
                                    leading: Text(
                                      "${index + 1} : ",
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    title: Text(
                                      extraDevice[index].toString(),
                                      style: const TextStyle(),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text(
                                              'Delete this name?\n${extraDevice[index]}',
                                              style: const TextStyle(),
                                              textAlign: TextAlign.center,
                                            ),
                                            content: SizedBox(
                                              height: size.height * 0.05,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                children: [
                                                  ActionChip(
                                                    onPressed: () {
                                                      extraDevice.removeAt(index);
                                                      Navigator.pop(context);
                                                      setState(() {});
                                                    },
                                                    // backgroundColor:
                                                    // Colors.red.shade400,
                                                    label: const Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  ActionChip(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    // backgroundColor:
                                                    // Colors.blue.shade400,
                                                    label: const Text(
                                                      'No',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                'No Device Added',
                                style:
                                    TextStyle(fontSize: 17),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget crewMembersDetails(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          collapsedBackgroundColor: const Color(0xff5AC8FA).withAlpha(100),
          title: const Text(
            "Team Members Name",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: const Icon(
            Icons.group_add,
            color: Colors.black,
          ),
          //add icon
          children: [
            ///Team MembersList
            Container(
              height: size.height * 0.35,
              decoration: BoxDecoration(
                // color: Colors.blueGrey.withAlpha(50),
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(color: Colors.black12, width: .5),
              ),
              child: SingleChildScrollView( 
                child: Column(
                  children: [
                    ///Add Team Members
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Add Team Members Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: const Color(0xff5AC8FA),
                          radius: 20,
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                addDataToList(
                                  context,
                                  'Add Crew members',
                                  CustomTextField(
                                    controller: addDataToListController,
                                    textInputType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    hintName: 'Person Name',
                                    icon: const Icon(Icons.person_2),
                                    maxLength: 50,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                  ).textInputField(context),
                                  addDataToListController,
                                  teamMembersName,
                                );
                              },
                              icon: const Icon(
                                Icons.add,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                
                    const Divider(
                      endIndent: 1,
                      indent: 1,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: size.height * 0.2,
                      child: teamMembersName.isNotEmpty
                          ? ListView.builder(
                              itemCount: teamMembersName.length,
                              itemBuilder: (context, int index) {
                                return Center(
                                  child: ListTile(
                                    leading: Text(
                                      "${index + 1} : ",
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    title: Text(
                                      teamMembersName[index].toString(),
                                      style: const TextStyle(),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text(
                                              'Delete this name?\n${teamMembersName[index]}',
                                              style: const TextStyle(),
                                              textAlign: TextAlign.center,
                                            ),
                                            content: SizedBox(
                                              height: size.height * 0.1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                children: [
                                                  ActionChip(
                                                    onPressed: () {
                                                      teamMembersName
                                                          .removeAt(index);
                                                      Navigator.pop(context);
                                                      setState(() {});
                                                    },
                                                    // backgroundColor:
                                                    // Colors.red.shade400,
                                                    label: const Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  ActionChip(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    // backgroundColor:
                                                    // Colors.blue.shade400,
                                                    label: const Text(
                                                      'No',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                'No Members Added',
                                style:
                                    TextStyle( fontSize: 17),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ajaxItemDetails(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          collapsedBackgroundColor: const Color(0xff5AC8FA).withAlpha(100),
          title: const Text(
            "Ajax Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: const Icon(
            Icons.security,
            color: Colors.black,
          ),
          //add icon
          children: [
            ///Team MembersList
            Container(
              height: size.height * 0.4,
              decoration: BoxDecoration(
                // color: Colors.blueGrey.withAlpha(50),
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(color: Colors.black12, width: .5),
              ),
              child: Column(
                children: [
                  ///Add Team Members
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Add Ajax Item Details',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: const Color(0xff5AC8FA),
                        radius: 20,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  // title: const Text('Enter Person Name'),
                                  title: const Text(
                                    'Title',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  content: SizedBox(
                                    height: size.height * 0.3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // TextFormField(
                                        //   textCapitalization: TextCapitalization.sentences,
                                        //   controller: ajaxItemController,
                                        //   textInputAction: TextInputAction.next,
                                        //   keyboardType: TextInputType.text,
                                        //   maxLength: 200,
                                        //   // enabled: isEnable,
                                        //   style: TextStyle(
                                        //       color: Colors.black,),
                                        //   decoration: InputDecoration(
                                        //     counterText: '',
                                        //     prefixIcon: Icon(Icons.person),
                                        //     hintText: "User ID",
                                        //     labelText: 'User ID',
                                        //     labelStyle: TextStyle(
                                        //         color: Colors.black, ),
                                        //     hintStyle: TextStyle(
                                        //         color: Colors.black.withOpacity(0.6),
                                        //         ),
                                        //     border: myInputBorder(),
                                        //     enabledBorder: myInputBorder(),
                                        //     focusedBorder: myFocusBorder(),
                                        //     // disabledBorder: myDisabledBorder(),
                                        //   ),
                                        //   // validator: validator,
                                        //   // onTap: onTap,
                                        // ),
                                        CustomTextField(
                                          controller: ajaxItemController,
                                          textInputType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          hintName: 'Product Name',
                                          icon: const Icon(Icons.person_2),
                                          maxLength: 100,
                                        ).textInputField(context),
                                        SizedBox(height: size.height * 0.01),

                                        CustomTextField(
                                          controller: ajaxItemCountController,
                                          textInputType: TextInputType.number,
                                          textInputAction: TextInputAction.done,
                                          hintName: 'Quantity',
                                          icon: const Icon(Icons.person_2),
                                          maxLength: 3,
                                        ).textInputField(context),
                                        SizedBox(height: size.height * 0.01),

                                        ActionChip(
                                          // backgroundColor:
                                          // Colors.blue.withOpacity(.95),
                                          onPressed: () {
                                            if (ajaxItemController
                                                    .text.isNotEmpty &&
                                                ajaxItemCountController
                                                    .text.isNotEmpty) {
                                              ajaxDeviceDetails.addAll({
                                                AjaxListModel(
                                                  productName:
                                                      ajaxItemController.text,
                                                  qty: int.parse(
                                                    ajaxItemCountController
                                                        .text,
                                                  ),
                                                ),
                                              });
                                              Navigator.pop(context);

                                              ajaxItemCountController.clear();
                                              ajaxItemController.clear();

                                              log(ajaxDeviceDetails.toString());
                                            } else {
                                              const snackBar = SnackBar(
                                                content: Center(
                                                  child: Text(
                                                    'This field is empty',
                                                  ),
                                                ),
                                                backgroundColor:
                                                    (Colors.redAccent),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                            setState(() {});
                                          },
                                          label: const Text(
                                            'Add',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(
                    endIndent: 1,
                    indent: 1,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: size.height * 0.3,
                    child: Container(
                      // padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                tableHeading(150, 'Items', true),
                                tableHeading(130, 'Qty', true),
                              ],
                            ),

                            /// TABLE CONTENT
                            SizedBox(
                              // margin: const EdgeInsets.only(top: 3),
                              height: 160,
                              width: double.infinity,
                              // decoration: BoxDecoration(
                              //   // borderRadius: BorderRadius.circular(20),
                              //   color: CupertinoColors.systemGrey
                              //       .withOpacity(0.4),
                              // ),
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                itemCount: ajaxDeviceDetails.length,
                                itemBuilder: (BuildContext context, index) {
                                  final data = [
                                    ajaxDeviceDetails[index].productName,
                                    ajaxDeviceDetails[index].qty.toString(),
                                  ];
                                  return Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Table(
                                      border: TableBorder.all(
                                        color: Colors.black,
                                        width: .1,
                                      ),
                                      children: [
                                        createTableRow(data),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tableHeading(double width, String title, bool isTrue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          color: Colors.transparent,
          width: width,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(),
            ),
          ),
        ),
        isTrue
            ? const VerticalDivider(
                color: Colors.black,
                endIndent: 23,
                indent: 23,
                thickness: 2,
              )
            : const SizedBox(),
      ],
    );
  }

  TableRow createTableRow(List<String> cells, {bool isHeader = false}) =>
      TableRow(
        children: cells.map(
          (cell) {
            final style = TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
            );
            return Padding(
              padding: const EdgeInsets.all(5),
              child: Center(
                child: Text(
                  cell,
                  style: style,
                ),
              ),
            );
          },
        ).toList(),
      );

  Widget light8ChannelDetails(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          collapsedBackgroundColor: const Color(0xff5AC8FA).withAlpha(100),
          title: const Text(
            "Light Board 8 Channel",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: const Icon(
            Icons.lightbulb_outline_rounded,
            color: Colors.black,
          ),
          //add icon
          children: [
            ///lightList
            Container(
              height: size.height * 0.4,
              decoration: BoxDecoration(
                // color: Colors.blueGrey.withAlpha(50),
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(color: Colors.black12, width: .5),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Add Light Board 8 Channel Details',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: const Color(0xff5AC8FA),
                        radius: 20,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              addDataToList(
                                context,
                                'Light 8 Channel',
                                CustomTextField(
                                  controller: addDataToListController,
                                  textInputType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  hintName: 'Type here',
                                  icon: const Icon(Icons.person_2),
                                  maxLength: 50,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty &&
                                            needSmartHome == 'Yes') {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ).textInputField(context),
                                addDataToListController,
                                lightBoard8ChannelDetails,
                              );
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    endIndent: 1,
                    indent: 1,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: size.height * 0.2,
                    child: lightBoard8ChannelDetails.isNotEmpty
                        ? ListView.builder(
                            itemCount: lightBoard8ChannelDetails.length,
                            itemBuilder: (context, int index) {
                              return Center(
                                child: ListTile(
                                  leading: Text(
                                    "R${index + 1} : ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  title: Text(
                                    lightBoard8ChannelDetails[index].toString(),
                                    style: const TextStyle(),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text(
                                            'Delete this name?\n${lightBoard8ChannelDetails[index]}',
                                            style: const TextStyle(),
                                            textAlign: TextAlign.center,
                                          ),
                                          content: SizedBox(
                                            height: size.height * 0.07,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ActionChip(
                                                  onPressed: () {
                                                    lightBoard8ChannelDetails
                                                        .removeAt(index);
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  // backgroundColor:
                                                  // Colors.red.shade400,
                                                  label: const Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                ActionChip(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  // backgroundColor:
                                                  // Colors.blue.shade400,
                                                  label: const Text(
                                                    'No',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              'List is Empty',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget light4ChannelDetails(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          collapsedBackgroundColor: const Color(0xff5AC8FA).withAlpha(100),
          title: const Text(
            "Light Board 4 Channel",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: const Icon(
            Icons.light,
            color: Colors.black,
          ),
          //add icon
          children: [
            ///lightList
            Container(
              height: size.height * 0.4,
              decoration: BoxDecoration(
                // color: Colors.blueGrey.withAlpha(50),
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(color: Colors.black12, width: .5),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Add Light Board 4 Channel Details',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: const Color(0xff5AC8FA),
                        radius: 20,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              addDataToList(
                                context,
                                'Light 4 Channel',
                                CustomTextField(
                                  controller: addDataToListController,
                                  textInputType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  hintName: 'Type here',
                                  icon: const Icon(Icons.person_2),
                                  maxLength: 50,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty &&
                                            needSmartHome == 'Yes') {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ).textInputField(context),
                                addDataToListController,
                                lightBoard4ChannelDetails,
                              );
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    endIndent: 1,
                    indent: 1,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: size.height * 0.2,
                    child: lightBoard4ChannelDetails.isNotEmpty
                        ? ListView.builder(
                            itemCount: lightBoard4ChannelDetails.length,
                            itemBuilder: (context, int index) {
                              return Center(
                                child: ListTile(
                                  leading: Text(
                                    "R${index + 1} : ",
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  title: Text(
                                    lightBoard4ChannelDetails[index].toString(),
                                    style: const TextStyle(),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text(
                                            'Delete this name?\n${lightBoard4ChannelDetails[index]}',
                                            textAlign: TextAlign.center,
                                          ),
                                          content: SizedBox(
                                            height: size.height * 0.07,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ActionChip(
                                                  onPressed: () {
                                                    lightBoard4ChannelDetails
                                                        .removeAt(index);
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  label: const Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                ActionChip(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  // backgroundColor:
                                                  // Colors.blue.shade400,
                                                  label: const Text(
                                                    'No',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              'List is Empty',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gateDetails(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          collapsedBackgroundColor: const Color(0xff5AC8FA).withAlpha(100),
          title: const Text(
            "Gate Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: const Icon(
            Icons.door_sliding_outlined,
            color: Colors.black,
          ),
          //add icon
          // childrenPadding: EdgeInsets.only(left:60), //children padding
          children: [
            ///Motor Model And Extra Remote
            Row(
              children: [
                /// Motor Model
                Expanded(
                  child: CustomTextField(
                    controller: motorModelNumController,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintName: 'Motor Model Id',
                    icon: const Icon(Icons.numbers),
                    maxLength: 100,
                    validator: (value) {
                      if (value == null || value.isEmpty && needGate == 'Yes') {
                        return 'Required Motor Model No';
                      }
                      return null;
                    },
                  ).textInputField(context),
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),

                /// Extra Remote
                Expanded(
                  child: CustomTextField(
                    controller: extraRemoteController,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    hintName: 'Extra remote',
                    icon: const Icon(Icons.settings_remote),
                    maxLength: 100,
                    validator: (value) {
                      if (value == null || value.isEmpty && needGate == 'Yes') {
                        return 'Required Extra Remote';
                      }
                      return null;
                    },
                  ).textInputField(context),
                ),
              ],
            ),

            SizedBox(
              height: size.height * 0.01,
            ),

            ///Motor brand name
            CustomTextField(
              controller: motorBrandNameController,
              textInputType: TextInputType.name,
              textInputAction: TextInputAction.next,
              hintName: 'Motor brand name',
              icon: const Icon(Icons.brightness_auto),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.isEmpty && needGate == 'Yes') {
                  return 'Required Motor brand name';
                }
                return null;
              },
            ).textInputField(context),

            ////Gate and App
            textWithDropDown(
              'Gate Type',
              DropdownButtonFormField<String>(
                value: selectedGAType.isNotEmpty ? selectedGAType : null,
                style: const TextStyle(
                  color: CupertinoColors.label,
                  fontSize: 16,
                ),
                hint: const Text(
                  "Gate Type",
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: myInputBorder(),
                  enabledBorder: myInputBorder(),
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(.2),
                    fontWeight: FontWeight.w600,
                  ),
                  fillColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  // hoverColor: Colors.black,
                  focusedBorder: myFocusBorder(),
                  // isDense: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty && needGate == 'Yes') {
                    return 'Select Gate Type';
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGAType = newValue!;
                  });
                },
                items: gateType.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            if (needApp == 'Yes' && needGate == 'Yes')
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: textWithDropDown(
                          'R1',
                          DropdownButtonFormField<String>(
                            value: r1.isNotEmpty ? r1 : null,
                            style: const TextStyle(
                              color: CupertinoColors.label,
                              fontSize: 16,
                            ),
                            hint: const Text(
                              "R1",
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10.0),
                              border: myInputBorder(),
                              enabledBorder: myInputBorder(),
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(.2),
                                fontWeight: FontWeight.w600,
                              ),
                              fillColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              // hoverColor: Colors.black,
                              focusedBorder: myFocusBorder(),
                              // isDense: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '$value Already selected choose another one';
                              }
                              return null;
                            },
                            onChanged: (String? newValue) {
                              setState(() {
                                r1 = newValue!;
                              });
                            },
                            items: channelPointOut
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: textWithDropDown(
                          'R2',
                          DropdownButtonFormField<String>(
                            value: r2.isNotEmpty ? r2 : null,
                            style: const TextStyle(
                              color: CupertinoColors.label,
                              fontSize: 16,
                            ),
                            hint: const Text(
                              "R2",
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10.0),
                              border: myInputBorder(),
                              enabledBorder: myInputBorder(),
                              fillColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              // hoverColor: Colors.black,
                              focusedBorder: myFocusBorder(),
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(.2),
                                fontWeight: FontWeight.w600,
                              ),
                              // isDense: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '$value Already selected choose another one';
                              }
                              return null;
                            },
                            onChanged: (String? newValue) {
                              setState(() {
                                r2 = newValue!;
                              });
                            },
                            items: channelPointOut
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    children: [
                      ///R3
                      Expanded(
                        child: textWithDropDown(
                          'R3',
                          DropdownButtonFormField<String>(
                            value: r3.isNotEmpty ? r3 : null,
                            style: const TextStyle(
                              color: CupertinoColors.label,
                              fontSize: 16,
                            ),
                            hint: const Text(
                              "R3",
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10.0),
                              border: myInputBorder(),
                              enabledBorder: myInputBorder(),
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(.2),
                                fontWeight: FontWeight.w600,
                              ),
                              fillColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              // hoverColor: Colors.black,
                              focusedBorder: myFocusBorder(),
                              // isDense: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Already selected this $value choose another one';
                              }
                              return null;
                            },
                            onChanged: (String? newValue) {
                              setState(() {
                                r3 = newValue!;
                              });
                            },
                            items: channelPointOut
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.height * 0.01,
                      ),

                      ///R4
                      Expanded(
                        child: textWithDropDown(
                          'R4',
                          DropdownButtonFormField<String>(
                            value: r4.isNotEmpty ? r4 : null,
                            style: const TextStyle(
                              color: CupertinoColors.label,
                              fontSize: 16,
                            ),
                            hint: const Text(
                              "R4",
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10.0),
                              border: myInputBorder(),
                              enabledBorder: myInputBorder(),
                              fillColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              // hoverColor: Colors.black,
                              focusedBorder: myFocusBorder(),
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(.2),
                                fontWeight: FontWeight.w600,
                              ),
                              // isDense: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '$value Already selected choose another one';
                              }
                              return null;
                            },
                            onChanged: (String? newValue) {
                              setState(() {
                                r4 = newValue!;
                              });
                            },
                            items: channelPointOut
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                ],
              )
            else
              SizedBox(
                height: size.height * 0.01,
              ),
          ],
        ),
      ),
    );
  }

  Widget wifiAndRouterDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          collapsedBackgroundColor: const Color(0xff5AC8FA).withAlpha(100),
          title: const Text(
            "Router and Wifi Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: const Icon(
            Icons.router,
            color: Colors.black,
          ),
          children: [
            /// Router id
            CustomTextField(
              controller: routerUidController,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              hintName: 'Router ID',
              icon: const Icon(Icons.router),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.isEmpty && needSmartHome == 'Yes') {
                  return 'This field is required';
                }
                return null;
              },
            ).textInputField(context),

            ///Router Password
            CustomTextField(
              controller: routerPasswordController,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              hintName: 'Router Password',
              icon: const Icon(Icons.password),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.isEmpty && needSmartHome == 'Yes') {
                  return 'This field is required';
                }
                return null;
              },
            ).textInputField(context),

            /// Wifi Name
            CustomTextField(
              controller: wifiNameController,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              hintName: 'Wifi Name',
              icon: const Icon(Icons.wifi),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.isEmpty && needSmartHome == 'Yes') {
                  return 'This field is required';
                }
                return null;
              },
            ).textInputField(context),

            ///Wif Password
            CustomTextField(
              controller: wifiPasswordNameController,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              hintName: 'Wifi Password',
              icon: const Icon(Icons.password),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.isEmpty && needSmartHome == 'Yes') {
                  return 'This field is required';
                }
                return null;
              },
            ).textInputField(context),
          ],
        ),
      ),
    );
  }

  Widget serverDetails(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          collapsedBackgroundColor: const Color(0xff5AC8FA).withAlpha(100),
          title: const Text(
            "Server Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: const Icon(
            Icons.dataset_linked_outlined,
            color: Colors.black,
          ),
          children: [
            /// Server
            CustomTextField(
              controller: serverController,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              hintName: 'Server',
              icon: const Icon(Icons.router),
              maxLength: 30,
              validator: (value) {
                if (value == null || value.isEmpty && needSmartHome == 'Yes') {
                  return 'This field is required';
                }
                return null;
              },
            ).textInputField(context),

            ///Local IP
            CustomTextField(
              controller: localIpController,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
              hintName: 'Local IP',
              icon: const Icon(Icons.dataset_outlined),
              maxLength: 30,
              validator: (value) {
                if (value == null || value.isEmpty && needSmartHome == 'Yes') {
                  return 'This field is required';
                }
                return null;
              },
            ).textInputField(context),

            /// Static IP
            CustomTextField(
              controller: staticIpController,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
              hintName: 'Static IP',
              icon: const Icon(Icons.dataset_outlined),
              maxLength: 30,
              validator: (value) {
                if (value == null || value.isEmpty && needSmartHome == 'Yes') {
                  return 'This field is required';
                }
                return null;
              },
            ).textInputField(context),

            /// Server port
            CustomTextField(
              controller: serverPortController,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
              hintName: 'Server Port',
              icon: const Icon(Icons.portable_wifi_off),
              maxLength: 30,
              validator: (value) {
                if (value == null || value.isEmpty && needSmartHome == 'Yes') {
                  return 'This field is required';
                }
                return null;
              },
            ).textInputField(context),

            textWithDropDown(
              'Port Forwarding',
              DropdownButtonFormField<String>(
                value: portForwarding.isNotEmpty ? portForwarding : null,
                style: const TextStyle(
                  color: CupertinoColors.label,
                  fontSize: 16,
                ),
                hint: const Text(
                  'Port Forwarding',
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: myInputBorder(),
                  enabledBorder: myInputBorder(),
                  fillColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  // hoverColor: Colors.black,
                  focusedBorder: myFocusBorder(),
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(.2),
                    fontWeight: FontWeight.w600,
                  ),
                  // isDense: true,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty && needSmartHome == 'Yes') {
                    return 'This field is required';
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  setState(() {
                    portForwarding = newValue!;
                  });
                },
                items:
                    optionValue.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            textWithDropDown(
              'Voice Config',
              DropdownButtonFormField<String>(
                value: voiceConfig.isNotEmpty ? voiceConfig : null,
                style: const TextStyle(
                  color: CupertinoColors.label,
                  fontSize: 16,
                ),
                hint: const Text(
                  'Voice Config',
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: myInputBorder(),
                  enabledBorder: myInputBorder(),
                  fillColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  // hoverColor: Colors.black,
                  focusedBorder: myFocusBorder(),
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(.2),
                    fontWeight: FontWeight.w600,
                  ),
                  // isDense: true,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty && needSmartHome == 'Yes') {
                    return 'This field is required';
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  setState(() {
                    voiceConfig = newValue!;
                  });
                },
                items:
                    optionValue.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              width: size.width * 0.02,
            ),

            /// Voice Config UID
            if (voiceConfig == 'Yes')
              CustomTextField(
                controller: voiceConfigUIDController,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                hintName: 'Voice Config UID',
                icon: const Icon(Icons.wifi),
                maxLength: 100,
                validator: (value) {
                  if (value == null || value.isEmpty && voiceConfig == 'Yes') {
                    return 'This field is required';
                  }
                  return null;
                },
              ).textInputField(context),

            ///Voice Config Password
            if (voiceConfig == 'Yes')
              CustomTextField(
                controller: voiceConfigPassController,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
                hintName: 'Voice Config Password',
                icon: const Icon(Icons.password),
                maxLength: 100,
                validator: (value) {
                  if (value == null || value.isEmpty && voiceConfig == 'Yes') {
                    return 'This field is required';
                  }
                  return null;
                },
              ).textInputField(context),

            textWithDropDown(
              'B_S_N_L',
              DropdownButtonFormField<String>(
                value: bSNL.isNotEmpty ? bSNL : null,
                style: const TextStyle(
                  color: CupertinoColors.label,
                  fontSize: 16,
                ),
                hint: const Text(
                  'B_S_N_L',
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: myInputBorder(),
                  enabledBorder: myInputBorder(),
                  fillColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  // hoverColor: Colors.black,
                  focusedBorder: myFocusBorder(),
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(.2),
                    fontWeight: FontWeight.w600,
                  ),
                  // isDense: true,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty && needSmartHome == 'Yes') {
                    return 'This field is required';
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  setState(() {
                    bSNL = newValue!;
                  });
                },
                items:
                    optionValue.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),

            if (bSNL == 'Yes')

              /// bSNL UID
              CustomTextField(
                controller: bSNLUIDController,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                hintName: 'B_S_N_L UID',
                icon: const Icon(Icons.wifi),
                maxLength: 100,
                validator: (value) {
                  if (value == null || value.isEmpty && bSNL == 'Yes') {
                    return 'This field is required';
                  }
                  return null;
                },
              ).textInputField(context),

            ///bSNL Password
            if (bSNL == 'Yes')
              CustomTextField(
                controller: bSNLPassController,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
                hintName: 'B_S_N_L Password',
                icon: const Icon(Icons.password),
                maxLength: 100,
                validator: (value) {
                  if (value == null || value.isEmpty && bSNL == 'Yes') {
                    return 'This field is required';
                  }
                  return null;
                },
              ).textInputField(context),
          ],
        ),
      ),
    );
  }

  Widget heavyAndFanDetails(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          collapsedBackgroundColor: const Color(0xff5AC8FA).withAlpha(100),
          title: const Text(
            "Heavy and Fan Board Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: const Icon(
            Icons.mode_fan_off_outlined,
            color: Colors.black,
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Heavy R1
                Expanded(
                  child: textWithDropDown(
                    'Heavy R1 Board',
                    CustomTextField(
                      controller: heavyLoadR1Controller,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      hintName: 'Heavy Board R1',
                      icon: const Icon(Icons.router),
                      maxLength: 30,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty && needSmartHome == 'Yes') {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ).textInputField(context),
                  ),
                ),
                SizedBox(
                  width: size.height * 0.01,
                ),

                /// Heavy R2
                Expanded(
                  child: textWithDropDown(
                    'Heavy Board R2',
                    CustomTextField(
                      controller: heavyLoadR2Controller,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      hintName: 'Heavy Board R2',
                      icon: const Icon(Icons.router),
                      maxLength: 30,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty && needSmartHome == 'Yes') {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ).textInputField(context),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Fan R1
                Expanded(
                  child: textWithDropDown(
                    'Fan S1',
                    CustomTextField(
                      controller: fanR1Controller,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      hintName: 'Fan S1',
                      icon: const Icon(Icons.router),
                      maxLength: 30,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty && needSmartHome == 'Yes') {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ).textInputField(context),
                  ),
                ),
                SizedBox(
                  width: size.height * 0.01,
                ),

                /// Fan R2
                Expanded(
                  child: textWithDropDown(
                    'Fan S2',
                    CustomTextField(
                      controller: fanR2Controller,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      hintName: 'Fan S2',
                      icon: const Icon(Icons.router),
                      maxLength: 30,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty && needSmartHome == 'Yes') {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ).textInputField(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget customerDetails() {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          collapsedBackgroundColor: const Color(0xff5AC8FA).withAlpha(100),
          title: const Text(
            "Customer Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: const Icon(
            Icons.contact_page_outlined,
            color: Colors.black,
          ),
          children: [
            /// Customer Name.....................
            CustomTextField(
              controller: customerNameController,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              hintName: 'Customer Name',
              icon: const Icon(Icons.person),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required Customer Name';
                }
                return null;
              },
            ).textInputField(context),

            ///Client Id
            CustomTextField(
              controller: customerIdController,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              hintName: 'Customer ID',
              icon: const Icon(Icons.numbers),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required Customer ID';
                }
                return null;
              },
            ).textInputField(context),

            ///Phone Number
            CustomTextField(
              controller: phoneNumController,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
              hintName: 'Phone number',
              icon: const Icon(Icons.phone),
              maxLength: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required Customer Number';
                } else if (value.toString().length < 10) {
                  return "Invalid Number";
                }
                return null;
              },
            ).textInputField(context),

            /// Email
            CustomTextField(
              controller: emailController,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              hintName: 'Email',
              icon: const Icon(Icons.mail_outline_rounded),
              maxLength: 150,
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Required Customer Email';
              //   }
              //   return null;
              // },
            ).textInputField(context),

            ///Address
            CustomTextField(
              controller: addressController,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.done,
              hintName: 'Address',
              icon: const Icon(Icons.location_city),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required Customer Address';
                }
                return null;
              },
            ).textInputField(context),
            SizedBox(height: size.height * 0.01),

            Container(
              height: size.height * 0.07,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                controller: dateOfInstallationController,
                textInputAction: TextInputAction.done,
                maxLength: 15,
                readOnly: true,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Installation Date',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  border: myInputBorder(),
                  enabledBorder: myInputBorder(),
                  focusedBorder: myFocusBorder(),
                  // disabledBorder: myDisabledBorder(),
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty && needGate == 'Yes') {
                    return 'Required Installation Date';
                  }
                  return null;
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      dateOfInstallationController.text =
                          formattedDate; //set output date to TextField value.
                    });
                  }
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),

            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Need Smart Home
                Expanded(
                  child: textWithDropDown(
                    'Smart Home',
                    DropdownButtonFormField<String>(
                      value: needSmartHome.isNotEmpty ? needSmartHome : null,
                      style: const TextStyle(
                        color: CupertinoColors.label,
                        fontSize: 8,
                      ),
                      hint: const Text(
                        "Need Smart Home",
                        style: TextStyle(),
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        border: myInputBorder(),
                        enabledBorder: myInputBorder(),
                        hintStyle: TextStyle(
                          fontSize: 8,
                          color: Colors.black.withOpacity(.2),
                        ),
                        fillColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        // hoverColor: Colors.black,
                        focusedBorder: myFocusBorder(),
                        // isDense: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required Smart home Value';
                        }
                        return null;
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          needSmartHome = newValue!;
                        });
                      },
                      items: optionValue
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),

                /// Need Gate
                Expanded(
                  child: textWithDropDown(
                    'Gate',
                    DropdownButtonFormField<String>(
                      value: needGate.isNotEmpty ? needGate : null,
                      style: const TextStyle(
                        color: CupertinoColors.label,
                        fontSize: 10,
                      ),
                      hint: const Text(
                        "Need Gate",
                        style: TextStyle(),
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        border: myInputBorder(),
                        enabledBorder: myInputBorder(),
                        fillColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        // hoverColor: Colors.black,
                        focusedBorder: myFocusBorder(),
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(.2),
                          fontWeight: FontWeight.w600,
                        ),
                        // isDense: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select Gate Need or Not';
                        }
                        return null;
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          needGate = newValue!;
                        });
                      },
                      items: optionValue
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                SizedBox(
                  width: size.width * 0.02,
                ),

                /// Need Ajax
                Expanded(
                  child: textWithDropDown(
                    'Ajax',
                    DropdownButtonFormField<String>(
                      value: needAjax.isNotEmpty ? needAjax : null,
                      style: const TextStyle(
                        color: CupertinoColors.label,
                        fontSize: 10,
                      ),
                      hint: const Text(
                        "Need Ajax",
                        style: TextStyle(),
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        border: myInputBorder(),
                        enabledBorder: myInputBorder(),
                        fillColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        // hoverColor: Colors.black,
                        focusedBorder: myFocusBorder(),
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(.2),
                          fontWeight: FontWeight.w600,
                        ),
                        // isDense: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select Ajax Need or Not';
                        }
                        return null;
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          needAjax = newValue!;
                        });
                      },
                      items: optionValue
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            needGate == 'Yes'
                ? textWithDropDown(
                    'Need App',
                    DropdownButtonFormField<String>(
                      value: needApp.isNotEmpty ? needApp : null,
                      style: const TextStyle(
                        color: CupertinoColors.label,
                        fontSize: 16,
                      ),
                      hint: const Text(
                        "Need App",
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        border: myInputBorder(),
                        enabledBorder: myInputBorder(),
                        fillColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        // hoverColor: Colors.black,
                        focusedBorder: myFocusBorder(),
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(.2),
                          fontWeight: FontWeight.w600,
                        ),
                        // isDense: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select an option Yes or No';
                        }
                        return null;
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          needApp = newValue!;
                        });
                      },
                      items: optionValue
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : const SizedBox(),
            SizedBox(
              height: size.height * 0.02,
            ),
            if (needSmartHome == 'Yes' || needApp == 'Yes')
              Column(
                children: [
                  const Text(
                    'App Details',
                    style: TextStyle(),
                  ),

                  /// Email id
                  CustomTextField(
                    controller: userIdController,
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    hintName: 'App User ID',
                    icon: const Icon(Icons.email),
                    maxLength: 100,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'fill required filed';
                      }
                      return null;
                    },
                  ).textInputField(context),

                  ///Password
                  CustomTextField(
                    controller: passwordsController,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    hintName: 'Password',
                    icon: const Icon(Icons.password),
                    maxLength: 100,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fill required filed';
                      }
                      return null;
                    },
                  ).textInputField(context),
                ],
              )
            else
              const SizedBox(),
            if (needAjax == 'Yes')

              /// Email
              CustomTextField(
                controller: ajaxAccountUidController,
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                hintName: 'Ajax Account Uid',
                icon: const Icon(Icons.numbers),
                maxLength: 100,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required this filed';
                  }
                  return null;
                },
              ).textInputField(context),
          ],
        ),
      ),
    );
  }

  Widget textWithDropDown(String title, Widget widget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "  $title",
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        ClipRRect(borderRadius: BorderRadius.circular(15), child: widget),
      ],
    );
  }

  Future<dynamic> addDataToList(
    BuildContext context,
    String title,
    Widget widget,
    TextEditingController textEditingController,
    List list,
  ) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(),
        ),
        content: SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget,
              ActionChip(
                onPressed: () {
                  if (textEditingController.text.isNotEmpty) {
                    list.add(textEditingController.text);
                    textEditingController.clear();
                    Navigator.pop(context);
                  } else {
                    CustomSnackBar.showErrorSnackbar(
                      message: 'This field is empty',
                      context: context,
                    );
                  }
                  setState(() {});
                },
                label: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder myInputBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.5),
        width: 1.5,
      ),
    );
  }

  OutlineInputBorder myFocusBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.5),
        width: 1.5,
      ),
    );
  }
}

class AjaxListModel {
  String productName;
  int qty;

  AjaxListModel({
    required this.productName,
    required this.qty,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'product : $productName, qty : $qty';
  }

  factory AjaxListModel.fromJson(Map<String, dynamic> json) => AjaxListModel(
        productName: json["product Name"],
        qty: json["Qty"],
      );

  Map<String, dynamic> toJson() => {
        "product Name": productName,
        "Qty": qty,
      };
}

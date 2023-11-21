import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_app_button.dart';
import 'package:my_office/core/utilities/custom_widgets/custom_snack_bar.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/data_source/search_leads_fb_data_source.dart';
import '../../data/data_source/search_leads_fb_data_source_impl.dart';
import '../../data/repository/search_leads_repo_impl.dart';
import '../../domain/repository/search_leads_repository.dart';
import '../view_model/customer_note_item_details.dart';
import 'add_customer_notes.dart';
import 'package:http/http.dart' as http;

const List<String> list = [
  'New leads',
  'Following Up',
  'Delayed',
  'Rejected from MGMT',
  'Rejected from Customer',
  'Advanced',
  'Product',
  'B2B',
  'Under Construction',
  'Installation Completed',
  'Others',
  'Interested',
  'Visited',
  'Need to visit',
  'Quotation',
];

class CustomerDetailScreen extends StatefulWidget {
  final Map<Object?, Object?> customerInfo;
  final String currentStaffName;
  final String customerStatus;
  final Color containerColor;
  final Color nobColor;
  final List<String> prStaffNames;
  final String leadName;
  final String reminder;

  const CustomerDetailScreen({
    Key? key,
    required this.customerInfo,
    required this.containerColor,
    required this.currentStaffName,
    required this.nobColor,
    required this.customerStatus,
    required this.leadName,
    required this.prStaffNames,
    required this.reminder,
  }) : super(key: key);

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  TextEditingController notesController = TextEditingController();
  late String dropDownValue;
  late String leadName;

  late SearchLeadsFbDataSource searchLeadsFbDataSource =
      SearchLeadsFbDataSourceImpl();
  late SearchLeadsRepository searchLeadsRepository =
      SearchLeadsRepoImpl(searchLeadsFbDataSource);

  void openWhatsapp({
    required BuildContext context,
    required String number,
  }) async {
    var whatsapp = number; //+92xx enter like this
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp";
    var whatsappURLIos = "https://wa.me/$whatsapp";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(
          Uri.parse(
            whatsappURLIos,
          ),
        );
      } else {
        if (!mounted) return;
        CustomSnackBar.showErrorSnackbar(
          message: 'Whatsapp is not installed on your device!',
          context: context,
        );
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        if (!mounted) return;
        CustomSnackBar.showErrorSnackbar(
          message: 'Whatsapp is not installed on your device!',
          context: context,
        );
      }
    }
  }

  @override
  void initState() {
    if (widget.customerStatus.toLowerCase().contains('onwords') ||
        widget.customerStatus
            .toLowerCase()
            .contains('rejected from management side')) {
      dropDownValue = 'Rejected from MGMT';
    } else if (widget.customerStatus.toLowerCase().contains('onwords') ||
        widget.customerStatus
            .toLowerCase()
            .contains('rejected from customer end')) {
      dropDownValue = 'Rejected from Customer';
    } else if (widget.customerStatus.toLowerCase().contains('interested') ||
        widget.customerStatus.toLowerCase().contains('hot lead')) {
      dropDownValue = 'Interested';
    } else {
      dropDownValue = widget.customerStatus;
      super.initState();
    }
    leadName = widget.leadName;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF1F2F8),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xffD136D4),
                Color(0xff7652B2),
              ],
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        elevation: 0.0,
        // foregroundColor: const Color(0xff8355B7),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          splashRadius: 20.0,
        ),
        title: Text(
          widget.customerInfo['name'].toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        titleSpacing: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                addNotes();
              });
            },
            icon: const Icon(
              CupertinoIcons.bag_fill_badge_plus,
              color: Colors.white,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              launchUrl(
                Uri.parse(
                  "tel://${widget.customerInfo['phone_number'].toString()}",
                ),
              );
              // print(widget.customerInfo['phone_number'].toString());
            },
            icon: const Icon(
              CupertinoIcons.phone_solid,
              color: Colors.lightBlueAccent,
              size: 30,
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                openWhatsapp(
                  context: context,
                  number: widget.customerInfo['phone_number'].toString(),
                );
              });
              // print(widget.customerInfo['phone_number'].toString());
            },
            child: SizedBox(
              height: size.height * 0.05,
              child: const Image(
                image: AssetImage('assets/whatsapp.png'),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildScreen(size: size),
      ),
    );
  }

  Widget buildScreen({required Size size}) {
    return Column(
      children: [
        //Customer detail section
        Container(
          width: size.width,
          height: size.height * .35,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: widget.containerColor,
          ),
          child: buildCustomerDetail(size: size),
        ),

        //CUSTOMER NOTES SECTION
        Expanded(
          child: SizedBox(
            width: size.width,
            child: buildNotes(),
          ),
        ),
      ],
    );
  }

  Widget buildCustomerDetail({required Size size}) {
    final phoneNumber = widget.customerInfo['phone_number'].toString();
    final changeStateStream =
        searchLeadsRepository.getCustomerDetails(phoneNumber);

    List<String> fieldName = [
      'City',
      'Customer id',
      'Lead in Charge',
      'Created By',
      'Created Date',
      'Created Time',
      'State',
      'Data fetched By',
      'Email Id',
      'Enquired For',
      'Phone number',
      'Rating',
      'Reminder date',
    ];

    return StreamBuilder(
      stream: changeStateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data as Map<Object?, Object?>;
          List<String> customerValue = [
            data['city'].toString(),
            data['customer_id'].toString(),
            data['LeadIncharge'].toString(),
            data['created_by'].toString(),
            data['created_date'].toString(),
            data['created_time'].toString(),
            data['customer_state'].toString(),
            data['data_fetched_by'].toString(),
            data['email_id'].toString(),
            data['inquired_for'].toString(),
            data['phone_number'].toString(),
            data['rating'].toString(),
            widget.reminder,
          ];

          return ListView.builder(
            itemCount: fieldName.length,
            itemBuilder: (ctx, i) {
              return buildField(
                field: fieldName[i],
                value: customerValue[i],
                size: size,
              );
            },
          );
        } else if (snapshot.hasError) {}
        return const SizedBox();
      },
    );
  }

  Widget buildNotes() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final phoneNumber = widget.customerInfo['phone_number'].toString();
    final stream = searchLeadsRepository.getCustomerNotes(phoneNumber);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0),
        //title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //Dropdown to change "State" of customers
            DropdownButton(
              value: dropDownValue,
              elevation: 12,
              borderRadius: BorderRadius.circular(15),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
              icon: const Icon(
                Icons.arrow_drop_down_circle_outlined,
              ),
              onChanged: (String? value) {
                setState(() {
                  dropDownValue = value!;
                  addStateToFirebase();
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),

        //Feedback button
        Align(
          alignment: AlignmentDirectional.center,
          child: AppButton(
            onPressed: feedbackApiPost,
            child: const Text('Feedback'),
          ),
        ),

        //Dropdown for changing lead in charge
        widget.currentStaffName == 'Anitha' ||
                widget.currentStaffName == 'Devendiran' ||
                widget.currentStaffName == 'Rajkannan B' ||
                widget.currentStaffName == 'Logesh P'
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: PopupMenuButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    position: PopupMenuPosition.under,
                    elevation: 10.0,
                    itemBuilder: (ctx) => List.generate(
                      widget.prStaffNames.length,
                      (index) {
                        return PopupMenuItem(
                          child: Text(
                            widget.prStaffNames[index],
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              leadName = widget.prStaffNames[index];
                              addLeadToFirebase();
                            });
                          },
                        );
                      },
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Lead in charge -',
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.purple,
                          ),
                        ),
                        SizedBox(width: width * 0.03),
                        Container(
                          height: height * 0.05,
                          width: width * 0.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.withOpacity(0.4),
                          ),
                          child: Text(
                            leadName,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        //Notes list
        StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> notes = [];
              for (var i in snapshot.data!.snapshot.children) {
                notes.add(i.value);
              }

              return Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: notes.length,
                  reverse: true,
                  itemBuilder: (ctx, i) {
                    final Map<Object?, Object?> singleNote =
                        notes[i] as Map<Object?, Object?>;

                    final name = singleNote['entered_by'] ?? 'Not mentioned';
                    final date = singleNote['date'] ?? 'Not mentioned';
                    final time = singleNote['time'] ?? 'Not mentioned';
                    final note = singleNote['note'] ?? 'No notes added';
                    final audio = singleNote['audio_file'];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: NoteItem(
                        note: note.toString(),
                        url: audio.toString(),
                        updatedDate: date.toString(),
                        updatedStaff: name.toString(),
                        updatedTime: time.toString(),
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {}
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Future<void> feedbackApiPost() async {
    final customerWhatsAppNumber =
        widget.customerInfo['phone_number'].toString();
    final customerName = widget.customerInfo['name'].toString();
    final teleCallerName = widget.currentStaffName;
    String bearerToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiI4YzE4ZjU4Yy0zNTgwLTQ0MTAtYjU4NS1lNjNhN2YzNzYwYTgiLCJ1bmlxdWVfbmFtZSI6ImNlb0BvbndvcmRzLmluIiwibmFtZWlkIjoiY2VvQG9ud29yZHMuaW4iLCJlbWFpbCI6ImNlb0BvbndvcmRzLmluIiwiYXV0aF90aW1lIjoiMTAvMjAvMjAyMyAxNjo0MzozMyIsImRiX25hbWUiOiIxMTYxOTEiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBRE1JTklTVFJBVE9SIiwiZXhwIjoyNTM0MDIzMDA4MDAsImlzcyI6IkNsYXJlX0FJIiwiYXVkIjoiQ2xhcmVfQUkifQ.pVIcK8y9jgncGeD9VGdP6EW-YIbDazCFI86GMzfndsc';

    Map<String, dynamic> body = {
      "template_name": "telecall_feedback",
      "broadcast_name": "Feedback Request",
      "parameters": [
        {
          "name": "cust_name",
          "value": customerName,
        },
        {
          "name": "telecaller_name",
          "value": teleCallerName,
        }
      ],
    };

    try {
      await searchLeadsRepository.sendFeedback(
        body,
        bearerToken,
        customerWhatsAppNumber,
      );
      if (!mounted) return;
      CustomSnackBar.showSuccessSnackbar(
        message:
            'Feedback request has been sent to ${widget.customerInfo['name']}',
        context: context,
      );
    } catch (e) {
      log('Error occurred: $e');
    }
  }

  //adding notes
  void addNotes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNotes(
          customerInfo: widget.customerInfo,
          currentStaffName: widget.currentStaffName,
        ),
      ),
    );
  }

  Widget buildField({
    required String field,
    required String value,
    required Size size,
  }) {
    return TimelineTile(
      nodePosition: .38,
      oppositeContents: Container(
        padding: const EdgeInsets.only(left: 8.0, top: 5.0),
        height: 30.0,
        width: size.width * .35,
        child: SelectableText(
          field,
          cursorColor: Colors.purple,
          scrollPhysics: const ClampingScrollPhysics(),
          style: const TextStyle(fontSize: 14.0),
        ),
      ),
      contents: Container(
        padding: const EdgeInsets.only(left: 8.0, top: 5.0, right: 5.0),
        width: size.width * .7,
        height: 30.0,
        // height: 20.0,
        child: SelectableText(
          value,
          cursorColor: Colors.purple,
          scrollPhysics: const ClampingScrollPhysics(),
          style: const TextStyle(fontSize: 14.0),
        ),
      ),
      node: TimelineNode(
        indicator: DotIndicator(
          color: widget.nobColor,
          size: 10.0,
        ),
        startConnector: SolidLineConnector(color: widget.nobColor),
        endConnector: SolidLineConnector(color: widget.nobColor),
      ),
    );
  }

  void addStateToFirebase() async {
    if (dropDownValue.isEmpty) {
      CustomSnackBar.showErrorSnackbar(
        message: 'Select one state to change!',
        context: context,
      );
    } else {
      try {
        await searchLeadsRepository.changeCustomerState(
          widget.customerInfo['phone_number'].toString(),
          dropDownValue,
        );
      } catch (e) {
        Exception('Error caught while changing customer lead state!! $e');
      }
    }
  }

  void addLeadToFirebase() async {
    if (leadName.isEmpty) {
      CustomSnackBar.showErrorSnackbar(
        message: 'Select a PR name to change!',
        context: context,
      );
    } else {
      try {
        await searchLeadsRepository.updateLead(
          widget.customerInfo['phone_number'].toString(),
          leadName,
        );
      } catch (e) {
        Exception('Error caught while changing lead names!! $e');
      }
    }
  }
}

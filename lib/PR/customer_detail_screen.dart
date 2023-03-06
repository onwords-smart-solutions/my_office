import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/Constant/fonts/constant_font.dart';
import 'package:timelines/timelines.dart';

import 'note_item.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Map<Object?, Object?> customerInfo;
  final String currentStaffName;
  final Color containerColor;
  final Color nobColor;

  const CustomerDetailScreen(
      {Key? key,
      required this.customerInfo,
      required this.containerColor,
      required this.currentStaffName,
      required this.nobColor})
      : super(key: key);

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  TextEditingController notesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(widget.currentStaffName);
    return Scaffold(
      backgroundColor: const Color(0xffF1F2F8),
      appBar: AppBar(
        backgroundColor: const Color(0xffF1F2F8),
        elevation: 0.0,
        foregroundColor: const Color(0xff8355B7),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_rounded),
          splashRadius: 20.0,
        ),
        title: Text(widget.customerInfo['name'].toString(),
            style: TextStyle(
                fontFamily: ConstantFonts.poppinsBold, fontSize: 18.0)),
        titleSpacing: 0.0,
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
                color: widget.containerColor),
            child: buildCustomerDetail(size: size)),

        //Customer notes section
        Expanded(child: SizedBox(width: size.width, child: buildNotes())),
      ],
    );
  }

  Widget buildCustomerDetail({required Size size}) {
    List<String> fieldName = [
      'City',
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
    ];

    List<String> customerValue = [
      widget.customerInfo['city'].toString(),
      widget.customerInfo['LeadIncharge'].toString(),
      widget.customerInfo['created_by'].toString(),
      widget.customerInfo['created_date'].toString(),
      widget.customerInfo['created_time'].toString(),
      widget.customerInfo['customer_state'].toString(),
      widget.customerInfo['data_fetched_by'].toString(),
      widget.customerInfo['email_id'].toString(),
      widget.customerInfo['inquired_for'].toString(),
      widget.customerInfo['phone_number'].toString(),
      widget.customerInfo['rating'].toString(),
    ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: fieldName.length,
      itemBuilder: (ctx, i) {
        return buildField(
            field: fieldName[i], value: customerValue[i], size: size);
      },
    );
  }

  Widget buildNotes() {
    // List noteKeys = [];
    // Map<Object?, Object?> allNotes = {};
    final stream = FirebaseDatabase.instance
        .ref()
        .child('customer/${widget.customerInfo['phone_number'].toString()}/notes');
    //
    // if (widget.customerInfo['notes'] != null) {
    //   //Getting all notes from customer data
    //   allNotes = widget.customerInfo['notes'] as Map<Object?, Object?>;
    //   noteKeys = allNotes.keys.toList();
    //
    //   //Checking if key is empty or not
    //   if (noteKeys.isNotEmpty) {
    //     noteKeys.sort((a, b) => b.toString().compareTo(a.toString()));
    //   }
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0),
        //title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notes',
              style: TextStyle(
                  fontFamily: ConstantFonts.poppinsMedium, fontSize: 20.0),
            ),

            // note add button
            IconButton(
              onPressed: () {
                addNotes();
              },
              icon: const Icon(Icons.add_circle_rounded),
              color: const Color(0xff8355B7),
              splashRadius: 20.0,
            ),
          ],
        ),
        //Notes list
        StreamBuilder(
            stream: stream.onValue,
            builder: ( context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> _notes=[];
                for(var i in snapshot.data!.snapshot.children){
                  _notes.add(i.value);
                }

             return   Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _notes.length,
                    reverse: true,

                    itemBuilder: (ctx, i) {

                      final Map<Object?, Object?> singleNote =
                      _notes[i] as Map<Object?,Object?>;

                      final name = singleNote['entered_by'] ?? 'Not mentioned';
                      final date = singleNote['date'] ?? 'Not mentioned';
                      final time = singleNote['time'] ?? 'Not mentioned';
                      final note = singleNote['note'] ?? 'No notes added';

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        child: NoteItem(
                          note: note.toString(),
                          updatedDate: date.toString(),
                          updatedStaff: name.toString(),
                          updatedTime: time.toString(),
                        ),
                      );
                    },
                  ),
                );
                print(snapshot.data?.snapshot.children.length);
              } else if (snapshot.hasError) {

              }
              return const SizedBox();
            }),
      ],
    );
  }

  //adding notes
  void addNotes() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Add notes",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: notesController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your notes here',
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        addNoteToDatabase();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff8355B7),
                        // fixedSize: Size(250, 50),
                      ),
                      child: const Text(
                        "Submit",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildField(
      {required String field, required String value, required Size size}) {
    return TimelineTile(
      nodePosition: .38,
      oppositeContents: Container(
        padding: const EdgeInsets.only(left: 8.0, top: 5.0),
        height: 30.0,
        width: size.width * .35,
        child: Text(
          field,
          style:
              TextStyle(fontFamily: ConstantFonts.poppinsBold, fontSize: 13.0),
        ),
      ),
      contents: Container(
        padding: const EdgeInsets.only(left: 8.0, top: 5.0, right: 5.0),
        width: size.width * .7,
        height: 30.0,
        // height: 20.0,
        child: Text(
          value,
          style: TextStyle(
              fontFamily: ConstantFonts.poppinsMedium, fontSize: 14.0),
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

  void addNoteToDatabase() async {
    if (notesController.text.trim().isEmpty) {
      const snackBar = SnackBar(content: Text('Enter some notes',textAlign: TextAlign.center,),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // print('no data');
    } else {
      DateTime now = DateTime.now();
      var timeStamp = DateFormat('yyyy-MM-dd_kk:mm:ss').format(now);
      final ref = FirebaseDatabase.instance.ref();
      ref
          .child(
              'customer/${widget.customerInfo['phone_number'].toString()}/notes/$timeStamp')
          .update(
        {
          'date': DateFormat('yyyy-MM-dd').format(now),
          'entered_by': widget.currentStaffName,
          'note': notesController.text.trim(),
          'time': DateFormat('kk:mm').format(now)
        },
      );
      notesController.clear();
    }
  }
}

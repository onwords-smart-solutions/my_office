import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:my_office/core/utilities/constants/app_color.dart';
import 'package:my_office/features/work_details/data/data_source/work_detail_fb_data_source.dart';
import 'package:my_office/features/work_details/data/data_source/work_entry_fb_data_source_impl.dart';
import 'package:my_office/features/work_details/data/repository/work_detail_repo_impl.dart';
import 'package:my_office/features/work_details/domain/repository/work_detail_repository.dart';
import '../../../../core/utilities/constants/app_main_template.dart';
import '../../../user/domain/entity/user_entity.dart';
import '../../data/model/work_detail_model.dart';
import 'individual_work_detail_screen.dart';

class WorkCompleteViewScreen extends StatefulWidget {
  final UserEntity userDetails;

  const WorkCompleteViewScreen({Key? key, required this.userDetails})
      : super(key: key);

  @override
  State<WorkCompleteViewScreen> createState() => _WorkCompleteViewScreenState();
}

class _WorkCompleteViewScreenState extends State<WorkCompleteViewScreen> {
  late WorkDetailFbDataSource workDetailFbDataSource =
      WorkDetailFbDataSourceImpl();
  late WorkDetailRepository workDetailRepository =
      WorkDetailRepoImpl(workDetailFbDataSource: workDetailFbDataSource);

  // notifiers
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier(DateTime.now());
  final ValueNotifier<List<WorkDoneModel>> _workReport = ValueNotifier([]);

  @override
  void initState() {
    _fetchWorkDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      subtitle: 'Staff Work Details',
      templateBody: SizedBox.expand(child: buildStackWidget()),
      bgColor: AppColor.backGroundColor,
    );
  }

  Widget buildStackWidget() {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _workReport,
        builder: (ctx, List<WorkDoneModel> workReports, child) {
          return ValueListenableBuilder(
            valueListenable: _isLoading,
            builder: (ctx, bool loading, child) {
              if (loading && workReports.isEmpty) {
                return Center(
                  child:  Theme.of(context).scaffoldBackgroundColor == const Color(0xFF1F1F1F) ?
                  Lottie.asset('assets/animations/loading_light_theme.json'):
                  Lottie.asset('assets/animations/loading_dark_theme.json'),
                ); // Placeholder for Lottie animation
              } else {
                return Column(
                  children: [
                    if (!loading) datePickerWidget(),
                    if (workReports.isEmpty) noDataWidget(),
                    if (workReports.isNotEmpty) workDetailsList(workReports),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget datePickerWidget() {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: TextButton.icon(
        onPressed: datePicker,
        icon: Icon(Icons.calendar_month_rounded, color: Theme.of(context).primaryColor,),
        label: ValueListenableBuilder(
          valueListenable: _selectedDate,
          builder: (ctx, DateTime date, child) {
            return Text(
                DateFormat('yyyy-MM-dd').format(date),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
            );
          },
        ),
      ),
    );
  }

  Widget noDataWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No work done submitted yet!!',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget workDetailsList(List<WorkDoneModel> workReports) {
    return Expanded(
      child: ListView.builder(
        itemCount: workReports.length,
        itemBuilder: (context, index) {
          final item = workReports[index];
          return ListTile(
            leading: Container(
              width: 40.0,
              height: 40.0,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.hardEdge,
              child: workReports[index].url.isEmpty
                  ? const Image(image: AssetImage('assets/profile_icon.jpg'))
                  : CachedNetworkImage(
                      imageUrl: workReports[index].url,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                        color: AppColor.primaryColor,
                        value: downloadProgress.progress,
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
            ),
            title: Text(
                item.name,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
              fontSize: 16,
            ),
            ),
            subtitle: Text(
                item.department,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => IndividualWorkDone(
                  workDetails: workReports[index],
                ),
              ),
            ),
            // Additional UI elements and logic as needed
          );
        },
      ),
    );
  }

  // Functions
  datePicker() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    if (newDate == null) return;
    _selectedDate.value = newDate;
    _fetchWorkDetails();
  }

  Future<void> _fetchWorkDetails() async {
    _isLoading.value = true;
    _workReport.value.clear();
    _workReport.value =
        await workDetailRepository.getWorkDetails(_selectedDate.value);
    _isLoading.value = false;
  }
}

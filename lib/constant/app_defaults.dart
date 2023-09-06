import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/Account/account_screen.dart';
import 'package:my_office/PR/invoice_generator/screens/client_detials.dart';
import 'package:my_office/PR/products/scan_qr.dart';
import 'package:my_office/leave_details/leave_details.dart';
import 'package:my_office/models/staff_model.dart';
import '../Absentees/absentees.dart';
import '../PR/invoice_generator/quotation_template/view/home_screen.dart';
import '../PR/pr_workdone/pr_work_details.dart';
import '../PR/pr_workdone/pr_work_entry.dart';
import '../PR/products/new_product.dart';
import '../PR/products/point_calculations.dart';
import '../PR/reminder_screen.dart';
import '../PR/visit/visit_form_screen.dart';
import '../PR/visit_check.dart';
import '../finance/finance_analysis.dart';
import '../food_count/food_count_screen.dart';
import '../late_workdone/late_entry.dart';
import '../leads/create_leads.dart';
import '../leads/search_leads.dart';
import '../leave_apply/leave_apply_screen.dart';
import '../leave_approval/leave_approval_screen.dart';
import '../onyx/announcement.dart';
import '../proxy_attendance/attendance_screen.dart';
import '../refreshment/refreshment_screen.dart';
import '../rnd_form/installation_details.dart';
import '../staff_details/staff_details.dart';
import '../suggestions/suggestions.dart';
import '../suggestions/view_suggestions.dart';
import '../tl_check_screen/check_entry.dart';
import '../virtual_attendance/attendance_screen.dart';
import '../virtual_attendance/view_attendance.dart';
import '../work_details/work_complete.dart';
import '../work_entry/work_entry.dart';

class AppDefaults {
  static List<String> gridButtonsNames = [
    'Work entry',
    'Work details',
    'Refreshment',
    'Food count',
    'Leave apply form',
    // 'Onyx',
    // 'Absent details',
    'Leave approval',
    'Search leads',
    'Visit',
    'Visit check',
    'Invoice generator',
    'Finance',
    'Suggestions',
    // 'Virtual attendance',
    'View suggestions',
    // 'Check Virtual entry',
    // 'Late entry',
    'PR Work done',
    'Attendance',
    'Create products',
    'Sales points',
    'PR Work details',
    'Scan QR',
    'PR Reminder',
    'Leave details',
    'Create leads',
    'Quotation template',
    'Staff details',
    'Installation pdf',
    'Proxy attendance',
  ];

  static List<String> gridButtonPics = [
    'assets/work_entry.png',
    'assets/work_details.png',
    'assets/refreshment.png',
    'assets/food_count.png',
    'assets/leave_apply.png',
    // 'assets/onxy.png',
    // 'assets/absent_details.png',
    'assets/leave_approval.png',
    'assets/search_leads.png',
    'assets/visit.png',
    'assets/visit_check.png',
    'assets/invoice.png',
    'assets/finance.png',
    'assets/suggestions.png',
    // 'assets/virtual_attendance.png',
    'assets/view_suggestions.png',
    // 'assets/view_attendance.png',
    // 'assets/late_entry.png',
    'assets/pr_points.png',
    'assets/check_entry.png',
    'assets/new_products.png',
    'assets/points_calculation.png',
    'assets/pr_work_details.png',
    'assets/qr_scanner_points.png',
    'assets/reminder.png',
    'assets/leave_details.png',
    'assets/create_leads.png',
    'assets/quotation_template.png',
    'assets/staff_details.png',
    'assets/installation_image.png',
    'assets/proxy_attendance.png',
  ];

  Widget getPage(String buttonName, StaffModel staffInfo) {
    Widget page = AccountScreen(staffDetails: staffInfo);
    switch (buttonName) {
      case 'Work entry':
        page = WorkEntryScreen(
          userId: staffInfo.uid,
          staffName: staffInfo.name,
        );
        break;
      case 'Work details':
        page = WorkCompleteViewScreen(
          userDetails: staffInfo,
        );
        break;
      case 'Refreshment':
        page = RefreshmentScreen(
          uid: staffInfo.uid,
          name: staffInfo.name,
        );
        break;
      case 'Food count':
        page = const FoodCountScreen();
        break;
      case 'Leave apply form':
        page = LeaveApplyScreen(
          name: staffInfo.name,
          uid: staffInfo.uid,
          department: staffInfo.department,
        );
        break;
      // case 'Onyx':
      //   page = const AnnouncementScreen();
      //   break;
      // case 'Absent details':
      //   page = const AbsenteeScreen();
      //   break;
      case 'Leave approval':
        page = LeaveApprovalScreen(
          uid: staffInfo.uid,
          name: staffInfo.name,
          department: staffInfo.department,
        );
        break;
      case 'Search leads':
        page = SearchLeadsScreen(staffInfo: staffInfo);
        break;
      case 'Visit':
        page = const VisitFromScreen();
        break;
      case 'Visit check':
        page = const VisitCheckScreen();
        break;
      case 'Invoice generator':
        page = const ClientDetails();
        break;
      case 'Finance':
        page = const FinanceScreen();
        break;
      case 'Suggestions':
        page = SuggestionScreen(
          uid: staffInfo.uid,
          name: staffInfo.name,
        );
        break;
      // case 'Virtual attendance':
      //   page = AttendanceScreen(
      //     uid: staffInfo.uid,
      //     name: staffInfo.name,
      //   );
      //   break;
      case 'View suggestions':
        page = const ViewSuggestions();
        break;
      // case 'Check Virtual entry':
      //   page = ViewAttendanceScreen(
      //     userId: staffInfo.uid,
      //     staffName: staffInfo.name,
      //   );
      //   break;
      // case 'Late entry':
      //   page = LateEntryScreen(
      //     userId: staffInfo.uid,
      //     staffName: staffInfo.name,
      //   );
        break;
      case 'PR Work done':
        page = PrWorkDone(
          userId: staffInfo.uid,
          staffName: staffInfo.name,
        );
        break;
      case 'Attendance':
        page = CheckEntryScreen(
          userId: staffInfo.uid,
          staffName: staffInfo.name,
        );
        break;
      case 'Create products':
        page = const CreateNewProduct();
        break;
      case 'Sales points':
        page = const PointCalculationsScreen();
        break;
      case 'PR Work details':
        page = const PrWorkDetails();
        break;
      case 'Scan QR':
        page = const ScanQRScreen();
        break;
      case 'PR Reminder':
        page =  ReminderScreen(staffInfo: staffInfo,);
        break;
      case 'Leave details':
        page = const LeaveDetails();
        break;
      case 'Create leads':
        page = CreateLeads(staffName: staffInfo.name);
        break;
      case 'Quotation template':
        page = const Client1Details();
        break;
      case 'Staff details':
        page = const StaffDetails();
        break;
      case 'Installation pdf':
        page = const InstallationDetails();
        break;
      case 'Proxy attendance':
        page = ProxyAttendance(
          uid: staffInfo.uid,
          name: staffInfo.name,
        );
        break;
    }
    return page;
  }
}

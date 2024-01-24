import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_office/features/attendance/presentation/view/attendance_screen.dart';
import 'package:my_office/features/leads_achieved/presentation/view/leads_achieved_screen.dart';
import 'package:my_office/features/pay_slip/presentation/view/pay_slip_screen.dart';
import '../../../features/create_lead/presentation/view/create_lead_screen.dart';
import '../../../features/create_product/presentation/view/create_product_screen.dart';
import '../../../features/employee_of_the_week/presentation/view/employee_of_the_week.dart';
import '../../../features/finance/presentation/view/finance_screen.dart';
import '../../../features/food_count/presentation/view/food_count_screen.dart';
import '../../../features/home/presentation/view/account_details_screen.dart';
import '../../../features/home/data/model/staff_access_model.dart';
import '../../../features/hr_access/presentation/view/all_staffs_screen.dart';
import '../../../features/hr_access/presentation/view/create_account_screen.dart';
import '../../../features/installation_pdf/presentation/view/installation_details.dart';
import '../../../features/invoice_generator/presentation/view/client_details_screen.dart';
import '../../../features/pr_dashboard/presentation/view/pr_dash_screen.dart';
import '../../../features/pr_reminder/presentation/view/pr_reminder_screen.dart';
import '../../../features/proxy_attendance/presentation/view/proxy_attendance_screen.dart';
import '../../../features/quotation_template/presentation/view/quotation_home_screen.dart';
import '../../../features/refreshment/presentation/view/refreshment_screen.dart';
import '../../../features/sales_points/presentation/view/sales_point_screen.dart';
import '../../../features/scan_qr/presentation/view/scan_qr_screen.dart';
import '../../../features/search_leads/presentation/view/customer_leads_screen.dart';
import '../../../features/staff_details/presentation/view/staff_detail_screen.dart';
import '../../../features/suggestions/presentation/view/suggestion_screen.dart';
import '../../../features/user/domain/entity/user_entity.dart';
import '../../../features/view_suggestions/presentation/view/view_suggestion_screen.dart';
import '../../../features/work_details/presentation/view/work_detail_screen.dart';
import '../../../features/work_entry/presentation/view/work_entry_screen.dart';

const serverKey =
    'AAAAhAGZ-Jw:APA91bFk_GTSGX1LAj-ZxOW7DQn8Q69sYLStSB8lukQDlxBMmugrkQCsgIvuFm0fU5vBbVB5SATjaoO0mrCdsJm03ZEEZtaRdH-lQ9ZmX5RpYuyLytWyHVH7oDu-6LaShqrVE5vYHCqK';

class MenuTitle {
  static const String workEntry = 'Work Entry';
  static const String refreshment = 'Refreshment';
  static const String leavePortal = 'Leave Portal';
  static const String suggestion = 'Suggestions';
  static const String workDetail = 'Work Detail';
  static const String foodCount = 'Food Count';
  static const String leaveApproval = 'Leave Approval';
  static const String searchLead = 'Search Leads';
  static const String prVisit = 'PR Visit';
  static const String prVisitCheck = 'PR Visit Check';
  static const String createInvoice = 'Create Invoice';
  static const String finance = 'Finance';
  static const String viewSuggestions = 'View Suggestions';
  static const String prWorkDone = 'PR WorkDone';
  static const String attendance = 'Attendance';
  static const String createProduct = 'Create Product';
  static const String salesPoint = 'Sales Point';
  static const String prWorkDetails = 'PR Work Detail';
  static const String scanQR = 'Scan QR';
  static const String prReminder = 'PR Reminder';
  static const String leaveDetails = 'Leave Detail';
  static const String createLead = 'Create Lead';
  static const String quotationTemplate = 'Quotation Template';
  static const String staffDetail = 'Staff Detail';
  static const String installationPDF = 'Installation PDF';
  static const String proxyAttendance = 'Proxy Attendance';
  static const String prDashboard = 'PR Dashboard';
  static const String employeeOfTheWeek = 'Best Employee';
  static const String hrAccess = 'HR Access';
  static const String paySlip = 'Pay Slip';
  static const String createAccount = 'Create Account';
  static const String saleCount = 'Sale Count';
}

class AppDefaults {
  static List<StaffAccessModel> allAccess = [
    StaffAccessModel(
      title: MenuTitle.workEntry,
      image: 'assets/work_entry.png',
    ),
    StaffAccessModel(
      title: MenuTitle.refreshment,
      image: 'assets/refreshment.png',
    ),
//     // StaffAccessModel(title: MenuTitle.leavePortal, image: 'assets/leave_apply.png'),
    StaffAccessModel(
      title: MenuTitle.suggestion,
      image: 'assets/suggestions.png',
    ),
    StaffAccessModel(
      title: MenuTitle.workDetail,
      image: 'assets/work_details.png',
    ),
    StaffAccessModel(
      title: MenuTitle.foodCount,
      image: 'assets/food_count.png',
    ),
    // StaffAccessModel(
    //   title: MenuTitle.leaveApproval,
    //   image: 'assets/leave_approval.png',
    // ),
    StaffAccessModel(
      title: MenuTitle.searchLead,
      image: 'assets/search_leads.png',
    ),
//     StaffAccessModel(title: MenuTitle.prVisit, image: 'assets/visit.png'),
//     StaffAccessModel(
//       title: MenuTitle.prVisitCheck,
//       image: 'assets/visit_check.png',
//     ),
    StaffAccessModel(
      title: MenuTitle.createInvoice,
      image: 'assets/invoice.png',
    ),
    StaffAccessModel(
      title: MenuTitle.finance,
      image: 'assets/finance.png',
    ),
    StaffAccessModel(
      title: MenuTitle.viewSuggestions,
      image: 'assets/view_suggestions.png',
    ),
//     StaffAccessModel(
//       title: MenuTitle.prWorkDone,
//       image: 'assets/pr_points.png',
//     ),
    StaffAccessModel(
      title: MenuTitle.attendance,
      image: 'assets/virtual_attendance.png',
    ),
    StaffAccessModel(
      title: MenuTitle.createProduct,
      image: 'assets/new_products.png',
    ),
    StaffAccessModel(
      title: MenuTitle.salesPoint,
      image: 'assets/points_calculation.png',
    ),
//     StaffAccessModel(
//       title: MenuTitle.prWorkDetails,
//       image: 'assets/pr_work_details.png',
//     ),
    StaffAccessModel(
      title: MenuTitle.scanQR,
      image: 'assets/qr_scanner_points.png',
    ),
    StaffAccessModel(
      title: MenuTitle.prReminder,
      image: 'assets/reminder.png',
    ),
//     StaffAccessModel(
//       title: MenuTitle.leaveDetails,
//       image: 'assets/leave_details.png',
//     ),
    StaffAccessModel(
      title: MenuTitle.createLead,
      image: 'assets/create_leads.png',
    ),
    StaffAccessModel(
      title: MenuTitle.quotationTemplate,
      image: 'assets/quotation_template.png',
    ),
    StaffAccessModel(
      title: MenuTitle.staffDetail,
      image: 'assets/staff_details.png',
    ),
    StaffAccessModel(
      title: MenuTitle.installationPDF,
      image: 'assets/installation_image.png',
    ),
    StaffAccessModel(
      title: MenuTitle.proxyAttendance,
      image: 'assets/proxy_attendance.png',
    ),
    StaffAccessModel(
      title: MenuTitle.prDashboard,
      image: 'assets/pr_dashboard.png',
    ),
    StaffAccessModel(
      title: MenuTitle.employeeOfTheWeek,
      image: 'assets/best_employee.png',
    ),
    StaffAccessModel(
      title: MenuTitle.hrAccess,
      image: 'assets/all_staff_detail.png',
    ),
    StaffAccessModel(
      title: MenuTitle.paySlip,
      image: 'assets/pay_slip.png',
    ),
    StaffAccessModel(
        title: MenuTitle.createAccount,
        image: 'assets/create_account.png',
    ),
    StaffAccessModel(
        title: MenuTitle.saleCount,
        image: 'assets/images/leads_achieved.png',
    ),
  ];

  static Widget getPage(String title, UserEntity staffInfo) {
    Widget page = const AccountScreen();
    switch (title) {
      case MenuTitle.workEntry:
        page = WorkEntryScreen(
          userId: staffInfo.uid,
          staffName: staffInfo.name,
        );
        break;
      case MenuTitle.workDetail:
        page = WorkCompleteViewScreen(
          userDetails: staffInfo,
        );
        break;
      case MenuTitle.refreshment:
        page = RefreshmentScreen(
          uid: staffInfo.uid,
          name: staffInfo.name,
        );
        break;
      case MenuTitle.foodCount:
        page = const FoodCountScreen();
        break;
//       case MenuTitle.leavePortal:
//         page = const LeaveApplyScreen();
//         break;
//       case MenuTitle.leaveApproval:
//         page = const LeaveApprovalScreen();
//         break;
      case MenuTitle.searchLead:
        page = SearchLeadsScreen(staffInfo: staffInfo);
        break;
//       case MenuTitle.prVisit:
//         page = const VisitFromScreen();
//         break;
//       case MenuTitle.prVisitCheck:
//         page = const VisitCheckScreen();
//         break;
      case MenuTitle.createInvoice:
        page = const ClientDetails();
        break;
      case MenuTitle.finance:
        page = const FinanceScreen();
        break;
      case MenuTitle.suggestion:
        page = SuggestionScreen(
          uid: staffInfo.uid,
          name: staffInfo.name,
        );
        break;
      case MenuTitle.viewSuggestions:
        page = const ViewSuggestions();
        break;
//       case MenuTitle.prWorkDone:
//         page = PrWorkDone(
//           userId: staffInfo.uid,
//           staffName: staffInfo.name,
//         );
//         break;
      case MenuTitle.attendance:
        page = AttendanceScreen(
          userId: staffInfo.uid,
          staffName: staffInfo.name,
        );
        break;
      case MenuTitle.createProduct:
        page = const CreateNewProduct();
        break;
      case MenuTitle.salesPoint:
        page = const PointCalculationsScreen();
        break;
//       case MenuTitle.prWorkDetails:
//         page = const PrWorkDetails();
//         break;
      case MenuTitle.scanQR:
        page = const ScanQRScreen();
        break;
      case MenuTitle.prReminder:
        page = ReminderScreen(
          staffInfo: staffInfo,
        );
        break;
//       case MenuTitle.leaveDetails:
//         page = const LeaveDetails();
//         break;
      case MenuTitle.createLead:
        page = CreateLeads(staffName: staffInfo.name);
        break;
      case MenuTitle.quotationTemplate:
        page = const Client1Details();
        break;
      case MenuTitle.staffDetail:
        page = const StaffDetails();
        break;
      case MenuTitle.installationPDF:
        page = const InstallationDetails();
        break;
      case MenuTitle.proxyAttendance:
        page = ProxyAttendance(
          uid: staffInfo.uid,
          name: staffInfo.name,
        );
        break;
      case MenuTitle.prDashboard:
        page = const PrDashboard();
        break;
      case MenuTitle.employeeOfTheWeek:
        page = const BestEmployee();
        break;
      case MenuTitle.hrAccess:
        page = const AllStaffs();
        break;
      case MenuTitle.paySlip:
        page = PaySlip(user: staffInfo);
        break;
      case MenuTitle.createAccount:
        page = const CreateAccount();
        break;
      case MenuTitle.saleCount:
        page = const LeadsAchieved();
        break;
    }
    return page;
  }
}

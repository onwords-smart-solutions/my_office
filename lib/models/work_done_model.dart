class WorkDoneModel {
  final String name;
  final String department;
  final String url;
  final String email;
  final List<WorkReport> reports;

  WorkDoneModel({
    required this.name,
    required this.department,
    required this.url,
    required this.email,
    required this.reports,
  });
}

class WorkReport {
  final String from;
  final String to;
  final String duration;
  final String workdone;
  final String percentage;

  WorkReport({
    required this.from,
    required this.to,
    required this.duration,
    required this.workdone,
    required this.percentage,
  });
}
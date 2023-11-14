class WorkEntryRecord {
  String startTime;
  String endTime;
  String workDone;
  String workPercentage;
  String name;
  String timeInHours;

  WorkEntryRecord({
    required this.startTime,
    required this.endTime,
    required this.workDone,
    required this.workPercentage,
    required this.name,
    required this.timeInHours,
  });

  Map<String, dynamic> toMap() {
    return {
      'from': startTime,
      'to': endTime,
      'workDone': workDone,
      'workPercentage': workPercentage,
      'name': name,
      'time_in_hours': timeInHours,
    };
  }

  static WorkEntryRecord fromMap(Map<dynamic, dynamic> map) {
    return WorkEntryRecord(
      startTime: map['from'],
      endTime: map['to'],
      workDone: map['workDone'],
      workPercentage: map['workPercentage'],
      name: map['name'],
      timeInHours: map['time_in_hours'],
    );
  }
}

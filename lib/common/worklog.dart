class WorkLogPojo {
  final int logId;
  final String workDescription;
  final DateTime workStartTime;
  final DateTime workEndTime;
  final String duration;

  WorkLogPojo({
    required this.logId,
    required this.workDescription,
    required this.workStartTime,
    required this.workEndTime,
    required this.duration,
  });

  factory WorkLogPojo.fromJson(Map<String, dynamic> json) {
    return WorkLogPojo(
      logId: json['logId'],
      workDescription: json['workDescription'],
      workStartTime: DateTime.parse(json['workStartTime']),
      workEndTime: DateTime.parse(json['workEndTime']),
      duration: json['duration'],
    );
  }
}

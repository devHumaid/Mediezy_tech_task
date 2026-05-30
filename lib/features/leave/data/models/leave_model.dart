class LeaveModel {
  final String? id;
  final String? leaveMode;    // 'full_day' | 'half_day'
  final String? leaveType;    // 'casual' etc
  final String? startDate;
  final String? endDate;
  final String? reason;
  final String? status;       // 'pending' | 'approved' | 'rejected'
  final String? userId;

  LeaveModel({
    this.id, this.leaveMode, this.leaveType,
    this.startDate, this.endDate, this.reason,
    this.status, this.userId,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id:        json['id']?.toString(),
      leaveMode: json['leave_mode'],
      leaveType: json['leave_type'],
      startDate: json['start_date'],
      endDate:   json['end_date'],
      reason:    json['reason'],
      status:    json['status'],
      userId:    json['user_id']?.toString(),
    );
  }
}
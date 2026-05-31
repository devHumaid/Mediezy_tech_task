class AttendanceModel {
  final String? id;
  final String? attendanceStatus;
  final String? checkInTime;
  final String? checkOutTime;
  final String? date;
  final double? latitude;
  final double? longitude;
  final String? userId;
  final String? shiftStartTime;  

  AttendanceModel({
    this.id,
    this.attendanceStatus,
    this.checkInTime,
    this.checkOutTime,
    this.date,
    this.latitude,
    this.longitude,
    this.userId,
    this.shiftStartTime,  
  });

  bool get isNotStarted =>
      attendanceStatus == 'not_marked_in' || attendanceStatus == null;

  bool get isMarkedIn =>
      (attendanceStatus == 'mark_in' || attendanceStatus == 'marked_in') &&
      checkOutTime == null;

  bool get isDayCompleted => checkInTime != null && checkOutTime != null;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    final data = json['attendance'] is Map
        ? json['attendance'] as Map<String, dynamic>
        : json;

    return AttendanceModel(
      id:               data['id']?.toString(),
      attendanceStatus: data['attendance_status'] ?? data['status'],
      checkInTime:      data['check_in_time'] ?? data['mark_in_time'] ?? data['checkin_time'],
      checkOutTime:     data['check_out_time'] ?? data['mark_out_time'] ?? data['checkout_time'],
      date:             data['date'] ?? data['created_at'],
      latitude:         (data['latitude']  as num?)?.toDouble(),
      longitude:        (data['longitude'] as num?)?.toDouble(),
      userId:           data['user_id']?.toString(),
      shiftStartTime:   data['shift_start_time'],  // ← ADD THIS
    );
  }
}
/// Pure domain entity for attendance
/// Maps to GET /attendance/status response
class AttendanceEntity {
  final String? id;
  final String? attendanceStatus; // 'mark_in' | 'mark_out'
  final String? checkInTime;
  final String? checkOutTime;
  final String? date;
  final double? latitude;
  final double? longitude;

  const AttendanceEntity({
    this.id,
    this.attendanceStatus,
    this.checkInTime,
    this.checkOutTime,
    this.date,
    this.latitude,
    this.longitude,
  });

  bool get isMarkedIn =>
      (attendanceStatus == 'mark_in' || attendanceStatus == 'marked_in') &&
      checkOutTime == null;

  bool get isDayCompleted => checkInTime != null && checkOutTime != null;
}
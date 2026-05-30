import '../entities/attendance_entity.dart';

/// Abstract contract for dashboard/attendance operations
abstract class DashboardRepository {
  /// GET /attendance/status
  Future<AttendanceEntity> getAttendanceStatus();

  /// POST /attendance/mark
  /// [attendanceStatus] → 'mark_in' or 'mark_out'
  Future<Map<String, dynamic>> markAttendance({
    required String attendanceStatus,
    required double latitude,
    required double longitude,
  });
}
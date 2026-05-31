import '../entities/attendance_entity.dart';

abstract class DashboardRepository {
  Future<AttendanceEntity> getAttendanceStatus();


  Future<Map<String, dynamic>> markAttendance({
    required String attendanceStatus,
    required double latitude,
    required double longitude,
  });
}
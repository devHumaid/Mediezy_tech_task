import 'package:mediezy_tech_task/features/dashboard/data/datasource/attendance_model.dart' show AttendanceModel;

import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';

/// Handles all API calls needed by the Dashboard:
/// - GET  /attendance/status
/// - POST /attendance/mark
class DashboardRemoteDataSource {
  final ApiClient _api = ApiClient.instance;

  /// GET /attendance/status
  /// Returns current attendance state of the logged-in user
  Future<AttendanceModel> getAttendanceStatus() async {
    final response = await _api.get(ApiConstants.attendanceStatus);
    return AttendanceModel.fromJson(response);
  }

  /// POST /attendance/mark
  /// [attendanceStatus] → 'mark_in' or 'mark_out'
  /// [latitude] & [longitude] → from device GPS
  Future<Map<String, dynamic>> markAttendance({
    required String attendanceStatus,
    required double latitude,
    required double longitude,
  }) async {
    return await _api.post(
      ApiConstants.attendanceMark,
      data: {
        'attendance_status': attendanceStatus,
        'latitude':          latitude,
        'longitude':         longitude,
      },
    );
  }
}
import 'package:mediezy_tech_task/core/constants/app_constants.dart';
import 'package:mediezy_tech_task/features/dashboard/data/datasource/attendance_model.dart' show AttendanceModel;

import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';


class DashboardRemoteDataSource {
  final ApiClient _api = ApiClient.instance;

  /// get /attendance/status
  Future<AttendanceModel> getAttendanceStatus() async {
    final response = await _api.get(ApiConstants.attendanceStatus);
    return AttendanceModel.fromJson(response);
  }

  /// post /attendance/mark

Future<Map<String, dynamic>> markAttendance({
  required String attendanceStatus,
  required double latitude,
  required double longitude,
}) async {
  return await _api.post(
    ApiConstants.attendanceMark,
    data: {
      'attendance_status': attendanceStatus == AppConstants.attendanceIn ? 1 : 2,
      'latitude':          latitude,
      'longitude':         longitude,
    },
  );
}
}
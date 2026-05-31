
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://test.zyromate.com/api';

  //  auth
  static const String userLogin = '/user-login';
//register
  static const String register = '/register';

  //  Attendance
  static const String attendanceStatus = '/attendance/status';

  // mark attendance
  static const String attendanceMark = '/attendance/mark';

  //= route list
  static const String routeList = '/attendance/route-list';

  // apply leave 
  static const String applyLeave = '/apply-leave';

  /// leave list 
  static const String leaves = '/leaves';

  //  timeouts 
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
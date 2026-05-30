/// All API endpoints for Zyromate app
/// Base URL: https://test.zyromate.com/api/
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://test.zyromate.com/api';

  // ── Auth ──────────────────────────────────────────────────────────────
  /// POST  | mobile_number, password
  static const String userLogin = '/user-login';

  /// POST  | first_name, last_name, email, password,
  ///         address, dob, mobile_number, doj, location
  static const String register = '/register';

  // ── Attendance ────────────────────────────────────────────────────────
  /// GET   | – (token in header)
  static const String attendanceStatus = '/attendance/status';

  /// POST  | attendance_status, latitude, longitude
  static const String attendanceMark = '/attendance/mark';

  /// GET   | – (token in header)
  static const String routeList = '/attendance/route-list';

  // ── Leave ─────────────────────────────────────────────────────────────
  /// POST  | leave_mode (half_day | full_day), leave_type,
  ///         start_date, end_date, reason, user_id
  static const String applyLeave = '/apply-leave';

  /// POST  | employee_id, leave_type (all | pending | approved | rejected),
  ///         month
  static const String leaves = '/leaves';

  // ── Timeouts ──────────────────────────────────────────────────────────
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
class AppConstants {
  AppConstants._();

  // ── SharedPreferences Keys ────────────────────────────────────────────
  static const String keyToken      = 'auth_token';
  static const String keyUserId     = 'user_id';
  static const String keyUserName   = 'user_name';
  static const String keyUserRole   = 'user_role';
  static const String keyLocation   = 'user_location';
  static const String keyIsLoggedIn = 'is_logged_in';

  // ── Leave Modes ───────────────────────────────────────────────────────
  static const String leaveModeFullDay = 'full_day';
  static const String leaveModeHalfDay = 'half_day';

  // ── Leave Types ───────────────────────────────────────────────────────
  static const String leaveTypeAll      = 'all';
  static const String leaveTypePending  = 'pending';
  static const String leaveTypeApproved = 'approved';
  static const String leaveTypeRejected = 'rejected';

  // ── Attendance Status ─────────────────────────────────────────────────
  static const String attendanceIn  = 'mark_in';
  static const String attendanceOut = 'mark_out';

  // ── Date Format ───────────────────────────────────────────────────────
  static const String dateFormat     = 'dd/MM/yyyy';
  static const String dateFormatApi  = 'yyyy-MM-dd';
}
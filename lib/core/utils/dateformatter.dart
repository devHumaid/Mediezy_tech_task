class DateFormatter {
  DateFormatter._();

  /// Formats DateTime to DD/MM/YYYY for display
  static String toDisplay(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';

  /// Formats DateTime to YYYY-MM-DD for API requests
  static String toApi(DateTime date) =>
      '${date.year}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';


  static String monthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August', 'September',
      'October', 'November', 'December',
    ];
    if (month < 1 || month > 12) return '';
    return months[month];
  }

  /// Converts "DD/MM/YYYY" display format → "YYYY-MM-DD" API format
  static String displayToApi(String display) {
    final parts = display.split('/');
    if (parts.length != 3) return display;
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }
}
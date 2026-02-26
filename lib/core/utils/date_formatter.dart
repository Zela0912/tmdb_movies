class DateFormatter {
  DateFormatter._();

  static String formatYear(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    return date.split('-').first;
  }

  static String formatFullDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    final parts = date.split('-');
    if (parts.length < 3) return 'N/A';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final month = int.tryParse(parts[1]);
    if (month == null || month < 1 || month > 12) return 'N/A';
    return '${parts[2]} ${months[month - 1]} ${parts[0]}';
  }
}
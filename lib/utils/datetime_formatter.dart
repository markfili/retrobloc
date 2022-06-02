import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';

class DateTimeFormatter {
  DateTimeFormatter._();

  static const minimumDifferenceInHours = 12;
  static const sourceDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SS'Z'"; // 2021-11-03T13:40:00Z
  static const targetDateTimeFormat = "MMM, d, y • HH:mm"; // "Feb, 26, 2021 • 19:38";

  /// Returns a timeago string if time difference is less than minimum required,
  /// otherwise local datetime string is returned
  static String toHumanFormat(String dateTimeUTC) {
    var now = DateTime.now().toUtc();
    var dateTime = DateFormat(sourceDateTimeFormat).parseUTC(dateTimeUTC);
    var difference = now.difference(dateTime);
    if (difference.inHours < minimumDifferenceInHours) {
      return format(now.subtract(difference));
    }
    return DateFormat(targetDateTimeFormat).format(dateTime.toLocal());
  }
}

import 'package:intl/intl.dart';
import '../../imports/common.dart';
import 'package:timezone/timezone.dart' as tz;

class DateFunctions {
  static String getDateInSingleNumber({required String date, required String timezone}) {
    DateTime dateTime = DateTime.parse(date);
    final location = tz.getLocation(timezone);
    final tzDateTime = tz.TZDateTime.from(dateTime, location);
    return tzDateTime.day.toString();
  } //13

  static String getMonthInSingleNumber({required String date, required String timezone}) {
    DateTime dateTime = DateTime.parse(date);
    final location = tz.getLocation(timezone);
    final tzDateTime = tz.TZDateTime.from(dateTime, location);
    return DateFormat('MMM').format(tzDateTime);
  } // March

  static String getMMMMddyyyyFormat({required String date}) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('MMMM dd, yyyy').format(dateTime);
  }

  static String getMMMddyyyyFormat({required String date}) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  static String getddMMMyyyyFormat({required String date}) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static String getddMMyyHmma({required String date, required String timezone}) {
    final location = tz.getLocation(timezone);
    DateTime dateTime = DateTime.parse(date);
    final tzDateTime = tz.TZDateTime.from(dateTime, location);
    String formattedDate = DateFormat('MMM dd, yyyy h:mm a').format(tzDateTime);
   return formattedDate;
  }

  static String getDateRange({required String startDate, required String endDate}) {
    DateTime startDateTime = DateTime.parse(startDate);
    DateTime endDateTime = DateTime.parse(endDate);
    String formattedStartDate = DateFormat('MMM d, yyyy ha').format(startDateTime);
    String formattedEndDate = DateFormat('MMM d, yyyy ha').format(endDateTime);
    return '$formattedStartDate - $formattedEndDate';
  } // July 09 - 11, 2024

  static String getMonthDateYearFormatWithTimeZone(
      {required String timezone, required String date}) {
    DateTime dateTime = DateTime.parse(date);
    final location = tz.getLocation(timezone);
    final tzDateTime = tz.TZDateTime.from(dateTime, location);
    String formattedDate = DateFormat('MMMM dd, yyyy').format(tzDateTime);

    final String timeZoneAbbreviation = timezone == 'US/Pacific'
        ? 'PST'
        : timezone == 'US/Mountain'
            ? 'MST'
            : timezone == 'US/Central'
                ? 'CT'
                : timezone == 'US/Eastern'
                    ? 'ET'
                    : timezone == 'Canada/Atlantic'
                        ? 'AT'
                        : timezone == 'US/Hawaii'
                            ? 'HST'
                            : timezone == 'US/Alaska'
                                ? 'AKST'
                                : 'Unknown';
    return '$formattedDate ($timeZoneAbbreviation)';
  } // July 09, 2024 (PST)

  static String getDayOfWeek({required String date}) {
    String inputDate = date;
    DateTime dateTime = DateTime.parse(inputDate);
    String dayOfWeek =
        DateFormat('EEEE').format(dateTime); // Format to get day of week
    return dayOfWeek;
  }
  static String getDayOfWeekInTimeZone({required String date, required String timezone}) {
    String inputDate = date;
    DateTime dateTime = DateTime.parse(inputDate);
    final location = tz.getLocation(timezone);
    final tzDateTime = tz.TZDateTime.from(dateTime, location);
    String dayOfWeek =
        DateFormat('EEEE').format(tzDateTime); // Format to get day of week
    return dayOfWeek;
  }

  static String getTimeStamp({required String startTime, required String endTime}) {
    String formattedTime1 = AppStrings.global_empty_string,
        formattedTime2 = AppStrings.global_empty_string;
    if (startTime.isNotEmpty) {
      DateTime time1 = DateFormat('HH:mm').parse(startTime);

        formattedTime1 = DateFormat('hh:mm a').format(time1);

    }
    if (endTime.isNotEmpty) {
      DateTime time2 = DateFormat('HH:mm').parse(endTime);
        formattedTime2 = DateFormat('hh:mm a').format(time2);

    }

    if (endTime.isEmpty) {
      return formattedTime1;
    } else {
      return '$formattedTime1 - $formattedTime2';
    }
  }

  static String formatDateForChat(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat('hh:mm a');
    return dateFormat.format(dateTime);
  }

  static String getMMddyy(DateTime dateTime){
    final formattedDate = DateFormat('MM/dd/yy').format(dateTime);
    return formattedDate;
    // print(formattedDate); // Output: 10/19/23 (or the current date in mm/dd/yy format)
  }
  static String formatDateTimeRange(String a, String b) {
    final formatter = DateFormat('MMM d, yyyy h:mm a');
    final formattedA = formatter.format(DateTime.parse(a));
    final formattedB = formatter.format(DateTime.parse(b));
    return '$formattedA - $formattedB';
  }

  static String formatChatTimestamp(DateTime timestamp) {
    final localTime = timestamp.toLocal(); // Convert to local time zone

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(localTime.year, localTime.month, localTime.day);

    if (messageDate == today) {
      return DateFormat('hh:mm a').format(localTime); // e.g., "10:30 AM"
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return "Yesterday";
    } else if (now.difference(localTime).inDays < 7) {
      return DateFormat('EEEE').format(localTime); // e.g., "Monday"
    } else {
      return DateFormat('dd/MM/yyyy').format(localTime); // e.g., "10/02/2024"
    }
  }
}

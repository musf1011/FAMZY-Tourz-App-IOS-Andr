// import 'package:intl/intl.dart';

// String getFormattedTime(int? timestampMs, {String format = 'HH:mm'}) {
//   if (timestampMs == null || timestampMs <= 0) {
//     return "Message"; // Handle null or invalid timestamps
//   }

//   // Convert milliseconds to DateTime
//   DateTime dateTime =
//       DateTime.fromMillisecondsSinceEpoch(timestampMs, isUtc: true);

//   // Format the time
//   return DateFormat(format).format(dateTime);
// }

import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;

String getFormattedTime(int? timestampMs, {String format = 'HH:mm'}) {
  if (timestampMs == null || timestampMs <= 0) {
    return "Message"; // Handle null or invalid timestamps
  }

  // Initialize time zones (call this once in your main function)
  tz.initializeTimeZones();

  // Get the Pakistan Standard Time (PKT) location
  final pkt = getLocation('Asia/Karachi');

  // Convert milliseconds to DateTime in PKT
  final dateTimeUtc =
      DateTime.fromMillisecondsSinceEpoch(timestampMs, isUtc: true);
  final dateTimePkt = TZDateTime.from(dateTimeUtc, pkt);

  // Format the time
  return DateFormat(format).format(dateTimePkt);
}

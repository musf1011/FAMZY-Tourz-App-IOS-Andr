import 'package:intl/intl.dart';

String getFormattedTime(int? timestampMs, {String format = 'HH:mm'}) {
  if (timestampMs == null || timestampMs <= 0) {
    return "Message"; // Handle null or invalid timestamps
  }

  // Convert milliseconds to DateTime
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(timestampMs, isUtc: true);

  // Format the time
  return DateFormat(format).format(dateTime);
}

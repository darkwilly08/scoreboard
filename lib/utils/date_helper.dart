import 'package:anotador/constants/const_variables.dart';
import 'package:intl/intl.dart';

class DateUtils {
  DateUtils._privateConstructor();

  static final DateUtils _instance = DateUtils._privateConstructor();

  String getFormattedDate(
      [DateTime? dateTime, int? timestamp, String? pattern]) {
    DateTime dt = DateTime.now();
    if (dateTime != null) {
      dt = dateTime;
    } else if (timestamp != null) {
      dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    }

    DateFormat df = DateFormat.yMMMd().add_Hm();
    if (pattern != null) {
      df = DateFormat(pattern);
    }
    return df.format(dt);
  }

  String toDB(DateTime dateTime) {
    String pattern = AppConstants.dbDateTimeFormat;
    return DateFormat(pattern).format(dateTime);
  }

  DateTime fromDB(String dateString) {
    return DateTime.parse(dateString);
  }

  static DateUtils get instance => _instance;
}

import 'package:intl/intl.dart';

class DateTimeUtils {

  static String getHistoryEventDate(int timeInMillis){
    var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    return new DateFormat.jm() .format(date)+" - "+DateFormat.yMMMd().format(date);
  }
}
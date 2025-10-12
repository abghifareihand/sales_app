import 'package:intl/intl.dart';

class Formatter {
  static String toRupiah(int number) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatCurrency.format(number);
  }

  static String toRupiahDouble(double number) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatCurrency.format(number);
  }

  static String toNoRupiahDouble(double number) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);
    return formatCurrency.format(number);
  }

  static String toDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final formatter = DateFormat('dd MMM yyyy HH:mm', 'id_ID');
      return formatter.format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  static String toDateTimeFull(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final formatter = DateFormat('dd/MM/yyyy HH:mm');
      return formatter.format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  static String toDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final formatter = DateFormat('dd MMM yyyy', 'id_ID');
      return formatter.format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  static String toTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final formatter = DateFormat('HH:mm WIB', 'id_ID');
      return formatter.format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }
}

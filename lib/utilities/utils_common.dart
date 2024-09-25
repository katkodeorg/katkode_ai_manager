import 'package:uuid/uuid.dart';

class UtilsCommon {
  static double celsiusToFahrenheit(double celsius) {
    return celsius * 9 / 5 + 32;
  }

  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  static double toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    return double.parse(value.toString());
  }

  static int toInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    return int.parse(value.toString());
  }

  static String generateId() {
    // TODO: Implement a better way to generate unique id
    return 'uid-${DateTime.now().microsecondsSinceEpoch}-${const Uuid().v4()}';
  }

  static String getGreetings() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  static String getCurrentTime() {
    return DateTime.now().toIso8601String();
  }

  static List<double> getRangeList(double quantity) {
    List<double> rangeList = [];

    for (int i = 1; i <= quantity; i++) {
      rangeList.add(i.toDouble());
    }

    return rangeList;
  }

  static String dToStr(dynamic quantity, {int decimalPlaces = 2}) {
    if (quantity == null) {
      return '0.00';
    }
    return quantity.toStringAsFixed(decimalPlaces);
  }

  static void log(dynamic message, {bool isError = false, Error? error}) {
    // if its a long string message, split it into multiple lines
    if (message is String) {
      // split based on character length
      List<String> lines = [];
      int start = 0;
      int end = 1000;
      while (start < message.length) {
        if (end > message.length) {
          end = message.length;
        }
        lines.add(message.substring(start, end));
        start = end;
        end += 1000;
      }

      for (var line in lines) {
        if (isError || error != null) {
          print('Error: $line');
        } else {
          print(line);
        }
      }
    } else {
      print(message);
    }

    if (error != null) {
      print(error);
    }

    print('----------------------------------------');
  }
}

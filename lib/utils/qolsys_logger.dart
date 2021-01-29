import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  final String className;

  SimpleLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final emoji = PrettyPrinter.levelEmojis[event.level];
    final output = '$emoji $className - ${event.message}';
    return [output];
  }
}

Logger getLogger(String className) {
  return Logger(
    printer: SimpleLogPrinter(className),
  );
}

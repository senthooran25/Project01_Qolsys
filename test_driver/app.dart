import 'package:flutter_driver/driver_extension.dart';
import 'package:qolsys_app/main.dart' as app;

//enable driver and
//tell which app to test
main() async {
  enableFlutterDriverExtension();
  await app.main(isTest: true);
}

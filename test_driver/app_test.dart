import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:dotenv/dotenv.dart' show env;

//adjustable delay between actions
const int delay = 0;
Future sleep(int seconds) => Future.delayed(Duration(seconds: seconds));
void main() {
  group('test login process', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() {
      driver?.close();
    });

    final usernameWidget = find.byValueKey('username field');
    final passwordWidget = find.byValueKey('password field');
    final signOnWidget = find.text('Sign On');

    group('signOn test', () {
      test('username, password both empty', () async {
        await sleep(delay);
        await driver.tap(usernameWidget);
        await driver.enterText('');

        await sleep(delay);
        await driver.tap(passwordWidget);
        await driver.enterText('');

        await sleep(delay);
        await driver.tap(signOnWidget);

        await sleep(delay);
        var usernameEmpty = find.text('username cannot be empty');
        await driver.waitFor(usernameEmpty, timeout: Duration(seconds: 2));
        await driver.tap(usernameEmpty);
      });

      test('username empty', () async {
        await sleep(delay);
        await driver.tap(usernameWidget);
        await driver.enterText('');

        await sleep(delay);
        await driver.tap(passwordWidget);
        await driver.enterText('xyz');

        await sleep(delay);
        await driver.tap(signOnWidget);

        await sleep(delay);
        final userNameEmpty = find.text('username cannot be empty');
        await driver.waitFor(userNameEmpty, timeout: Duration(seconds: 2));
        await driver.tap(userNameEmpty);
      });

      test('password empty', () async {
        await sleep(delay);
        await driver.tap(usernameWidget);
        await driver.enterText('xyz');

        await sleep(delay);
        await driver.tap(passwordWidget);
        await driver.enterText('');

        await sleep(delay);
        await driver.tap(signOnWidget);

        await sleep(delay);
        final passwordEmpty = find.text('password cannot be empty');
        await driver.waitFor(passwordEmpty, timeout: Duration(seconds: 2));
        await driver.tap(passwordEmpty);
      });

      test('user doesn\'t exist', () async {
        await sleep(delay);
        await driver.tap(usernameWidget);
        await driver.enterText('xyz');

        await sleep(delay);
        await driver.tap(passwordWidget);
        await driver.enterText('xyz');

        await sleep(delay);
        await driver.tap(signOnWidget);

        await sleep(delay);
        final noUser = find.text('Invalid username or password');
        await driver.waitFor(noUser, timeout: Duration(seconds: 10));
        await driver.tap(noUser);
      });

      test('incorrect password', () async {
        await sleep(delay);
        String username = env['username'];
        await driver.tap(usernameWidget);
        await driver.enterText(username);

        await sleep(delay);
        await driver.tap(passwordWidget);
        await driver.enterText('xyz');

        await sleep(delay);
        await driver.tap(signOnWidget);

        await sleep(delay);
        final noUser = find.text('Invalid username or password');
        await driver.waitFor(noUser, timeout: Duration(seconds: 10));
        await driver.tap(noUser);
      });

      test('valid user', () async {
        String username = env['username'];
        String password = env['password'];
        expect(username, isNotNull);
        expect(password, isNotNull);

        await sleep(delay);
        await driver.tap(usernameWidget);
        await driver.enterText(username);

        await sleep(delay);
        await driver.tap(passwordWidget);
        await driver.enterText(password);

        await sleep(delay);
        await driver.tap(signOnWidget);

        await sleep(delay);
        final security = find.text('SECURITY');
        await driver.waitFor(security, timeout: Duration(seconds: 30));
      });

      test('logout test', () async {
        await sleep(delay);
        final settingsGear = find.byValueKey('settings');
        await driver.tap(settingsGear);

        await sleep(delay);
        final logoutButton = find.text('Log Out');
        await driver.tap(logoutButton);

        await sleep(delay);
        final yesText = find.text('Yes');
        await driver.tap(yesText);

        await sleep(delay);
        final signOn = find.text('Sign On');
        await driver.waitFor(signOn, timeout: Duration(seconds: 1));
      });
    });
  });
}

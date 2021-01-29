import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qolsys_app/pages/login_page.dart';
import 'package:qolsys_app/pages/security_page.dart';

import '../lib/generated/codegen_loader.g.dart';
import '../lib/main.dart';
import 'package:dotenv/dotenv.dart' show env;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Setup the finders
  final usernameWidget = find.byKey(Key('username field'));
  final passwordWidget = find.byKey(Key('password field'));
  final signOnWidget = find.text('Sign On');
/*
  testWidgets("'username, password both empty'", (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        child: QolsysApp(),
        supportedLocales: [
          Locale("en"),
          Locale("es"),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale("en"),
        assetLoader: CodegenLoader(),
      ),
    );

    await tester.pumpAndSettle(Duration(seconds: 2));
    await tester.enterText(usernameWidget, '');
    await tester.enterText(passwordWidget, '');
    await tester.tap(signOnWidget);
    await tester.pumpAndSettle();
    var usernameEmpty = find.text('username cannot be empty');
    await tester.pumpAndSettle(Duration(seconds: 2));
    expect(usernameEmpty, findsOneWidget);
    await tester.tap(usernameEmpty);
  });


  testWidgets("Username empty", (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        child: QolsysApp(),
        supportedLocales: [
          Locale("en"),
          Locale("es"),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale("en"),
        assetLoader: CodegenLoader(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(usernameWidget, '');
    await tester.enterText(passwordWidget, 'xyz');
    await tester.tap(signOnWidget);
    await tester.pumpAndSettle();
    var usernameEmpty = find.text('username cannot be empty');
    await tester.pumpAndSettle(Duration(seconds: 2));
    expect(usernameEmpty, findsOneWidget);
    await tester.tap(usernameEmpty);
  });

  testWidgets("password empty", (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        child: QolsysApp(),
        supportedLocales: [
          Locale("en"),
          Locale("es"),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale("en"),
        assetLoader: CodegenLoader(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(usernameWidget, 'xyz');
    await tester.enterText(passwordWidget, '');
    await tester.tap(signOnWidget);
    await tester.pumpAndSettle();
    var usernameEmpty = find.text('password cannot be empty');
    await tester.pumpAndSettle(Duration(seconds: 2));
    expect(usernameEmpty, findsOneWidget);
    await tester.tap(usernameEmpty);
  });

  testWidgets("user doesn\'t exist", (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        child: QolsysApp(),
        supportedLocales: [
          Locale("en"),
          Locale("es"),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale("en"),
        assetLoader: CodegenLoader(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(usernameWidget, 'xyz');
    await tester.enterText(passwordWidget, 'xyz');
    await tester.tap(signOnWidget);
    await tester.pumpAndSettle();
    var usernameEmpty = find.text('Invalid username or password');
    await tester.pumpAndSettle(Duration(seconds: 2));
    expect(usernameEmpty, findsOneWidget);
    await tester.tap(usernameEmpty);
  });

  testWidgets("incorrect password", (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        child: QolsysApp(),
        supportedLocales: [
          Locale("en"),
          Locale("es"),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale("en"),
        assetLoader: CodegenLoader(),
      ),
    );
    String username = env['username'];
    await tester.pumpAndSettle();
    await tester.enterText(usernameWidget, "ariel.moreno");
    await tester.enterText(passwordWidget, 'xyz');
    await tester.tap(signOnWidget);
    await tester.pumpAndSettle();
    var usernameEmpty = find.text('Invalid username or password');
    await tester.pumpAndSettle(Duration(seconds: 2));
    expect(usernameEmpty, findsOneWidget);
    await tester.tap(usernameEmpty);
  });
  */
  testWidgets("valid user'", (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        child: QolsysApp(),
        supportedLocales: [
          Locale("en"),
          Locale("es"),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale("en"),
        assetLoader: CodegenLoader(),
      ),
    );
    // String username = env['username'];
    // String password = env['password'];
    // expect(username, isNotNull);
    // expect(password, isNotNull);
    await tester.pumpAndSettle();
    await tester.enterText(usernameWidget, 'ariel.moreno');
    await tester.enterText(passwordWidget, 'Ariel@123');
    await tester.tap(signOnWidget);

    await tester.pumpAndSettle(Duration(seconds: 30));
    final security = find.text('SECURITY');
    expect(find.byType(LoginPage), findsNothing);
    expect(find.byType(SecurityPage), findsOneWidget);
    expect(security, findsOneWidget);
  });
/*
  testWidgets("logout test", (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        child: QolsysApp(),
        supportedLocales: [
          Locale("en"),
          Locale("es"),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale("en"),
        assetLoader: CodegenLoader(),
      ),
    );
    await tester.pumpAndSettle(Duration(seconds: 4));
    final settingsGear = find.byKey(Key('settings'));
    await tester.tap(settingsGear);

    await tester.pumpAndSettle();
    final logoutButton = find.byKey(Key('Log Out'));
    await tester.tap(logoutButton);

    await tester.pumpAndSettle();
    final yesText = find.text('Yes');
    await tester.tap(yesText);

    await tester.pumpAndSettle();
    final signON = find.text('Sign On');
    expect(signON, findsWidgets);
  });
*/
}

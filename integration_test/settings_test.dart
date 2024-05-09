import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'shared/elements.dart' as elements;
import 'shared/uihelper.dart';

main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await settingsTest();
}

Future<void> settingsTest() async {
  group('Settings Page Testing', () {
    testWidgets("Verify Navigation to settings page",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and enters Home page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.tap(elements.settingsIcon);
      await tester.pumpAndSettle();

      //Then verify settings title is shown
      expect(elements.settingsTitle, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify account title on settings page",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and enters Home page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();

      //Then verify account title is shown
      expect(elements.settingsAccountTitle, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify account elements on settings page",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and enters Home page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();

      //Then verify account elements are shown
      expect(elements.settingsUserEmail, findsOneWidget);
      expect(elements.settingsLogOutUser, findsOneWidget);
      expect(elements.settingsUpdateProfile, findsOneWidget);
      expect(elements.settingsSitesTitle, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify misc. title on settings page",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and navigates to Settings page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();

      //Then verify misc. title is shown
      expect(elements.settingsMiscTitle, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify misc. elements on settings page",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and navigates to Settings page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();

      //Then verify misc. elements are shown
      expect(elements.tosTitle, findsOneWidget);
      expect(elements.settingsLanguage, findsOneWidget);
      expect(elements.settingsDarkTheme, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify app Version on settings page",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and navigates to Settings page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();

      final gesture = await tester
          .startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -300)); //How much to scroll by
      await tester.pumpAndSettle();

      //Then verify router version is shown
      expect(elements.settingsModelVersion, findsOneWidget);

      //Then verify app version is shown
      expect(elements.settingsVersionMsg, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify Router elements on settings page",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and navigates to Settings page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();

      //Then verify router title is shown
      expect(elements.settingsRouterTitle, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify FW elements on settings page",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and navigates to Settings page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();

      //Then verify FW related elements are shown
      expect(elements.settingsFWTitle, findsOneWidget);
      expect(elements.settingsFWVersion, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify MAC elements on settings page",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and navigates to Settings page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();

      //Then verify FW related elements are shown
      expect(elements.settingsMACTitle, findsOneWidget);
      expect(elements.settingsMACVersion, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify Model elements on settings page",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and navigates to Settings page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();

      //Then verify model related elements are shown
      expect(elements.settingsModelTitle, findsOneWidget);
      expect(elements.settingsModelVersion, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify router status on settings page",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and navigates to Settings page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();

      //Then verify router status element is shown
      expect(elements.settingsOnlineStatus, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify logout elements", (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and navigates to Settings page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();
      await tester.tap(elements.settingsLogOutUser);
      await tester.pumpAndSettle();

      //Then verify Logout elements are shown
      expect(elements.logoutDialog, findsOneWidget);
      expect(elements.logoutTitle, findsOneWidget);
      expect(elements.cancelLogoutBtn, findsOneWidget);
      expect(elements.confirmLogout, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify logout cancellation flow", (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and navigates to Settings page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();
      await tester.tap(elements.settingsLogOutUser);
      await tester.pumpAndSettle();
      await tester.tap(elements.cancelLogoutBtn);
      await tester.pumpAndSettle();

      //Then verify Logout prompt is not shown
      expect(elements.settingsTitle, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify logout confirmation flow", (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and navigates to Settings page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();
      await tester.tap(elements.settingsLogOutUser);
      await tester.pumpAndSettle();
      await tester.tap(elements.confirmLogout);
      await tester.pumpAndSettle();

      //Then verify user is on login page
      expect(elements.signOnBtn, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify dark theme disabled", (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and navigates to Settings page
      await tester.login();
      await tester.navigateToSettingsPage();
      await tester.tap(elements.settingsDarkTheme);
      await tester.pumpAndSettle();
      await tester.tap(elements.settingsDarkTheme);
      await tester.pumpAndSettle();

      //Then verify dark theme is disabled
      expect(ThemeData.light(), ThemeData.light());
    }, skip: !elements.isMock());

    testWidgets("Verify dark theme enabled", (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and navigates to Settings page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();
      await tester.tap(elements.settingsDarkTheme);
      await tester.pumpAndSettle();

      //Then verify dark theme is enabled element is shown
      expect(ThemeData.dark(), ThemeData.dark());
    }, skip: !elements.isMock());

    testWidgets("Find Language Selector DropDownMenu",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and navigates to Settings page
      await tester.login();
      await tester.pumpAndSettle();
      await tester.navigateToSettingsPage();

      await tester.tap(elements.settingsLanguage);
      await tester.pumpAndSettle();

      //Then verify language selector options are shown
      expect(elements.closeLangSelector, findsOneWidget);
      expect(elements.dropDownItem, findsWidgets);
    }, skip: !elements.isMock());

    testWidgets("Verify langauge set to en", (WidgetTester tester) async {
      final testLocale = Locale('en');
      final origLocale = elements.startLocale;

      //Given panel is synced w/ account and connected to Wi-Fi
      //When user logs in, enters Home page, navigates to the Settings Page, and selects drop down menu
      //and English Language is selected
      await tester.login();
      await tester.navigateToSettingsPage();
      await _setLocale(testLocale, origLocale, tester);

      //Then verify title is show in English
      expect(find.text('Settings'), findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify langauge set to es", (WidgetTester tester) async {
      final testLocale = Locale('es');
      final origLocale = elements.startLocale;

      //Given panel is synced w/ account and connected to Wi-Fi
      //When user logs in, enters Home page, navigates to the Settings Page, and selects drop down menu
      // and Spanish Language is selected
      await tester.login();
      await tester.navigateToSettingsPage();
      await _setLocale(testLocale, origLocale, tester);

      //Then user view title in Spanish
      expect(find.text('Ajustes'), findsOneWidget);
    }, skip: !elements.isMock());
  });
}

Future _setLocale(
    Locale newLocale, Locale oldLocale, WidgetTester tester) async {
  if (newLocale == oldLocale) {
    return;
  }

  await tester.tap(elements.settingsLanguage);
  await tester.pumpAndSettle();
  await tester.tap(find
      .text(newLocale.toString())
      .last); //spanish language selection and verification check
  await tester.pumpAndSettle();
  await tester.tap(elements.dropDownItem.last);
  await tester.pumpAndSettle();
  await tester.tap(elements.closeLangSelector);
  await tester.pumpAndSettle();
}

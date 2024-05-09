import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'shared/elements.dart' as elements;
import 'shared/uihelper.dart';

main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await homeTest();
}

Future<void> homeTest() async {
  group('Home page Testing', () {
    testWidgets("Verify Home Page settings icon", (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and enters Home page
      await tester.login();
      await tester.pumpAndSettle();

      //Then verify settings icon is shown
      expect(elements.settingsIcon, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify Home Page status elements",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and enters Home page
      await tester.login();
      await tester.pumpAndSettle();

      //Then verify status elements are shown
      expect(elements.statusLbl, findsOneWidget);
      expect(elements.statusValue, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify Home Page router alias", (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and enters Home page
      await tester.login();
      await tester.pumpAndSettle();

      //Then verify router alias is shown
      expect(elements.routerAlias, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify Home Page device elements",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and enters Home page
      await tester.login();
      await tester.pumpAndSettle();

      //Then verify devices elements are shown
      expect(elements.devicesBtn, findsOneWidget);
      expect(elements.devicesValue, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify Home Page network elements",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and enters Home page
      await tester.login();
      await tester.pumpAndSettle();

      //Then verify Network Map button is shown
      expect(elements.networkMapBtn, findsOneWidget);
      expect(elements.wifiPoints, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify Home Page profile elements",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and enters Home page
      await tester.login();
      await tester.pumpAndSettle();

      //Then verify Network Map button is shown
      expect(elements.profilesBtn, findsOneWidget);
      expect(elements.profilesValue, findsOneWidget);
    }, skip: !elements.isMock());

    testWidgets("Verify Home Page speed test elements",
        (WidgetTester tester) async {
      //Given router is synced w/ account and connected to Wi-Fi
      //When user logs in and enters Home page
      await tester.login();
      await tester.pumpAndSettle();

      //Then verify speed test button is shown
      expect(elements.speedTestBtn, findsOneWidget);
    }, skip: !elements.isMock());
  });
}

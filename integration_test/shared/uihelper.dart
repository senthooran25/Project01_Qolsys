import 'package:flutter_test/flutter_test.dart';
import 'package:iq_wifi/mock/mock_account_model.dart';
import 'package:iq_wifi/repos/mock/mock_fenway_client.dart';
import 'package:iq_wifi/repos/mock/mock_fenway_repo_data.dart';
import 'elements.dart' as elements;

extension UiHelper on WidgetTester {
  Future<void> pumpWidgetWithOptionalMock(
      {MockFenwayRepoData? mockData, MockAccountModel? mockAccountModel}) {
    if (!elements.isMock()) {
      return pumpWidget(elements.getRootWidget());
    }
    MockFenwayRepository iQCloudClientMock =
        MockFenwayRepository(mockData: mockData ?? MockFenwayRepoData());
    MockAccountModel _mockAccountModel = mockAccountModel ?? MockAccountModel();
    return pumpWidget(elements.getRootWidget(
        clientMock: iQCloudClientMock, mockAccountModel: _mockAccountModel));
  }

  Future<void> login({MockFenwayRepoData? mockData}) async {
    await pumpWidgetWithOptionalMock(mockData: mockData);
    await pumpAndSettle();
  }

  Future<bool> isPresent(el, Matcher findsWidgets) async {
    try {
      expect(el, findsWidgets);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> navigateToDevicesPage() async {
    await tap(elements.devicesBtn);
    await pumpAndSettle();
  }

  Future<void> navigateToProfilesPage() async {
    await tap(elements.profilesBtn);
    await pumpAndSettle();
  }

  Future<void> navigateToNetworkMapPage() async {
    await tap(elements.networkMapBtn);
    await pumpAndSettle();
  }

  Future<void> navigateToSpeedTestPage() async {
    await tap(elements.speedTestBtn);
    await pumpAndSettle();
  }

  Future<void> navigateToSettingsPage() async {
    await tap(elements.settingsIcon);
    await pumpAndSettle();
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/providers/account_model.dart';
import 'package:qolsys_app/providers/events_model.dart';
import 'package:qolsys_app/repos/iqcloud_client.dart';
import 'package:qolsys_app/repos/iqcloud_repository.dart';

class MockDio extends Mock implements Dio {}

class MockAccountModel extends Mock implements AccountModel {
  @override
  String get accessToken => 'dummytoken';

  @override
  String get userName => 'test username';

  @override
  String get accountNumber => '1234';

  @override
  bool isLoggedIn() => true;
}

final mockHistoryEventsList = [
  {
    "device_id": 0,
    "partition_id": 0,
    "device_type": "panel",
    "event_type": "disarm_by_user",
    "event_class": "panel_arming",
    "event_info": {
      "event_desc": "Panel disarmed by user (Admin userId(1))",
      "is_event_desc_available": true,
      "data": {
        "user_type": "Admin",
        "arming_status": "disarm",
        "user_id": 1,
        "user_name": "Admin",
        "device_frame_type": "panel"
      },
      "event_message": "9990009620029861181401000019"
    },
    "event_time": 1608283880025
  }
];

main() {
  group('history events tests', () {
    Dio client;
    EventsModel eventsModel;
    AccountModel accountModel;

    setUp(() async {
      client = MockDio();
      accountModel = MockAccountModel();
      eventsModel = EventsModel(IQCloudRepository(
          client: IQCloudClient(client), account: accountModel));

      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response<List<dynamic>>(data: []));
    });

    tearDown(() {
      client = null;
      eventsModel = null;
      accountModel = null;
    });

    test('test arming when one event', () async {
      when(client.request(
        '/panels/${accountModel.accountNumber}/events/$armingFilter',
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async {
        return Response<List<dynamic>>(data: mockHistoryEventsList);
      });

      expect(eventsModel.historyEvents.length, 0);

      await eventsModel.fetchHistoryEvents();

      expect(eventsModel.historyEvents.length, 1);

      final firstHistoryEvent = eventsModel.historyEvents[0];
      final mockHistoryEvent = mockHistoryEventsList[0];
      expect(firstHistoryEvent.deviceId, mockHistoryEvent['device_id']);
      expect(firstHistoryEvent.partitionId, mockHistoryEvent['partition_id']);
      expect(firstHistoryEvent.deviceType, mockHistoryEvent['device_type']);
      expect(firstHistoryEvent.eventType, mockHistoryEvent['event_type']);
      expect(firstHistoryEvent.eventClass, mockHistoryEvent['event_class']);
      expect(firstHistoryEvent.eventInfo.length, 4);
      expect(firstHistoryEvent.eventTime, mockHistoryEvent['event_time']);
    });

    test('test alarms when zero events', () async {
      when(client.request(
        '/panels/${accountModel.accountNumber}/events/$alarmsFilter',
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async {
        return Response<List<dynamic>>(data: []);
      });

      expect(eventsModel.historyEvents.length, 0);

      await eventsModel.fetchHistoryEvents();

      expect(eventsModel.historyEvents.length, 0);
    });

    test('test multiple filters when zero events', () async {
      for (String filter in [sensorsFilter, alarmsFilter, homeAutomationFilter])
        when(client.request(
          '/panels/${accountModel.accountNumber}/events/$filter',
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          data: anyNamed('data'),
        )).thenAnswer((_) async => Response<List<dynamic>>(data: []));

      expect(eventsModel.historyEvents.length, 0);

      await eventsModel.fetchHistoryEvents();

      expect(eventsModel.historyEvents.length, 0);
    });
  });
}

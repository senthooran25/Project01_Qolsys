import 'dart:collection';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/models/history_event.dart';
import 'package:qolsys_app/providers/q_change_notifier.dart';
import 'package:qolsys_app/repos/iqcloud_repository.dart';
import 'package:qolsys_app/utils/qolsys_logger.dart';

class EventsModel extends QChangeNotifier {
  final _log = getLogger('EventsModel');
  IQCloudRepository repo;
  EventsModel(this.repo) : super(repo);

  List<HistoryEvent> _historyEvents = [];
  List<HistoryEvent> get historyEvents => UnmodifiableListView(_historyEvents
      .where((e) => historyEventsRequiredEventClasses.contains(e.eventClass)));

  Future fetchHistoryEvents() async {
    _log.i('fetchHistoryEvents()');
    Function requestFunc = () async {
      var historyEvents = List<HistoryEvent>();
      final fetchResults = List<Future>();
      for (String f in historyEventFilters)
        fetchResults.add(repo.getHistoryEvents(filter: f));
      for (var fut in fetchResults) historyEvents += await fut;

      historyEvents.sort((a, b) => b.eventTime.compareTo(a.eventTime));
      _historyEvents = historyEvents;
    };
    return sendRequest(requestFunc);
  }

  Future subscribeToPushNotifications(
      String deviceId, String fcmToken, List<String> topics) async {
    _log.i('subscribeToPushNotifications() | $topics');
    Function requestFunc = () async {
      repo.subscribeToPushNotifications(deviceId, fcmToken, topics);
    };
    return sendRequest(requestFunc);
  }

  Future updateSubscriptionTopics(
      String deviceId, String fcmToken, List<String> topics) async {
    _log.i('updateSubscriptionTopics() | $topics');
    Function requestFunc = () async {
      await repo.updateSubscriptionTopics(deviceId, fcmToken, topics);
    };
    return sendRequest(requestFunc);
  }

  Future unsubscribeToPushNotifications(String deviceId) async {
    _log.i('unsubscribeToPushNotifications()');
    Function requestFunc = () async {
      await repo.unsubscribeToPushNotifications(deviceId);
    };
    return sendRequest(requestFunc);
  }
}

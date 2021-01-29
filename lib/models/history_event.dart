import 'package:json_annotation/json_annotation.dart';

part 'history_event.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HistoryEvent {
  int deviceId;
  int partitionId;
  String deviceType;
  String eventType;
  String eventClass;
  Map<String, dynamic> eventInfo;
  int eventTime;

  HistoryEvent({
    this.partitionId,
    this.eventType,
    this.eventInfo,
    this.eventTime,
  });

  factory HistoryEvent.fromJson(Map<String, dynamic> json) =>
      _$HistoryEventFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryEventToJson(this);

  String get eventDescription => eventInfo['event_desc'];
}

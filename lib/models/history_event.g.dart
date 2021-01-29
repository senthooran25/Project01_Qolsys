// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryEvent _$HistoryEventFromJson(Map<String, dynamic> json) {
  return HistoryEvent(
    partitionId: json['partition_id'] as int,
    eventType: json['event_type'] as String,
    eventInfo: json['event_info'] as Map<String, dynamic>,
    eventTime: json['event_time'] as int,
  )
    ..deviceId = json['device_id'] as int
    ..deviceType = json['device_type'] as String
    ..eventClass = json['event_class'] as String;
}

Map<String, dynamic> _$HistoryEventToJson(HistoryEvent instance) =>
    <String, dynamic>{
      'device_id': instance.deviceId,
      'partition_id': instance.partitionId,
      'device_type': instance.deviceType,
      'event_type': instance.eventType,
      'event_class': instance.eventClass,
      'event_info': instance.eventInfo,
      'event_time': instance.eventTime,
    };

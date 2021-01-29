// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alarm _$AlarmFromJson(Map<String, dynamic> json) {
  return Alarm(
    accountNumber: json['account_number'] as String,
    deviceId: json['device_id'] as int,
    partitionId: json['partition_id'] as int,
    siaDetails: json['sia_details'] as Map<String, dynamic>,
    eventType: json['event_type'] as String,
    eventTime: json['event_time'] as int,
  );
}

Map<String, dynamic> _$AlarmToJson(Alarm instance) => <String, dynamic>{
      'account_number': instance.accountNumber,
      'device_id': instance.deviceId,
      'partition_id': instance.partitionId,
      'sia_details': instance.siaDetails,
      'event_type': instance.eventType,
      'event_time': instance.eventTime,
    };

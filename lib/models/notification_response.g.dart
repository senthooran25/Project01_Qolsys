// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationResponse _$NotificationResponseFromJson(Map<String, dynamic> json) {
  return NotificationResponse(
    status: json['status'] as bool,
    triggers: (json['triggers'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$NotificationResponseToJson(
        NotificationResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'triggers': instance.triggers,
    };

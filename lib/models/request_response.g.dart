// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestResponse _$RequestResponseFromJson(Map<String, dynamic> json) {
  return RequestResponse(
    requestStatus: json['request_status'] as bool,
    updatedTime: json['updated_time'] as int,
  );
}

Map<String, dynamic> _$RequestResponseToJson(RequestResponse instance) =>
    <String, dynamic>{
      'request_status': instance.requestStatus,
      'updated_time': instance.updatedTime,
    };

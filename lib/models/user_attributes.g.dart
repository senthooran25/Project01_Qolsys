// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_attributes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAttributes _$UserAttributesFromJson(Map<String, dynamic> json) {
  return UserAttributes(
    preferredLanguage: json['preferred_language'] as String,
    dateFormat: json['date_format'] as String,
    timezone: json['timezone'] as int,
    recordsPerPage: json['records_per_page'] as int,
  );
}

Map<String, dynamic> _$UserAttributesToJson(UserAttributes instance) =>
    <String, dynamic>{
      'preferred_language': instance.preferredLanguage,
      'date_format': instance.dateFormat,
      'timezone': instance.timezone,
      'records_per_page': instance.recordsPerPage,
    };

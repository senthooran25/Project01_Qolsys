// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel_properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanelProperties _$PanelPropertiesFromJson(Map<String, dynamic> json) {
  return PanelProperties(
    softwareVersion: json['software_version'] as String,
    carrierName: json['carrier_name'] as String,
    daughterCards:
        (json['daughter_cards'] as List)?.map((e) => e as String)?.toList(),
    connectionStatus: json['connection_status'] as String,
    wifiStatus: json['wifi_status'] as String,
    bluetoothStatus: json['bluetooth_status'] as String,
    powerStatus: json['power_status'] as String,
    partitionStatus: json['partition_status'] as String,
    partitions: json['partitions'] as String,
    state: json['state'] as String,
    timeZone: json['time_zone'] as String,
    zipCode: json['zip_code'] as String,
    country: json['country'] as String,
    city: json['city'] as String,
    registrationDate: json['registration_date'] as int,
  );
}

Map<String, dynamic> _$PanelPropertiesToJson(PanelProperties instance) =>
    <String, dynamic>{
      'software_version': instance.softwareVersion,
      'carrier_name': instance.carrierName,
      'daughter_cards': instance.daughterCards,
      'connection_status': instance.connectionStatus,
      'wifi_status': instance.wifiStatus,
      'bluetooth_status': instance.bluetoothStatus,
      'power_status': instance.powerStatus,
      'partition_status': instance.partitionStatus,
      'partitions': instance.partitions,
      'state': instance.state,
      'time_zone': instance.timeZone,
      'zip_code': instance.zipCode,
      'country': instance.country,
      'city': instance.city,
      'registration_date': instance.registrationDate,
    };

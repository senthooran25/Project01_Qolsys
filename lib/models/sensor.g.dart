// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sensor _$SensorFromJson(Map<String, dynamic> json) {
  return Sensor(
    protocolType: json['protocol_type'] as String,
    zoneId: json['zone_id'] as int,
    sensorId: json['sensor_id'] as String,
    partitionId: json['partition_id'] as int,
    sensorName: json['sensor_name'] as String,
    sensorType: json['sensor_type'] as String,
    sensorGroup: json['sensor_group'] as String,
    sensorState: json['sensor_state'] as String,
    sensorStatus: json['sensor_status'] as String,
    sensorTts: json['sensor_tts'] as String,
    chimeType: json['chime_type'] as String,
    batteryStatus: json['battery_status'] as String,
    installationDate: json['installation_date'] as int,
  );
}

Map<String, dynamic> _$SensorToJson(Sensor instance) => <String, dynamic>{
      'protocol_type': instance.protocolType,
      'zone_id': instance.zoneId,
      'sensor_id': instance.sensorId,
      'partition_id': instance.partitionId,
      'sensor_name': instance.sensorName,
      'sensor_type': instance.sensorType,
      'sensor_group': instance.sensorGroup,
      'sensor_state': instance.sensorState,
      'sensor_status': instance.sensorStatus,
      'sensor_tts': instance.sensorTts,
      'chime_type': instance.chimeType,
      'battery_status': instance.batteryStatus,
      'installation_date': instance.installationDate,
    };

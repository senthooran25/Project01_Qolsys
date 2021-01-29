import 'package:json_annotation/json_annotation.dart';

part 'sensor.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Sensor {
  String protocolType;
  int zoneId;
  String sensorId;
  int partitionId;
  String sensorName;
  String sensorType;
  String sensorGroup;
  String sensorState;
  String sensorStatus;
  String sensorTts;
  String chimeType;
  String batteryStatus;
  int installationDate;

  @JsonKey(ignore: true)
  bool loading = false;

  Sensor({
    this.protocolType,
    this.zoneId,
    this.sensorId,
    this.partitionId,
    this.sensorName,
    this.sensorType,
    this.sensorGroup,
    this.sensorState,
    this.sensorStatus,
    this.sensorTts,
    this.chimeType,
    this.batteryStatus,
    this.installationDate,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) => _$SensorFromJson(json);
  Map<String, dynamic> toJson() => _$SensorToJson(this);
}

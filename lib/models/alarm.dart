import 'package:json_annotation/json_annotation.dart';

part 'alarm.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Alarm {
  String accountNumber;
  int deviceId;
  int partitionId;
  Map<String, dynamic> siaDetails;
  String eventType;
  int eventTime;

  Alarm({
    this.accountNumber,
    this.deviceId,
    this.partitionId,
    this.siaDetails,
    this.eventType,
    this.eventTime,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) => _$AlarmFromJson(json);
  Map<String, dynamic> toJson() => _$AlarmToJson(this);
}

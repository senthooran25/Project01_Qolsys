import 'package:json_annotation/json_annotation.dart';

part 'partition_status.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PartitionStatus {
  int partitionId;
  String armingStatus;
  int userId;
  int updatedTime;

  @JsonKey(ignore: true)
  bool loading = false;

  PartitionStatus({
    this.partitionId,
    this.armingStatus,
    this.userId,
    this.updatedTime,
  });

  factory PartitionStatus.fromJson(Map<String, dynamic> json) =>
      _$PartitionStatusFromJson(json);
  Map<String, dynamic> toJson() => _$PartitionStatusToJson(this);
}

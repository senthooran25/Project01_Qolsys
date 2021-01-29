// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partition_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartitionStatus _$PartitionStatusFromJson(Map<String, dynamic> json) {
  return PartitionStatus(
    partitionId: json['partition_id'] as int,
    armingStatus: json['arming_status'] as String,
    userId: json['user_id'] as int,
    updatedTime: json['updated_time'] as int,
  );
}

Map<String, dynamic> _$PartitionStatusToJson(PartitionStatus instance) =>
    <String, dynamic>{
      'partition_id': instance.partitionId,
      'arming_status': instance.armingStatus,
      'user_id': instance.userId,
      'updated_time': instance.updatedTime,
    };

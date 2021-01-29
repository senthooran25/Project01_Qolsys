import 'package:json_annotation/json_annotation.dart';

part 'notification_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationResponse {
  bool status;
  List<String> triggers;

  NotificationResponse({this.status, this.triggers});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'request_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RequestResponse {
  bool requestStatus;
  int updatedTime;

  RequestResponse({this.requestStatus, this.updatedTime});

  factory RequestResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RequestResponseToJson(this);
}

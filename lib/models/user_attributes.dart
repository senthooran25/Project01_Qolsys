import 'package:json_annotation/json_annotation.dart';

part 'user_attributes.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserAttributes {
  String preferredLanguage;
  String dateFormat;
  int timezone;
  int recordsPerPage;

  UserAttributes({
    this.preferredLanguage,
    this.dateFormat,
    this.timezone,
    this.recordsPerPage,
  });

  factory UserAttributes.fromJson(Map<String, dynamic> json) =>
      _$UserAttributesFromJson(json);

  Map<String, dynamic> toJson() => _$UserAttributesToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'user_attributes.dart';

part 'user_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserInfo {
  String username;
  String firstName;
  String lastName;
  String email;
  String dealer;
  String accountNumber;
  int lastLoggedDate;
  List<String> roles;
  List<String> groups;
  int panelUserId;
  UserAttributes attributes;

  UserInfo({
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.dealer,
    this.accountNumber,
    this.lastLoggedDate,
    this.roles,
    this.groups,
    this.panelUserId,
    this.attributes,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

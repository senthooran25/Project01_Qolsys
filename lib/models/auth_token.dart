import 'package:json_annotation/json_annotation.dart';

part 'auth_token.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AuthToken {
  String accessToken;
  String refreshToken;
  int expiresIn;
  int refreshExpiresIn;
  String tokenType;

  AuthToken({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.refreshExpiresIn,
    this.tokenType,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);
  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);
}

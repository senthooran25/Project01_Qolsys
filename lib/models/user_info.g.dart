// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
    username: json['username'] as String,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    email: json['email'] as String,
    dealer: json['dealer'] as String,
    accountNumber: json['account_number'] as String,
    lastLoggedDate: json['last_logged_date'] as int,
    roles: (json['roles'] as List)?.map((e) => e as String)?.toList(),
    groups: (json['groups'] as List)?.map((e) => e as String)?.toList(),
    panelUserId: json['panel_user_id'] as int,
    attributes: json['attributes'] == null
        ? null
        : UserAttributes.fromJson(json['attributes'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'dealer': instance.dealer,
      'account_number': instance.accountNumber,
      'last_logged_date': instance.lastLoggedDate,
      'roles': instance.roles,
      'groups': instance.groups,
      'panel_user_id': instance.panelUserId,
      'attributes': instance.attributes,
    };

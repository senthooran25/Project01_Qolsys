// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountDetails _$AccountDetailsFromJson(Map<String, dynamic> json) {
  return AccountDetails(
    accountNumber: json['account_number'] as String,
    imei: json['imei'] as String,
    serialNumber: json['serial_number'] as String,
    iccid: json['iccid'] as String,
    accountStatus: json['account_status'] as String,
    connectionStatus: json['connection_status'] as String,
    signalStrength: json['signal_strength'] as int,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    address: json['address'] as String,
    suburb: json['suburb'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
    country: json['country'] as String,
    zipCode: json['zip_code'] as String,
    timeZone: json['time_zone'] as String,
    primaryContact: json['primary_contact'] as String,
    createdDate: json['created_date'] as int,
    registrationDate: json['registration_date'] as int,
  );
}

Map<String, dynamic> _$AccountDetailsToJson(AccountDetails instance) =>
    <String, dynamic>{
      'account_number': instance.accountNumber,
      'imei': instance.imei,
      'serial_number': instance.serialNumber,
      'iccid': instance.iccid,
      'account_status': instance.accountStatus,
      'connection_status': instance.connectionStatus,
      'signal_strength': instance.signalStrength,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'address': instance.address,
      'suburb': instance.suburb,
      'state': instance.state,
      'city': instance.city,
      'country': instance.country,
      'zip_code': instance.zipCode,
      'time_zone': instance.timeZone,
      'primary_contact': instance.primaryContact,
      'created_date': instance.createdDate,
      'registration_date': instance.registrationDate,
    };

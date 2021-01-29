import 'package:json_annotation/json_annotation.dart';

part 'account_details.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountDetails {
  String accountNumber;
  String imei;
  String serialNumber;
  String iccid;
  String accountStatus;
  String connectionStatus;
  int signalStrength;
  String firstName;
  String lastName;
  String address;
  String suburb;
  String state;
  String city;
  String country;
  String zipCode;
  String timeZone;
  String primaryContact;
  int createdDate;
  int registrationDate;

  AccountDetails({
    this.accountNumber,
    this.imei,
    this.serialNumber,
    this.iccid,
    this.accountStatus,
    this.connectionStatus,
    this.signalStrength,
    this.firstName,
    this.lastName,
    this.address,
    this.suburb,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.timeZone,
    this.primaryContact,
    this.createdDate,
    this.registrationDate,
  });

  factory AccountDetails.fromJson(Map<String, dynamic> json) =>
      _$AccountDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$AccountDetailsToJson(this);
}

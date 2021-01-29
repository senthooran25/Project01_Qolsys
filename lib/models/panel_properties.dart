import 'package:json_annotation/json_annotation.dart';

part 'panel_properties.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PanelProperties {
  String softwareVersion;
  String carrierName;
  List<String> daughterCards;
  String connectionStatus;
  String wifiStatus;
  String bluetoothStatus;
  String powerStatus;
  String partitionStatus;
  String partitions;
  String state;
  String timeZone;
  String zipCode;
  String country;
  String city;
  int registrationDate;

  PanelProperties({
    this.softwareVersion,
    this.carrierName,
    this.daughterCards,
    this.connectionStatus,
    this.wifiStatus,
    this.bluetoothStatus,
    this.powerStatus,
    this.partitionStatus,
    this.partitions,
    this.state,
    this.timeZone,
    this.zipCode,
    this.country,
    this.city,
    this.registrationDate,
  });

  factory PanelProperties.fromJson(Map<String, dynamic> json) =>
      _$PanelPropertiesFromJson(json);
  Map<String, dynamic> toJson() => _$PanelPropertiesToJson(this);
}

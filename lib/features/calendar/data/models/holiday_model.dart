import 'package:cldr/features/calendar/domain/entities/holiday.dart';

class HolidayModel {
  final String date;
  final String localName;
  final String name;
  final String countryCode;
  final bool fixed;
  final bool global;

  const HolidayModel({
    required this.date,
    required this.localName,
    required this.name,
    required this.countryCode,
    required this.fixed,
    required this.global,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      date: json['date'] as String,
      localName: json['localName'] as String,
      name: json['name'] as String,
      countryCode: json['countryCode'] as String,
      fixed: json['fixed'] as bool? ?? false,
      global: json['global'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'localName': localName,
      'name': name,
      'countryCode': countryCode,
      'fixed': fixed,
      'global': global,
    };
  }

  Holiday toEntity() {
    return Holiday(
      date: date,
      localName: localName,
      name: name,
      countryCode: countryCode,
      fixed: fixed,
      global: global,
    );
  }
}

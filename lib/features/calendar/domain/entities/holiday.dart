import 'package:equatable/equatable.dart';

class Holiday extends Equatable {
  final String date;
  final String localName;
  final String name;
  final String countryCode;
  final bool fixed;
  final bool global;

  const Holiday({
    required this.date,
    required this.localName,
    required this.name,
    required this.countryCode,
    required this.fixed,
    required this.global,
  });

  @override
  List<Object?> get props => [
    date,
    localName,
    name,
    countryCode,
    fixed,
    global,
  ];
}

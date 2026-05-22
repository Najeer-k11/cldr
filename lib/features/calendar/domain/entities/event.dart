import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final DateTime? time;
  final int colorIndex;
  final String? notes;

  const Event({
    required this.id,
    required this.title,
    required this.date,
    this.time,
    this.colorIndex = 0,
    this.notes,
  });

  @override
  List<Object?> get props => [id, title, date, time, colorIndex, notes];
}

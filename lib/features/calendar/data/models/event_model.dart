import 'package:hive/hive.dart';
import 'package:cldr/features/calendar/domain/entities/event.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String? time;

  @HiveField(4)
  final int colorIndex;

  @HiveField(5)
  final String? notes;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    this.time,
    this.colorIndex = 0,
    this.notes,
  });

  factory EventModel.fromEntity(Event event) {
    return EventModel(
      id: event.id,
      title: event.title,
      date:
          '${event.date.year.toString().padLeft(4, '0')}-${event.date.month.toString().padLeft(2, '0')}-${event.date.day.toString().padLeft(2, '0')}',
      time: event.time != null
          ? '${event.time!.hour.toString().padLeft(2, '0')}:${event.time!.minute.toString().padLeft(2, '0')}'
          : null,
      colorIndex: event.colorIndex,
      notes: event.notes,
    );
  }

  Event toEntity() {
    final dateParts = date.split('-');
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);

    DateTime? parsedTime;
    if (time != null) {
      final timeParts = time!.split(':');
      parsedTime = DateTime(
        year,
        month,
        day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    }

    return Event(
      id: id,
      title: title,
      date: DateTime(year, month, day),
      time: parsedTime,
      colorIndex: colorIndex,
      notes: notes,
    );
  }
}

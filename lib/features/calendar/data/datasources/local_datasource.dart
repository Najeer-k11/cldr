import 'package:hive/hive.dart';
import 'package:cldr/core/error/exceptions.dart';
import 'package:cldr/features/calendar/data/models/event_model.dart';

abstract class CalendarLocalDataSource {
  Future<List<EventModel>> getEvents(String dateKey);
  Future<Map<String, List<EventModel>>> getEventsForMonth(int year, int month);
  Future<void> addEvent(EventModel event);
  Future<void> deleteEvent(String eventId);
}

class CalendarLocalDataSourceImpl implements CalendarLocalDataSource {
  final Box<EventModel> eventBox;

  CalendarLocalDataSourceImpl({required this.eventBox});

  @override
  Future<List<EventModel>> getEvents(String dateKey) async {
    try {
      final events = eventBox.values.where((e) => e.date == dateKey).toList();
      events.sort((a, b) {
        if (a.time == null && b.time == null) return 0;
        if (a.time == null) return 1;
        if (b.time == null) return -1;
        return a.time!.compareTo(b.time!);
      });
      return events;
    } catch (e) {
      throw CacheException('Failed to get events: $e');
    }
  }

  @override
  Future<Map<String, List<EventModel>>> getEventsForMonth(
    int year,
    int month,
  ) async {
    try {
      final prefix =
          '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';
      final events = eventBox.values
          .where((e) => e.date.startsWith(prefix))
          .toList();

      final Map<String, List<EventModel>> grouped = {};
      for (final event in events) {
        grouped.putIfAbsent(event.date, () => []).add(event);
      }

      for (final list in grouped.values) {
        list.sort((a, b) {
          if (a.time == null && b.time == null) return 0;
          if (a.time == null) return 1;
          if (b.time == null) return -1;
          return a.time!.compareTo(b.time!);
        });
      }

      return grouped;
    } catch (e) {
      throw CacheException('Failed to get events for month: $e');
    }
  }

  @override
  Future<void> addEvent(EventModel event) async {
    try {
      await eventBox.put(event.id, event);
    } catch (e) {
      throw CacheException('Failed to add event: $e');
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      await eventBox.delete(eventId);
    } catch (e) {
      throw CacheException('Failed to delete event: $e');
    }
  }
}

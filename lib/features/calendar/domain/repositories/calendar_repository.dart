import 'package:dartz/dartz.dart';
import 'package:cldr/core/error/failures.dart';
import 'package:cldr/features/calendar/domain/entities/event.dart';
import 'package:cldr/features/calendar/domain/entities/holiday.dart';

abstract class CalendarRepository {
  Future<Either<Failure, List<Holiday>>> getHolidays(
    String countryCode,
    int year,
  );
  Future<Either<Failure, List<Event>>> getEvents(DateTime date);
  Future<Either<Failure, Map<DateTime, List<Event>>>> getEventsForMonth(
    DateTime month,
  );
  Future<Either<Failure, void>> addEvent(Event event);
  Future<Either<Failure, void>> deleteEvent(String eventId);
}

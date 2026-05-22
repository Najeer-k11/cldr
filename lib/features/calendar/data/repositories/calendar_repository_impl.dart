import 'package:dartz/dartz.dart';
import 'package:cldr/core/error/exceptions.dart';
import 'package:cldr/core/error/failures.dart';
import 'package:cldr/features/calendar/data/datasources/local_datasource.dart';
import 'package:cldr/features/calendar/data/datasources/remote_datasource.dart';
import 'package:cldr/features/calendar/data/models/event_model.dart';
import 'package:cldr/features/calendar/domain/entities/event.dart';
import 'package:cldr/features/calendar/domain/entities/holiday.dart';
import 'package:cldr/features/calendar/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarRemoteDataSource remoteDataSource;
  final CalendarLocalDataSource localDataSource;

  CalendarRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Holiday>>> getHolidays(
    String countryCode,
    int year,
  ) async {
    try {
      final models = await remoteDataSource.getHolidays(countryCode, year);
      final holidays = models.map((m) => m.toEntity()).toList();
      return Right(holidays);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getEvents(DateTime date) async {
    try {
      final dateKey =
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final models = await localDataSource.getEvents(dateKey);
      final events = models.map((m) => m.toEntity()).toList();
      return Right(events);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<DateTime, List<Event>>>> getEventsForMonth(
    DateTime month,
  ) async {
    try {
      final models = await localDataSource.getEventsForMonth(
        month.year,
        month.month,
      );
      final Map<DateTime, List<Event>> events = {};

      for (final entry in models.entries) {
        final dateParts = entry.key.split('-');
        final date = DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
        );
        events[date] = entry.value.map((m) => m.toEntity()).toList();
      }

      return Right(events);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addEvent(Event event) async {
    try {
      final model = EventModel.fromEntity(event);
      await localDataSource.addEvent(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    try {
      await localDataSource.deleteEvent(eventId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }
}

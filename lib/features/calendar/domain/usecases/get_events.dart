import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:cldr/core/error/failures.dart';
import 'package:cldr/core/usecases/usecase.dart';
import 'package:cldr/features/calendar/domain/entities/event.dart';
import 'package:cldr/features/calendar/domain/repositories/calendar_repository.dart';

class GetEvents extends UseCase<List<Event>, GetEventsParams> {
  final CalendarRepository repository;

  GetEvents(this.repository);

  @override
  Future<Either<Failure, List<Event>>> call(GetEventsParams params) {
    return repository.getEvents(params.date);
  }
}

class GetEventsParams extends Equatable {
  final DateTime date;

  const GetEventsParams({required this.date});

  @override
  List<Object?> get props => [date];
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:cldr/core/error/failures.dart';
import 'package:cldr/core/usecases/usecase.dart';
import 'package:cldr/features/calendar/domain/entities/event.dart';
import 'package:cldr/features/calendar/domain/repositories/calendar_repository.dart';

class GetEventsForMonth
    extends UseCase<Map<DateTime, List<Event>>, GetEventsForMonthParams> {
  final CalendarRepository repository;

  GetEventsForMonth(this.repository);

  @override
  Future<Either<Failure, Map<DateTime, List<Event>>>> call(
    GetEventsForMonthParams params,
  ) {
    return repository.getEventsForMonth(params.month);
  }
}

class GetEventsForMonthParams extends Equatable {
  final DateTime month;

  const GetEventsForMonthParams({required this.month});

  @override
  List<Object?> get props => [month];
}

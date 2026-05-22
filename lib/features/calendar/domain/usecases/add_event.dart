import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:cldr/core/error/failures.dart';
import 'package:cldr/core/usecases/usecase.dart';
import 'package:cldr/features/calendar/domain/entities/event.dart';
import 'package:cldr/features/calendar/domain/repositories/calendar_repository.dart';

class AddEvent extends UseCase<void, AddEventParams> {
  final CalendarRepository repository;

  AddEvent(this.repository);

  @override
  Future<Either<Failure, void>> call(AddEventParams params) {
    return repository.addEvent(params.event);
  }
}

class AddEventParams extends Equatable {
  final Event event;

  const AddEventParams({required this.event});

  @override
  List<Object?> get props => [event];
}

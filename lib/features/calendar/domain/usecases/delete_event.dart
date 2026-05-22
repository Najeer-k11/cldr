import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:cldr/core/error/failures.dart';
import 'package:cldr/core/usecases/usecase.dart';
import 'package:cldr/features/calendar/domain/repositories/calendar_repository.dart';

class DeleteEvent extends UseCase<void, DeleteEventParams> {
  final CalendarRepository repository;

  DeleteEvent(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteEventParams params) {
    return repository.deleteEvent(params.eventId);
  }
}

class DeleteEventParams extends Equatable {
  final String eventId;

  const DeleteEventParams({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

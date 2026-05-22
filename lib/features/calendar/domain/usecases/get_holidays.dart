import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:cldr/core/error/failures.dart';
import 'package:cldr/core/usecases/usecase.dart';
import 'package:cldr/features/calendar/domain/entities/holiday.dart';
import 'package:cldr/features/calendar/domain/repositories/calendar_repository.dart';

class GetHolidays extends UseCase<List<Holiday>, GetHolidaysParams> {
  final CalendarRepository repository;

  GetHolidays(this.repository);

  @override
  Future<Either<Failure, List<Holiday>>> call(GetHolidaysParams params) {
    return repository.getHolidays(params.countryCode, params.year);
  }
}

class GetHolidaysParams extends Equatable {
  final String countryCode;
  final int year;

  const GetHolidaysParams({required this.countryCode, required this.year});

  @override
  List<Object?> get props => [countryCode, year];
}

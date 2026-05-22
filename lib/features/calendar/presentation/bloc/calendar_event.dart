import 'package:equatable/equatable.dart';
import 'package:cldr/features/calendar/domain/entities/event.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class LoadCalendar extends CalendarEvent {
  final DateTime month;

  const LoadCalendar(this.month);

  @override
  List<Object?> get props => [month];
}

class AddEventRequested extends CalendarEvent {
  final Event event;

  const AddEventRequested(this.event);

  @override
  List<Object?> get props => [event];
}

class DeleteEventRequested extends CalendarEvent {
  final String eventId;

  const DeleteEventRequested(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class SelectDay extends CalendarEvent {
  final DateTime day;

  const SelectDay(this.day);

  @override
  List<Object?> get props => [day];
}

class ImportHolidays extends CalendarEvent {
  final String countryCode;
  final int year;

  const ImportHolidays({required this.countryCode, required this.year});

  @override
  List<Object?> get props => [countryCode, year];
}

import 'package:equatable/equatable.dart';
import 'package:cldr/features/calendar/domain/entities/event.dart';
import 'package:cldr/features/calendar/domain/entities/holiday.dart';

enum CalendarStatus { initial, loading, success, failure }

class CalendarState extends Equatable {
  final CalendarStatus status;
  final DateTime selectedDay;
  final DateTime focusedMonth;
  final Map<DateTime, List<Event>> events;
  final Map<DateTime, Holiday> holidays;
  final String? errorMessage;

  CalendarState({
    this.status = CalendarStatus.initial,
    DateTime? selectedDay,
    DateTime? focusedMonth,
    this.events = const {},
    this.holidays = const {},
    this.errorMessage,
  }) : selectedDay = selectedDay ?? DateTime.now(),
       focusedMonth =
           focusedMonth ?? DateTime(DateTime.now().year, DateTime.now().month);

  CalendarState copyWith({
    CalendarStatus? status,
    DateTime? selectedDay,
    DateTime? focusedMonth,
    Map<DateTime, List<Event>>? events,
    Map<DateTime, Holiday>? holidays,
    String? errorMessage,
  }) {
    return CalendarState(
      status: status ?? this.status,
      selectedDay: selectedDay ?? this.selectedDay,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      events: events ?? this.events,
      holidays: holidays ?? this.holidays,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedDay,
    focusedMonth,
    events,
    holidays,
    errorMessage,
  ];
}

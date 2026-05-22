import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cldr/features/calendar/domain/entities/holiday.dart';
import 'package:cldr/features/calendar/domain/usecases/add_event.dart';
import 'package:cldr/features/calendar/domain/usecases/delete_event.dart';
import 'package:cldr/features/calendar/domain/usecases/get_events.dart';
import 'package:cldr/features/calendar/domain/usecases/get_events_for_month.dart';
import 'package:cldr/features/calendar/domain/usecases/get_holidays.dart';
import 'package:cldr/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:cldr/features/calendar/presentation/bloc/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetHolidays getHolidays;
  final GetEvents getEvents;
  final GetEventsForMonth getEventsForMonth;
  final AddEvent addEvent;
  final DeleteEvent deleteEvent;

  CalendarBloc({
    required this.getHolidays,
    required this.getEvents,
    required this.getEventsForMonth,
    required this.addEvent,
    required this.deleteEvent,
  }) : super(CalendarState()) {
    on<LoadCalendar>(_onLoadCalendar);
    on<AddEventRequested>(_onAddEvent);
    on<DeleteEventRequested>(_onDeleteEvent);
    on<SelectDay>(_onSelectDay);
    on<ImportHolidays>(_onImportHolidays);
  }

  Future<void> _onLoadCalendar(
    LoadCalendar event,
    Emitter<CalendarState> emit,
  ) async {
    emit(
      state.copyWith(status: CalendarStatus.loading, focusedMonth: event.month),
    );

    final eventsResult = await getEventsForMonth(
      GetEventsForMonthParams(month: event.month),
    );

    eventsResult.fold(
      (failure) => emit(
        state.copyWith(
          status: CalendarStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (eventsMap) => emit(
        state.copyWith(status: CalendarStatus.success, events: eventsMap),
      ),
    );
  }

  Future<void> _onAddEvent(
    AddEventRequested event,
    Emitter<CalendarState> emit,
  ) async {
    final result = await addEvent(AddEventParams(event: event.event));

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: CalendarStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) async {
        // Reload events for the current month
        final eventsResult = await getEventsForMonth(
          GetEventsForMonthParams(month: state.focusedMonth),
        );
        eventsResult.fold(
          (failure) => emit(
            state.copyWith(
              status: CalendarStatus.failure,
              errorMessage: failure.message,
            ),
          ),
          (eventsMap) => emit(
            state.copyWith(status: CalendarStatus.success, events: eventsMap),
          ),
        );
      },
    );
  }

  Future<void> _onDeleteEvent(
    DeleteEventRequested event,
    Emitter<CalendarState> emit,
  ) async {
    final result = await deleteEvent(DeleteEventParams(eventId: event.eventId));

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: CalendarStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) async {
        // Reload events for the current month
        final eventsResult = await getEventsForMonth(
          GetEventsForMonthParams(month: state.focusedMonth),
        );
        eventsResult.fold(
          (failure) => emit(
            state.copyWith(
              status: CalendarStatus.failure,
              errorMessage: failure.message,
            ),
          ),
          (eventsMap) => emit(
            state.copyWith(status: CalendarStatus.success, events: eventsMap),
          ),
        );
      },
    );
  }

  void _onSelectDay(SelectDay event, Emitter<CalendarState> emit) {
    emit(state.copyWith(selectedDay: event.day));
  }

  Future<void> _onImportHolidays(
    ImportHolidays event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(status: CalendarStatus.loading));

    final result = await getHolidays(
      GetHolidaysParams(countryCode: event.countryCode, year: event.year),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CalendarStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (holidays) {
        final Map<DateTime, Holiday> holidayMap = {};
        for (final holiday in holidays) {
          final dateParts = holiday.date.split('-');
          final date = DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
          );
          holidayMap[date] = holiday;
        }
        emit(
          state.copyWith(
            status: CalendarStatus.success,
            holidays: {...state.holidays, ...holidayMap},
          ),
        );
      },
    );
  }
}

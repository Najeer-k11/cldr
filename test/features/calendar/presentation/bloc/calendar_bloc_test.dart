import 'package:bloc_test/bloc_test.dart';
import 'package:cldr/core/error/failures.dart';
import 'package:cldr/features/calendar/domain/entities/event.dart';
import 'package:cldr/features/calendar/domain/entities/holiday.dart';
import 'package:cldr/features/calendar/domain/usecases/add_event.dart';
import 'package:cldr/features/calendar/domain/usecases/delete_event.dart';
import 'package:cldr/features/calendar/domain/usecases/get_events.dart';
import 'package:cldr/features/calendar/domain/usecases/get_events_for_month.dart';
import 'package:cldr/features/calendar/domain/usecases/get_holidays.dart';
import 'package:cldr/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:cldr/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:cldr/features/calendar/presentation/bloc/calendar_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetHolidays extends Mock implements GetHolidays {}

class MockGetEvents extends Mock implements GetEvents {}

class MockGetEventsForMonth extends Mock implements GetEventsForMonth {}

class MockAddEvent extends Mock implements AddEvent {}

class MockDeleteEvent extends Mock implements DeleteEvent {}

void main() {
  late CalendarBloc bloc;
  late MockGetHolidays mockGetHolidays;
  late MockGetEvents mockGetEvents;
  late MockGetEventsForMonth mockGetEventsForMonth;
  late MockAddEvent mockAddEvent;
  late MockDeleteEvent mockDeleteEvent;

  setUp(() {
    mockGetHolidays = MockGetHolidays();
    mockGetEvents = MockGetEvents();
    mockGetEventsForMonth = MockGetEventsForMonth();
    mockAddEvent = MockAddEvent();
    mockDeleteEvent = MockDeleteEvent();

    bloc = CalendarBloc(
      getHolidays: mockGetHolidays,
      getEvents: mockGetEvents,
      getEventsForMonth: mockGetEventsForMonth,
      addEvent: mockAddEvent,
      deleteEvent: mockDeleteEvent,
    );
  });

  tearDown(() {
    bloc.close();
  });

  setUpAll(() {
    registerFallbackValue(
      const GetHolidaysParams(countryCode: 'US', year: 2024),
    );
    registerFallbackValue(GetEventsParams(date: DateTime(2024, 1, 1)));
    registerFallbackValue(GetEventsForMonthParams(month: DateTime(2024, 1)));
    registerFallbackValue(
      AddEventParams(
        event: Event(id: '1', title: 'Test', date: DateTime(2024, 1, 1)),
      ),
    );
    registerFallbackValue(const DeleteEventParams(eventId: '1'));
  });

  group('CalendarBloc', () {
    final testMonth = DateTime(2024, 6);
    final testDay = DateTime(2024, 6, 15);
    final testEvent = Event(
      id: 'test-id',
      title: 'Test Event',
      date: DateTime(2024, 6, 15),
      colorIndex: 0,
    );
    final testEventsMap = <DateTime, List<Event>>{
      DateTime(2024, 6, 15): [testEvent],
    };

    test('initial state is correct', () {
      expect(bloc.state.status, CalendarStatus.initial);
      expect(bloc.state.events, isEmpty);
      expect(bloc.state.holidays, isEmpty);
    });

    group('LoadCalendar', () {
      blocTest<CalendarBloc, CalendarState>(
        'emits [loading, success] when getEventsForMonth succeeds',
        build: () {
          when(
            () => mockGetEventsForMonth(any()),
          ).thenAnswer((_) async => Right(testEventsMap));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadCalendar(testMonth)),
        expect: () => [
          isA<CalendarState>()
              .having((s) => s.status, 'status', CalendarStatus.loading)
              .having((s) => s.focusedMonth, 'focusedMonth', testMonth),
          isA<CalendarState>()
              .having((s) => s.status, 'status', CalendarStatus.success)
              .having((s) => s.events, 'events', testEventsMap),
        ],
      );

      blocTest<CalendarBloc, CalendarState>(
        'emits [loading, failure] when getEventsForMonth fails',
        build: () {
          when(
            () => mockGetEventsForMonth(any()),
          ).thenAnswer((_) async => const Left(CacheFailure('Cache error')));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadCalendar(testMonth)),
        expect: () => [
          isA<CalendarState>().having(
            (s) => s.status,
            'status',
            CalendarStatus.loading,
          ),
          isA<CalendarState>()
              .having((s) => s.status, 'status', CalendarStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', 'Cache error'),
        ],
      );
    });

    group('SelectDay', () {
      blocTest<CalendarBloc, CalendarState>(
        'emits state with new selectedDay',
        build: () => bloc,
        act: (bloc) => bloc.add(SelectDay(testDay)),
        expect: () => [
          isA<CalendarState>().having(
            (s) => s.selectedDay,
            'selectedDay',
            testDay,
          ),
        ],
      );
    });

    group('AddEventRequested', () {
      blocTest<CalendarBloc, CalendarState>(
        'emits [success] with updated events when addEvent succeeds',
        build: () {
          when(
            () => mockAddEvent(any()),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockGetEventsForMonth(any()),
          ).thenAnswer((_) async => Right(testEventsMap));
          return bloc;
        },
        act: (bloc) => bloc.add(AddEventRequested(testEvent)),
        expect: () => [
          isA<CalendarState>()
              .having((s) => s.status, 'status', CalendarStatus.success)
              .having((s) => s.events, 'events', testEventsMap),
        ],
      );

      blocTest<CalendarBloc, CalendarState>(
        'emits [failure] when addEvent fails',
        build: () {
          when(
            () => mockAddEvent(any()),
          ).thenAnswer((_) async => const Left(CacheFailure('Save failed')));
          return bloc;
        },
        act: (bloc) => bloc.add(AddEventRequested(testEvent)),
        expect: () => [
          isA<CalendarState>()
              .having((s) => s.status, 'status', CalendarStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', 'Save failed'),
        ],
      );
    });

    group('DeleteEventRequested', () {
      blocTest<CalendarBloc, CalendarState>(
        'emits [success] with updated events when deleteEvent succeeds',
        build: () {
          when(
            () => mockDeleteEvent(any()),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockGetEventsForMonth(any()),
          ).thenAnswer((_) async => const Right(<DateTime, List<Event>>{}));
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteEventRequested('test-id')),
        expect: () => [
          isA<CalendarState>()
              .having((s) => s.status, 'status', CalendarStatus.success)
              .having((s) => s.events, 'events', isEmpty),
        ],
      );

      blocTest<CalendarBloc, CalendarState>(
        'emits [failure] when deleteEvent fails',
        build: () {
          when(
            () => mockDeleteEvent(any()),
          ).thenAnswer((_) async => const Left(CacheFailure('Delete failed')));
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteEventRequested('test-id')),
        expect: () => [
          isA<CalendarState>()
              .having((s) => s.status, 'status', CalendarStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', 'Delete failed'),
        ],
      );
    });

    group('ImportHolidays', () {
      final testHolidays = [
        const Holiday(
          date: '2024-01-01',
          localName: 'New Year',
          name: "New Year's Day",
          countryCode: 'US',
          fixed: true,
          global: true,
        ),
        const Holiday(
          date: '2024-07-04',
          localName: 'Independence Day',
          name: 'Independence Day',
          countryCode: 'US',
          fixed: true,
          global: true,
        ),
      ];

      blocTest<CalendarBloc, CalendarState>(
        'emits [loading, success] with holidays when import succeeds',
        build: () {
          when(
            () => mockGetHolidays(any()),
          ).thenAnswer((_) async => Right(testHolidays));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const ImportHolidays(countryCode: 'US', year: 2024)),
        expect: () => [
          isA<CalendarState>().having(
            (s) => s.status,
            'status',
            CalendarStatus.loading,
          ),
          isA<CalendarState>()
              .having((s) => s.status, 'status', CalendarStatus.success)
              .having((s) => s.holidays.length, 'holidays length', 2)
              .having(
                (s) => s.holidays[DateTime(2024, 1, 1)]?.name,
                'holiday name',
                "New Year's Day",
              ),
        ],
      );

      blocTest<CalendarBloc, CalendarState>(
        'emits [loading, failure] when import fails',
        build: () {
          when(
            () => mockGetHolidays(any()),
          ).thenAnswer((_) async => const Left(ServerFailure('Network error')));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const ImportHolidays(countryCode: 'US', year: 2024)),
        expect: () => [
          isA<CalendarState>().having(
            (s) => s.status,
            'status',
            CalendarStatus.loading,
          ),
          isA<CalendarState>()
              .having((s) => s.status, 'status', CalendarStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', 'Network error'),
        ],
      );
    });
  });
}

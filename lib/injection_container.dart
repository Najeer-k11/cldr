import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:cldr/core/network/api_client.dart';
import 'package:cldr/features/calendar/data/datasources/local_datasource.dart';
import 'package:cldr/features/calendar/data/datasources/remote_datasource.dart';
import 'package:cldr/features/calendar/data/models/event_model.dart';
import 'package:cldr/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:cldr/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:cldr/features/calendar/domain/usecases/add_event.dart';
import 'package:cldr/features/calendar/domain/usecases/delete_event.dart';
import 'package:cldr/features/calendar/domain/usecases/get_events.dart';
import 'package:cldr/features/calendar/domain/usecases/get_events_for_month.dart';
import 'package:cldr/features/calendar/domain/usecases/get_holidays.dart';
import 'package:cldr/features/calendar/presentation/bloc/calendar_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => CalendarBloc(
      getHolidays: sl(),
      getEvents: sl(),
      getEventsForMonth: sl(),
      addEvent: sl(),
      deleteEvent: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetHolidays(sl()));
  sl.registerLazySingleton(() => GetEvents(sl()));
  sl.registerLazySingleton(() => GetEventsForMonth(sl()));
  sl.registerLazySingleton(() => AddEvent(sl()));
  sl.registerLazySingleton(() => DeleteEvent(sl()));

  // Repository
  sl.registerLazySingleton<CalendarRepository>(
    () => CalendarRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<CalendarRemoteDataSource>(
    () => CalendarRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<CalendarLocalDataSource>(
    () => CalendarLocalDataSourceImpl(eventBox: sl()),
  );

  // Core
  sl.registerLazySingleton(() => ApiClient());

  // External
  final eventBox = await Hive.openBox<EventModel>('events');
  sl.registerLazySingleton<Box<EventModel>>(() => eventBox);
}

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cldr/core/constants/app_strings.dart';
import 'package:cldr/core/theme/app_theme.dart';
import 'package:cldr/features/calendar/data/models/event_model.dart';
import 'package:cldr/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:cldr/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:cldr/features/calendar/presentation/pages/calendar_page.dart';
import 'package:cldr/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(EventModelAdapter());

  await di.init();

  runApp(const CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: AppStrings.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(lightDynamic),
          darkTheme: AppTheme.darkTheme(darkDynamic),
          themeMode: ThemeMode.system,
          home: BlocProvider(
            create: (_) {
              final bloc = di.sl<CalendarBloc>();
              final now = DateTime.now();
              bloc.add(LoadCalendar(DateTime(now.year, now.month)));
              return bloc;
            },
            child: const CalendarPage(),
          ),
        );
      },
    );
  }
}

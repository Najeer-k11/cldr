import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cldr/core/constants/app_strings.dart';
import 'package:cldr/features/calendar/domain/entities/event.dart';
import 'package:cldr/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:cldr/features/calendar/presentation/bloc/calendar_event.dart'
    as bloc_event;
import 'package:cldr/features/calendar/presentation/bloc/calendar_state.dart';
import 'package:cldr/features/calendar/presentation/widgets/add_event_sheet.dart';
import 'package:cldr/features/calendar/presentation/widgets/calendar_grid.dart';
import 'package:cldr/features/calendar/presentation/widgets/event_list.dart';
import 'package:cldr/features/calendar/presentation/widgets/import_holidays_sheet.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarBloc, CalendarState>(
      listenWhen: (prev, curr) =>
          curr.status == CalendarStatus.failure && curr.errorMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage ?? AppStrings.unknownError),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: const CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: CalendarGrid()),
            SliverToBoxAdapter(child: Divider(height: 1)),
            SliverToBoxAdapter(child: SizedBox(height: 8)),
            EventList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddEventSheet(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<CalendarBloc, CalendarState>(
        buildWhen: (prev, curr) => prev.focusedMonth != curr.focusedMonth,
        builder: (context, state) {
          return Text(
            DateFormat.yMMMM().format(state.focusedMonth),
            style: Theme.of(context).textTheme.titleMedium,
          );
        },
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: () => _navigateMonth(context, -1),
        tooltip: AppStrings.previousMonth,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.today),
          onPressed: () => _goToToday(context),
          tooltip: AppStrings.today,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => _navigateMonth(context, 1),
          tooltip: AppStrings.nextMonth,
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'import_holidays') {
              _showImportHolidaysSheet(context);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'import_holidays',
              child: Row(
                children: [
                  const Icon(Icons.public, size: 20),
                  const SizedBox(width: 8),
                  Text(AppStrings.importHolidays),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateMonth(BuildContext context, int offset) {
    final state = context.read<CalendarBloc>().state;
    final newMonth = DateTime(
      state.focusedMonth.year,
      state.focusedMonth.month + offset,
    );
    context.read<CalendarBloc>().add(bloc_event.LoadCalendar(newMonth));
  }

  void _goToToday(BuildContext context) {
    final now = DateTime.now();
    final month = DateTime(now.year, now.month);
    context.read<CalendarBloc>().add(bloc_event.LoadCalendar(month));
    context.read<CalendarBloc>().add(
      bloc_event.SelectDay(DateTime(now.year, now.month, now.day)),
    );
  }

  void _showAddEventSheet(BuildContext context) async {
    final state = context.read<CalendarBloc>().state;
    final event = await showModalBottomSheet<Event>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => AddEventSheet(selectedDate: state.selectedDay),
    );

    if (event != null && context.mounted) {
      context.read<CalendarBloc>().add(bloc_event.AddEventRequested(event));
    }
  }

  void _showImportHolidaysSheet(BuildContext context) async {
    final result = await showModalBottomSheet<ImportHolidaysResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const ImportHolidaysSheet(),
    );

    if (result != null && context.mounted) {
      context.read<CalendarBloc>().add(
        bloc_event.ImportHolidays(
          countryCode: result.countryCode,
          year: result.year,
        ),
      );
    }
  }
}

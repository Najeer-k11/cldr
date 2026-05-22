import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cldr/core/constants/app_strings.dart';
import 'package:cldr/features/calendar/domain/entities/event.dart';
import 'package:cldr/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:cldr/features/calendar/presentation/bloc/calendar_event.dart'
    as bloc_event;
import 'package:cldr/features/calendar/presentation/bloc/calendar_state.dart';

class EventList extends StatelessWidget {
  const EventList({super.key});

  static const List<Color> eventColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        final normalizedDay = DateTime(
          state.selectedDay.year,
          state.selectedDay.month,
          state.selectedDay.day,
        );
        final events = state.events[normalizedDay] ?? [];
        final holiday = state.holidays[normalizedDay];

        if (events.isEmpty && holiday == null) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  AppStrings.noEvents,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (holiday != null && index == 0) {
              return _buildHolidayTile(context, holiday.localName);
            }

            final eventIndex = holiday != null ? index - 1 : index;
            if (eventIndex < events.length) {
              return _buildEventTile(context, events[eventIndex]);
            }
            return null;
          }, childCount: events.length + (holiday != null ? 1 : 0)),
        );
      },
    );
  }

  Widget _buildHolidayTile(BuildContext context, String name) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: colorScheme.tertiaryContainer,
      child: ListTile(
        leading: Icon(Icons.celebration, color: colorScheme.tertiary),
        title: Text(
          name,
          style: TextStyle(color: colorScheme.onTertiaryContainer),
        ),
        subtitle: Text(
          AppStrings.publicHoliday,
          style: TextStyle(
            color: colorScheme.onTertiaryContainer.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildEventTile(BuildContext context, Event event) {
    final color = eventColors[event.colorIndex % eventColors.length];
    final timeStr = event.time != null
        ? DateFormat.jm().format(event.time!)
        : AppStrings.allDay;

    return Dismissible(
      key: Key(event.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Theme.of(context).colorScheme.error,
        child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
      ),
      onDismissed: (_) {
        context.read<CalendarBloc>().add(
          bloc_event.DeleteEventRequested(event.id),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(Icons.event, color: color, size: 20),
          ),
          title: Text(event.title),
          subtitle: Text(timeStr),
          trailing: event.notes != null && event.notes!.isNotEmpty
              ? const Icon(Icons.notes, size: 16)
              : null,
        ),
      ),
    );
  }
}

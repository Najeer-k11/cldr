import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cldr/core/constants/app_strings.dart';
import 'package:cldr/features/calendar/domain/entities/event.dart';
import 'package:cldr/features/calendar/domain/entities/holiday.dart';
import 'package:cldr/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:cldr/features/calendar/presentation/bloc/calendar_event.dart'
    as bloc_event;
import 'package:cldr/features/calendar/presentation/bloc/calendar_state.dart';
import 'package:cldr/features/calendar/presentation/widgets/day_cell.dart';

class CalendarGrid extends StatefulWidget {
  const CalendarGrid({super.key});

  @override
  State<CalendarGrid> createState() => _CalendarGridState();
}

class _CalendarGridState extends State<CalendarGrid> {
  late PageController _pageController;
  late DateTime _baseMonth;

  @override
  void initState() {
    super.initState();
    _baseMonth = DateTime(2000, 1);
    _pageController = PageController(
      initialPage: _monthDifference(_baseMonth, DateTime.now()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _monthDifference(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + (to.month - from.month);
  }

  DateTime _monthFromIndex(int index) {
    final totalMonths = _baseMonth.month - 1 + index;
    final year = _baseMonth.year + totalMonths ~/ 12;
    final month = totalMonths % 12 + 1;
    return DateTime(year, month);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildWeekdayHeaders(context),
            SizedBox(
              height: 252,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  final month = _monthFromIndex(index);
                  context.read<CalendarBloc>().add(
                    bloc_event.LoadCalendar(month),
                  );
                },
                itemBuilder: (context, index) {
                  final month = _monthFromIndex(index);
                  return _buildMonthGrid(context, state, month);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeekdayHeaders(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: AppStrings.weekDays.map((day) {
          return SizedBox(
            width: 42,
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMonthGrid(
    BuildContext context,
    CalendarState state,
    DateTime month,
  ) {
    final days = _generateDaysForMonth(month);
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
        ),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final normalizedDay = DateTime(day.year, day.month, day.day);
          final normalizedSelected = DateTime(
            state.selectedDay.year,
            state.selectedDay.month,
            state.selectedDay.day,
          );

          final isSelected = normalizedDay == normalizedSelected;
          final isToday = normalizedDay == normalizedToday;
          final isOutsideMonth = day.month != month.month;

          final List<Event>? dayEvents = state.events[normalizedDay];
          final Holiday? dayHoliday = state.holidays[normalizedDay];

          return DayCell(
            day: day,
            isSelected: isSelected,
            isToday: isToday,
            isOutsideMonth: isOutsideMonth,
            events: dayEvents,
            holiday: dayHoliday,
            onTap: () {
              context.read<CalendarBloc>().add(
                bloc_event.SelectDay(normalizedDay),
              );
            },
          );
        },
      ),
    );
  }

  List<DateTime> _generateDaysForMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    // Monday = 1, so offset is (weekday - 1)
    final startOffset = (firstDayOfMonth.weekday - 1) % 7;
    final startDate = firstDayOfMonth.subtract(Duration(days: startOffset));

    final List<DateTime> days = [];
    for (int i = 0; i < 42; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }
}

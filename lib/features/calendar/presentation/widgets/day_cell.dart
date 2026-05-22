import 'package:flutter/material.dart';
import 'package:cldr/features/calendar/domain/entities/event.dart';
import 'package:cldr/features/calendar/domain/entities/holiday.dart';

class DayCell extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final bool isOutsideMonth;
  final List<Event>? events;
  final Holiday? holiday;
  final VoidCallback onTap;

  const DayCell({
    super.key,
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.isOutsideMonth,
    this.events,
    this.holiday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasEvents = events != null && events!.isNotEmpty;
    final hasHoliday = holiday != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 42, maxWidth: 42),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? colorScheme.primary : null,
              border: isToday && !isSelected
                  ? Border.all(color: colorScheme.primary, width: 1.5)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isToday || isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: _getTextColor(colorScheme),
                  ),
                ),
                if (hasEvents || hasHoliday)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (hasEvents)
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.primary,
                          ),
                        ),
                      if (hasEvents && hasHoliday) const SizedBox(width: 2),
                      if (hasHoliday)
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.tertiary,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTextColor(ColorScheme colorScheme) {
    if (isSelected) return colorScheme.onPrimary;
    if (isOutsideMonth) return colorScheme.onSurface.withValues(alpha: 0.35);
    if (holiday != null) return colorScheme.tertiary;
    return colorScheme.onSurface;
  }
}

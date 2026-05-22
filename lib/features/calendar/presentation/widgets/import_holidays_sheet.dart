import 'package:flutter/material.dart';
import 'package:cldr/core/constants/app_strings.dart';

class ImportHolidaysResult {
  final String countryCode;
  final int year;

  const ImportHolidaysResult({required this.countryCode, required this.year});
}

class ImportHolidaysSheet extends StatefulWidget {
  const ImportHolidaysSheet({super.key});

  @override
  State<ImportHolidaysSheet> createState() => _ImportHolidaysSheetState();
}

class _ImportHolidaysSheetState extends State<ImportHolidaysSheet> {
  String _selectedCountry = 'US';
  late int _selectedYear;

  static const Map<String, String> countries = {
    'US': 'United States',
    'GB': 'United Kingdom',
    'DE': 'Germany',
    'FR': 'France',
    'CA': 'Canada',
    'AU': 'Australia',
    'IN': 'India',
    'JP': 'Japan',
    'BR': 'Brazil',
    'IT': 'Italy',
    'ES': 'Spain',
    'NL': 'Netherlands',
    'AT': 'Austria',
    'CH': 'Switzerland',
    'SE': 'Sweden',
    'NO': 'Norway',
    'DK': 'Denmark',
    'FI': 'Finland',
    'PL': 'Poland',
    'PT': 'Portugal',
  };

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.importHolidays,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: _selectedCountry,
            decoration: InputDecoration(
              labelText: AppStrings.country,
              border: const OutlineInputBorder(),
            ),
            items: countries.entries.map((entry) {
              return DropdownMenuItem(
                value: entry.key,
                child: Text('${entry.value} (${entry.key})'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedCountry = value);
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _selectedYear,
            decoration: InputDecoration(
              labelText: AppStrings.year,
              border: const OutlineInputBorder(),
            ),
            items: List.generate(10, (i) {
              final year = DateTime.now().year - 2 + i;
              return DropdownMenuItem(value: year, child: Text('$year'));
            }),
            onChanged: (value) {
              if (value != null) setState(() => _selectedYear = value);
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppStrings.cancel),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    ImportHolidaysResult(
                      countryCode: _selectedCountry,
                      year: _selectedYear,
                    ),
                  );
                },
                child: Text(AppStrings.importAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:cldr/core/error/exceptions.dart';
import 'package:cldr/core/network/api_client.dart';
import 'package:cldr/features/calendar/data/models/holiday_model.dart';

abstract class CalendarRemoteDataSource {
  Future<List<HolidayModel>> getHolidays(String countryCode, int year);
}

class CalendarRemoteDataSourceImpl implements CalendarRemoteDataSource {
  final ApiClient apiClient;

  CalendarRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<HolidayModel>> getHolidays(String countryCode, int year) async {
    try {
      final response = await apiClient.dio.get(
        '/PublicHolidays/$year/$countryCode',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => HolidayModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Failed to fetch holidays: ${response.statusCode}',
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch holidays: $e');
    }
  }
}

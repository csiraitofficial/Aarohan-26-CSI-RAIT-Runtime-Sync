import 'package:dio/dio.dart';

import '../core/config/app_config.dart';
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/event_model.dart';

class EventService {
  EventService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<EventModel>> fetchNearbyEvents(double lat, double lng) async {
    if (AppConfig.useMockBackend) {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      final now = DateTime.now();
      return [
        EventModel(
          id: 101,
          name: 'City Fest Main Arena',
          centerLat: lat,
          centerLng: lng,
          radius: 450,
          startTime: now,
          endTime: now.add(const Duration(hours: 5)),
        ),
        EventModel(
          id: 102,
          name: 'College Cultural Night',
          centerLat: lat + 0.001,
          centerLng: lng + 0.001,
          radius: 300,
          startTime: now.add(const Duration(hours: 1)),
          endTime: now.add(const Duration(hours: 4)),
        ),
      ];
    }

    try {
      final response = await _apiClient.dio.get(
        ApiConstants.nearbyEvents,
        queryParameters: {'lat': lat, 'lng': lng},
      );

      final data = response.data;
      if (data is! List) {
        throw Exception('Invalid server response. Please try again.');
      }

      return data
          .map((item) => EventModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }

  String _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError) {
      return 'Unable to load nearby events. Please check your internet connection.';
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Server is taking too long to respond. Please try again.';
    }

    if (e.response?.statusCode == 503 || e.response?.statusCode == 502) {
      return 'Service is temporarily unavailable. Please try shortly.';
    }

    final data = e.response?.data;
    if (data is Map<String, dynamic> && data['message'] != null) {
      return data['message'].toString();
    }

    return 'Unable to load nearby events right now.';
  }
}

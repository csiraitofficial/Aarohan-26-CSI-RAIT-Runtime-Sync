import 'package:dio/dio.dart';

import '../core/config/app_config.dart';
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/incident_request.dart';

class IncidentService {
  IncidentService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  /// Submit incident and return incidentId
  Future<int> submitIncident(IncidentRequest request) async {
    if (AppConfig.useMockBackend) {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      return 1;
    }

    try {
      final response = await _apiClient.dio.post(
        ApiConstants.incidents,
        data: request.toJson(),
      );

      final data = response.data;

      if (data is int) {
        return data;
      }

      if (data is String) {
        return int.parse(data);
      }

      throw Exception('Invalid server response');
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }

  /// Resolve incident
  Future<void> resolveIncident(int incidentId) async {
    if (AppConfig.useMockBackend) {
      await Future<void>.delayed(const Duration(milliseconds: 650));
      return;
    }

    try {
      await _apiClient.dio.post(
        '${ApiConstants.incidents}/$incidentId/resolve',
      );
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    }
  }

  String _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Request timed out. Please try again.';
    }

    if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    }

    final data = e.response?.data;

    if (data is Map<String, dynamic> && data['message'] != null) {
      return data['message'].toString();
    }

    return 'Unable to submit incident right now. Please try again.';
  }
}
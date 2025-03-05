import 'package:take_home_marv/models/api_response_model.dart';

abstract class IApiService {
  Future<ApiResponse> get(String endpoint, {Map<String, dynamic>? queryParams});
  Future<ApiResponse> post(String endpoint, {Map<String, dynamic>? data});
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/user_profile_model.dart';
import '../datasources/auth_local_datasource.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String username, String password);
  Future<UserProfileModel> getProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource localDataSource;
  final String baseUrl = 'https://buddy-of9y.onrender.com';

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.localDataSource,
  });

  // Helper method to get auth headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await localDataSource.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<AuthResponseModel> login(String username, String password) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(json.decode(response.body));
        // Store the token
        await localDataSource.cacheToken(authResponse.accessToken);
        return authResponse;
      } else if (response.statusCode == 401) {
        final errorBody = json.decode(response.body);
        throw UnauthorizedException(
          message: errorBody['detail'] ?? 'Invalid credentials',
        );
      } else {
        throw ServerException(
          message: 'Failed to login. Please try again.',
        );
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(
        message: 'An error occurred while logging in.',
      );
    }
  }

  @override
  Future<UserProfileModel> getProfile() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await client.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(
          message: 'Session expired. Please login again.',
        );
      } else {
        throw ServerException(
          message: 'Failed to get profile. Please try again.',
        );
      }
    } catch (e) {
      if (e is UnauthorizedException) rethrow;
      throw ServerException(
        message: 'An error occurred while fetching profile.',
      );
    }
  }
}
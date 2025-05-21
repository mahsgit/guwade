import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_profile_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUserCredentials(String username, String password);
  Future<void> cacheToken(String token);
  Future<Map<String, String>?> getCachedCredentials();
  Future<String?> getToken();
  Future<void> cacheUserProfile(UserProfileModel profile);
  Future<UserProfileModel?> getCachedUserProfile();
  Future<void> clearUserCredentials();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  @override
  Future<void> cacheUserCredentials(String username, String password) async {
    await sharedPreferences.setString('CACHED_USERNAME', username);
    // Don't store password in SharedPreferences for security reasons
    // Instead, store it in secure storage
    await secureStorage.write(key: 'CACHED_PASSWORD', value: password);
  }

  @override
  Future<void> cacheToken(String token) async {
    await secureStorage.write(key: 'auth_token', value: token);
  }

  @override
  Future<Map<String, String>?> getCachedCredentials() async {
    final username = sharedPreferences.getString('CACHED_USERNAME');
    final password = await secureStorage.read(key: 'CACHED_PASSWORD');
    
    if (username != null && password != null) {
      return {
        'username': username,
        'password': password,
      };
    }
    return null;
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: 'auth_token');
  }

  @override
  Future<void> cacheUserProfile(UserProfileModel profile) async {
    await sharedPreferences.setString(
      'CACHED_USER_PROFILE',
      profile.toJson().toString(),
    );
  }

  @override
  Future<UserProfileModel?> getCachedUserProfile() {
    final profileString = sharedPreferences.getString('CACHED_USER_PROFILE');
    if (profileString != null) {
      return Future.value(
        UserProfileModel.fromJson(json.decode(profileString)),
      );
    }
    return Future.value(null);
  }

  @override
  Future<void> clearUserCredentials() async {
    await sharedPreferences.remove('CACHED_USERNAME');
    await secureStorage.delete(key: 'CACHED_PASSWORD');
    await secureStorage.delete(key: 'auth_token');
    await sharedPreferences.remove('CACHED_USER_PROFILE');
  }
}
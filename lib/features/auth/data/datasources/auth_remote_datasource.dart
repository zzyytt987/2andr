import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/auth_token.dart';
import '../../domain/entities/user.dart';

class AuthRemoteDataSource {
  final Dio _dio = DioClient.instance.dio;

  Future<Map<String, dynamic>> loginWithPassword(
      String phone, String password) async {
    final response = await _dio.post(ApiConstants.loginPassword, data: {
      'phone': phone,
      'password': password,
    });
    return response.data['data'];
  }

  Future<Map<String, dynamic>> loginWithSms(String phone, String code) async {
    final response = await _dio.post(ApiConstants.loginSms, data: {
      'phone': phone,
      'smsCode': code,
    });
    return response.data['data'];
  }

  Future<Map<String, dynamic>> register(
      String phone, String code, String password) async {
    final response = await _dio.post(ApiConstants.register, data: {
      'phone': phone,
      'smsCode': code,
      'password': password,
    });
    return response.data['data'];
  }

  Future<void> sendSms(String phone, String type) async {
    await _dio.post(ApiConstants.sendSms, data: {
      'phone': phone,
      'type': type,
    });
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _dio.post(ApiConstants.refreshToken, data: {
      'refreshToken': refreshToken,
    });
    return response.data['data'];
  }

  Future<void> logout() async {
    await _dio.post(ApiConstants.logout);
  }

  AuthToken parseToken(Map<String, dynamic> data) {
    return AuthToken.fromJson(data);
  }

  User parseUser(Map<String, dynamic> userData) {
    return User.fromJson(userData);
  }
}

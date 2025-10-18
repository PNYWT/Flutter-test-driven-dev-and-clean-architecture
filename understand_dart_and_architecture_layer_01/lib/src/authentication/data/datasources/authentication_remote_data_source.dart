import 'dart:convert';

import 'package:understand_dart_and_architecture_layer_01/core/errors/exceptions.dart';
import 'package:understand_dart_and_architecture_layer_01/core/utilis/constants.dart';
import 'package:understand_dart_and_architecture_layer_01/core/utilis/typedef.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/data/models/user_model.dart';
import "package:http/http.dart" as http;

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();

  Future<void> deleteUser(String id);
}

const kCreateUserEndpoint = "$kBaseUrl/users";
const kGetUsersEndpoint = "$kBaseUrl/users";
String kDeleteUserEndpoint(String id) => "$kBaseUrl/users/$id";

class AuthenticationRemoteDataSourceImplementation
    implements AuthenticationRemoteDataSource {
  const AuthenticationRemoteDataSourceImplementation(this._client);

  final http.Client _client;

  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    // 1. check to make sure that it returns the right data when  the response code is 200 or proper response code
    // 2. check to make sure that it "THROWS" a custom exception with the right message when the response code is not 200
    try {
      final response = await _client.post(
        Uri.parse(kCreateUserEndpoint),
        body: jsonEncode({
          "createdAt": createdAt,
          "name": name,
          "avatar": avatar,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // Server Error
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on APIException {
      // ถ้ามีการ throw exception ที่เป็นชนิด APIException ให้เข้าบล็อกนี้
      rethrow;
    } catch (e) {
      // dart Error -> error e.g. network error, JSON decode error
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client.get(Uri.parse(kGetUsersEndpoint));

      if (response.statusCode != 200) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
      return List<DataMap>.from(
        jsonDecode(response.body) as List,
      ).map((userData) => UserModel.fromMap(userData)).toList();
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      final response = await _client.delete(
        Uri.parse(kDeleteUserEndpoint(id)),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }
}

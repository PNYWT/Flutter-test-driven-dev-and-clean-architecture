import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import "package:http/http.dart" as http;
import 'package:understand_dart_and_architecture_layer_01/core/errors/exceptions.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/data/models/user_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource dataSource;

  setUp(() async {
    client = MockClient();
    dataSource = AuthenticationRemoteDataSourceImplementation(client);
    registerFallbackValue(Uri());
  });

  // MARK: CreateUser
  group("createUser", () {
    test(
      "should complete successfully when the status code is 200 or 201",
      () async {
        when(
          () => client.post(
            any(),
            body: any(named: "body"),
            headers: any(named: "headers"),
          ),
        ).thenAnswer(
          (_) async => http.Response("User created successfully", 200),
        );
        const createdAt = "test_createdAt";
        const name = "test_name";
        const avatar = "test_avatar";
        final methodCall = dataSource.createUser;

        // completes ใช้ตรวจว่า Future “สำเร็จ” โดยไม่ throw error ใด ๆ expect() จะรอ Future ตัวนี้เสร็จ (await ให้เอง)
        expect(
          methodCall(createdAt: createdAt, name: name, avatar: avatar),
          completes,
        );

        verify(
          () => client.post(
            Uri.parse(kCreateUserEndpoint),
            body: jsonEncode({
              "createdAt": createdAt,
              "name": name,
              "avatar": avatar,
            }),
            headers: {"Content-Type": "application/json"},
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );

    test(
      "should throw [APIException] when the status code is not 200 or 201",
      () async {
        const tAPIException = APIException(
          message: "Invalid data",
          statusCode: 400,
        );
        when(
          () => client.post(
            any(),
            body: any(named: "body"),
            headers: any(named: "headers"),
          ),
        ).thenAnswer(
          (_) async =>
              http.Response(tAPIException.message, tAPIException.statusCode),
        );

        const createdAt = "test_createdAt";
        const name = "test_name";
        const avatar = "test_avatar";
        final methodCall = dataSource.createUser;

        // ต้องใส่ () async => ... (function/closure) เพราะถ้าเรียก methodCall(...) ตรง ๆ → มันจะโยน exception ทันที
        expect(
          () async =>
              methodCall(createdAt: createdAt, name: name, avatar: avatar),
          throwsA(tAPIException),
        );

        verify(
          () => client.post(
            Uri.parse(kCreateUserEndpoint),
            body: jsonEncode({
              "createdAt": createdAt,
              "name": name,
              "avatar": avatar,
            }),
            headers: {"Content-Type": "application/json"},
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );
  });

  // MARK: GetUsers
  group("getUsers", () {
    const tUsers = [UserModel.empty()];
    test(
      "should return [List<UserModel>] when the status code is 200",
      () async {
        when(() => client.get(any())).thenAnswer(
          (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200),
        );

        final result = await dataSource.getUsers();

        expect(result, equals(tUsers));

        verify(() => client.get(Uri.parse(kCreateUserEndpoint))).called(1);

        verifyNoMoreInteractions(client);
      },
    );
    test(
      "should throw [APIException] when the status code is not 200",
      () async {
        const tAPIException = APIException(
          message: "Server down, Server down, I repeat Server down!!!",
          statusCode: 500,
        );
        when(() => client.get(any())).thenAnswer(
          (_) async =>
              http.Response(tAPIException.message, tAPIException.statusCode),
        );

        final methodCall = dataSource.getUsers;

        expect(() async => methodCall(), throwsA(tAPIException));

        verify(() => client.get(Uri.parse(kCreateUserEndpoint))).called(1);

        verifyNoMoreInteractions(client);
      },
    );
  });

  // MARK: DeleteUser
  group("deleteUser", () {
    test(
      "should complete successfully when the status code is 200 or 201",
      () async {
        when(
          () => client.delete(any(), headers: any(named: "headers")),
        ).thenAnswer(
          (_) async => http.Response("User delete successfully", 200),
        );

        const tid = "1";
        final methodCall = dataSource.deleteUser;

        expect(methodCall(tid), completes);

        verify(
          () => client.delete(
            Uri.parse(kDeleteUserEndpoint(tid)),
            headers: {"Content-Type": "application/json"},
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );

    test(
      "should throw [APIException] when the status code is not 200 or 201",
      () async {
        const tAPIException = APIException(
          message: "ID not found",
          statusCode: 400,
        );
        when(
          () => client.delete(any(), headers: any(named: "headers")),
        ).thenAnswer(
          (_) async =>
              http.Response(tAPIException.message, tAPIException.statusCode),
        );

        const tid = "1";
        final methodCall = dataSource.deleteUser;

        expect(() async => methodCall(tid), throwsA(tAPIException));

        verify(
          () => client.delete(
            Uri.parse(kDeleteUserEndpoint(tid)),
            headers: {"Content-Type": "application/json"},
          ),
        ).called(1);

        verifyNoMoreInteractions(client);
      },
    );
  });
}

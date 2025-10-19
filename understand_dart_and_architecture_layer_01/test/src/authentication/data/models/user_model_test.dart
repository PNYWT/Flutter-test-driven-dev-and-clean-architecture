import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:understand_dart_and_architecture_layer_01/core/utils/typedef.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/data/models/user_model.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();
  test("should be a subclass of [User] entity", () {
    expect(tModel, isA<User>());
  });

  final tJson = fixtures("user.json");
  final tMap = jsonDecode(tJson) as DataMap;
  group("formMap", () {
    test("should return a [UserModel] with the right data useing Decode", () {
      final result = UserModel.fromMap(tMap);
      expect(result, equals(tModel));
    });
  });

  group("fromJson", () {
    test("should return a [UserModel] with the right data using Map", () {
      final result = UserModel.fromJson(tJson);
      expect(result, equals(tModel));
    });
  });

  group("toMap", () {
    test(
      "should return a [<String, dynamic>] with the right data using toMap",
      () {
        final result = tModel.toMap();
        expect(result, equals(tMap));
      },
    );
  });

  group("toJson", () {
    test("should return a [JSON] with the right data using toJson", () {
      final result = tModel.toJson();
      final tJson = jsonEncode({
        "id": "_empty.id",
        "createdAt": "_empty.createdAt",
        "name": "_empty.name",
        "avatar": "_empty.avatar",
      });

      expect(result, equals(tJson));
    });
  });

  group("coptyWith", () {
    test("should return a [UserModel] with different data e.g. name", () {
      final result = tModel.copyWith(name: "TestName");
      expect(result.name, equals("TestName"));
      expect(result, isNot(tModel));
    });
  });
}

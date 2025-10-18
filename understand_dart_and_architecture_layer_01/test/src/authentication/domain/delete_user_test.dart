import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/usecases/delete_user.dart';
import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late DeleteUser usecase;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = DeleteUser(repository);
  });

  const tParams = DeleteUserParams(id: '123');

  test("should call the [Repository.deleteUser]", () async {
    // Arrange
    when(
      () => repository.deleteUser(any(that: isA<String>())),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, equals(const Right<dynamic, void>(null)));

    verify(() => repository.deleteUser(tParams.id)).called(1);
    verifyNoMoreInteractions(repository);
  });
}

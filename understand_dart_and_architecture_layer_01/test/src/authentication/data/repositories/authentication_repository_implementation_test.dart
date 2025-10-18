import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:understand_dart_and_architecture_layer_01/core/errors/exceptions.dart';
import 'package:understand_dart_and_architecture_layer_01/core/errors/failure.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/entities/user.dart';

class MockAuthenticationDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repositoryImpl;
  setUp(() {
    remoteDataSource = MockAuthenticationDataSource();
    repositoryImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  group("createUser", () {
    const createdAt = "test_createdAt";
    const name = "test_name";
    const avatar = "test_avatar";
    test(
      "should call [RemoteDataSource.createUser] and return a [Future<void>] - successful",
      () async {
        when(
          () => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          ),
        ).thenAnswer((_) async => Future.value());

        final result = await repositoryImpl.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );

        expect(result, equals(const Right<dynamic, void>(null)));

        verify(
          () => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    const tException = APIException(message: "Unknown error.", statusCode: 500);
    test(
      "should call [RemoteDataSource.createUser] and return a [ServerFailure] when the call to the remote source is unsuccessful",
      () async {
        when(
          () => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          ),
        ).thenThrow(tException);

        final result = await repositoryImpl.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );

        expect(
          result,
          equals(
            Left<Failure, dynamic>(
              ApiFailure(
                message: tException.message,
                statusCode: tException.statusCode,
              ),
            ),
          ),
        );

        verify(
          () => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group("getUsers", () {
    test(
      "should call [RemoteDataSource.getUsers] and return a [List<User>] - successful",
      () async {
        when(() => remoteDataSource.getUsers()).thenAnswer((_) async => []);

        final result = await repositoryImpl.getUsers();

        expect(result, isA<Right<dynamic, List<User>>>());

        verify(() => remoteDataSource.getUsers()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    const tException = APIException(message: "Unknown error.", statusCode: 500);
    test(
      "should call [RemoteDataSource.getUsers] and return a [ServerFailure] when the call to the remote source is unsuccessful",
      () async {
        when(() => remoteDataSource.getUsers()).thenThrow(tException);

        final result = await repositoryImpl.getUsers();

        expect(
          result,
          equals(Left<Failure, dynamic>(ApiFailure.fromException(tException))),
        );

        verify(() => remoteDataSource.getUsers()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}

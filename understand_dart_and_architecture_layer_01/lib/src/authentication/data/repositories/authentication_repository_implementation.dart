import 'package:dartz/dartz.dart';
import 'package:understand_dart_and_architecture_layer_01/core/utilis/typedef.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/entities/user.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  const AuthenticationRepositoryImplementation(this._remoteDataSource);

  final AuthenticationRemoteDataSource _remoteDataSource;

  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    // Test-Driven Development
    // call the remote data source
    // check if the method returns the proper data
    // // check if when the remoteDataSource throws an exception, the method returns a failure
    // and if it doesn't throw an exception, the method returns a success or excepted data
    return Right(
      _remoteDataSource.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      ),
    );
  }

  @override
  ResultFuture<List<User>> getUsers() {
    throw UnimplementedError();
  }
}

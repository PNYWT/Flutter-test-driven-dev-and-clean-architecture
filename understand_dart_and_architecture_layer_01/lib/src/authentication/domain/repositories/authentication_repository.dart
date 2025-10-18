import 'package:understand_dart_and_architecture_layer_01/core/utilis/typedef.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/entities/user.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  ResultFuture<List<User>> getUsers();

  ResultVoid deleteUser(String id);
}

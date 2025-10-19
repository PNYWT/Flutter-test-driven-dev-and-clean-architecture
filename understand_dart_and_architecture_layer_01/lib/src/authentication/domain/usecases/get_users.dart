import 'package:understand_dart_and_architecture_layer_01/core/usecase/usecase.dart';
import 'package:understand_dart_and_architecture_layer_01/core/utils/typedef.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/entities/user.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/repositories/authentication_repository.dart';

class GetUsers extends UsecaseWithOurParams<List<User>> {
  const GetUsers(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<List<User>> call() async {
    return _repository.getUsers();
  }
}

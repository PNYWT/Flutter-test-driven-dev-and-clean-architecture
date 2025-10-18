import 'package:equatable/equatable.dart';
import 'package:understand_dart_and_architecture_layer_01/core/usecase/usecase.dart';
import 'package:understand_dart_and_architecture_layer_01/core/utilis/typedef.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/repositories/authentication_repository.dart';

class DeleteUser implements UsecaseWithParams<void, DeleteUserParams> {
  final AuthenticationRepository repository;

  DeleteUser(this.repository);

  @override
  ResultFuture call(DeleteUserParams params) {
    return repository.deleteUser(params.id);
  }
}

class DeleteUserParams extends Equatable {
  final String id;

  const DeleteUserParams({required this.id});

  @override
  List<Object?> get props => [id];
}

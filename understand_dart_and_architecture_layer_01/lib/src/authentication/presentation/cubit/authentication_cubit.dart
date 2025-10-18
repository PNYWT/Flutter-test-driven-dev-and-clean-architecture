import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/entities/user.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/usecases/create_user.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/usecases/delete_user.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/usecases/get_users.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    required CreateUser createUser,
    required GetUsers getUsers,
    required DeleteUser deleteUser,
  }) : _createUser = createUser,
       _getUsers = getUsers,
       _deleteUser = deleteUser,
       super(const AuthenticationInitial());

  final CreateUser _createUser;
  final GetUsers _getUsers;
  final DeleteUser _deleteUser;

  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    emit(const CreatingUser());

    final result = await _createUser(
      CreateUserParams(createdAt: createdAt, name: name, avatar: avatar),
    );

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (_) => emit(const UserCreated()),
    );
  }

  Future<void> getUsers() async {
    emit(const GettingUsers());
    final result = await _getUsers();
    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (users) => emit(UserLoaded(users)),
    );
  }

  Future<void> deleteUser({required String id}) async {
    if (state is! UserLoaded) return;
    final currentUsers = List<User>.from((state as UserLoaded).users);

    emit(const DeletingUser());

    final result = await _deleteUser(DeleteUserParams(id: id));

    result.fold((failure) => emit(AuthenticationError(failure.errorMessage)), (
      _,
    ) {
      currentUsers.removeWhere((user) => user.id == id);
      emit(UserLoaded(currentUsers));
    });
  }
}

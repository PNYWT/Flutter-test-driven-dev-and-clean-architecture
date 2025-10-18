import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:understand_dart_and_architecture_layer_01/core/errors/failure.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/entities/user.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/usecases/create_user.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/usecases/delete_user.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/usecases/get_users.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/presentation/cubit/authentication_cubit.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

class MockDeleteUser extends Mock implements DeleteUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late DeleteUser deleteUser;
  late AuthenticationCubit cubit;

  const CreateUserParams tCreateUserParams = CreateUserParams.empty();
  const DeleteUserParams tDeleteUserParams = DeleteUserParams(id: '_fake');

  const ApiFailure tAPIFailure = ApiFailure(
    message: "Error message",
    statusCode: 400,
  );

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    deleteUser = MockDeleteUser();
    cubit = AuthenticationCubit(
      createUser: createUser,
      getUsers: getUsers,
      deleteUser: deleteUser,
    );
    registerFallbackValue(tCreateUserParams);
    registerFallbackValue(tDeleteUserParams);
  });

  tearDown(() => cubit.close());

  test("initial state should be [AuthenticationInitial]", () async {
    expect(cubit.state, const AuthenticationInitial());
  });

  group("createUser", () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      "should emit [CreatingUser, UserCreated] when successful.",
      build: () {
        when(
          () => createUser(any()),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },

      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),
      expect: () => const <AuthenticationState>[CreatingUser(), UserCreated()],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      "should emit [CreatingUser, AuthenticationError] when unsuccessful.",
      build: () {
        when(
          () => createUser(any()),
        ).thenAnswer((_) async => const Left(tAPIFailure));
        return cubit;
      },

      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),
      expect: () => <AuthenticationState>[
        const CreatingUser(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  group("getUsers", () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      "should emit [GettingUsers, UserLoaded] when successful.",
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Right([]));
        return cubit;
      },

      act: (cubit) => cubit.getUsers(),
      expect: () => const <AuthenticationState>[GettingUsers(), UserLoaded([])],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      "should emit [GettingUsers, AuthenticationError] when unsuccessful.",
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Left(tAPIFailure));
        return cubit;
      },

      act: (cubit) => cubit.getUsers(),
      expect: () => <AuthenticationState>[
        const GettingUsers(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });

  group("deleteUser", () {
    final tUser = User(
      id: tDeleteUserParams.id,
      createdAt: "test_createdAt",
      name: "test_name",
      avatar: "test_avatar",
    );
    final tUserList = [tUser];

    blocTest<AuthenticationCubit, AuthenticationState>(
      "should emit [DeletingUser, UserLoaded(updatedList)] when successful.",
      build: () {
        when(
          () => deleteUser(any()),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      seed: () => UserLoaded(tUserList),
      act: (cubit) => cubit.deleteUser(id: tDeleteUserParams.id),
      expect: () => <AuthenticationState>[
        const DeletingUser(),
        const UserLoaded([]),
      ],
      verify: (_) {
        verify(() => deleteUser(tDeleteUserParams)).called(1);
        verifyNoMoreInteractions(deleteUser);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      "should emit [DeletingUser, AuthenticationError] when unsuccessful.",
      build: () {
        when(
          () => deleteUser(any()),
        ).thenAnswer((_) async => const Left(tAPIFailure));
        return cubit;
      },
      seed: () => UserLoaded(tUserList),
      act: (cubit) => cubit.deleteUser(id: tDeleteUserParams.id),
      expect: () => <AuthenticationState>[
        const DeletingUser(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => deleteUser(tDeleteUserParams)).called(1);
        verifyNoMoreInteractions(deleteUser);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      "should not emit anything when state is not UserLoaded",
      build: () {
        when(
          () => deleteUser(any()),
        ).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.deleteUser(id: tDeleteUserParams.id),
      expect: () => <AuthenticationState>[],
      verify: (_) {
        // ไม่ควรถูกเรียกเลย เพราะ state ไม่ใช่ UserLoaded
        verifyNever(() => deleteUser(any()));
      },
    );
  });
}

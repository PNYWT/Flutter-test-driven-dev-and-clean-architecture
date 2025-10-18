import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:understand_dart_and_architecture_layer_01/core/errors/failure.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/usecases/create_user.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/usecases/get_users.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/presentation/bloc/authentication_bloc.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticationBloc bloc;

  const CreateUserParams tCreateUserParams = CreateUserParams.empty();

  const ApiFailure tAPIFailure = ApiFailure(
    message: "Error message",
    statusCode: 400,
  );

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    bloc = AuthenticationBloc(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => bloc.close());

  test("initial state should be [AuthenticationInitial]", () async {
    expect(bloc.state, const AuthenticationInitial());
  });

  group("CreateUserEvent", () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      "should emit [CreatingUser, UserCreated] when successful.",
      build: () {
        when(
          () => createUser(any()),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(
        CreateUserEvent(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar,
        ),
      ),
      expect: () => const <AuthenticationState>[CreatingUser(), UserCreated()],
      verify: (_) {
        verify(
          () => createUser(any(that: equals(tCreateUserParams))),
        ).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "should emit [CreatingUser, AuthenticationError] when unsuccessful.",
      build: () {
        when(
          () => createUser(any()),
        ).thenAnswer((_) async => const Left(tAPIFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(
        CreateUserEvent(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar,
        ),
      ),
      expect: () => <AuthenticationState>[
        const CreatingUser(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => createUser(any(that: equals(tCreateUserParams))),
        ).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  group("GetUsersEvent", () {
    blocTest<AuthenticationBloc, AuthenticationState>(
      "should emit [GettingUsers, UserLoaded] when successful.",
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetUsersEvent()),
      expect: () => const <AuthenticationState>[GettingUsers(), UserLoaded([])],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      "should emit [GettingUsers, AuthenticationError] when unsuccessful.",
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Left(tAPIFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetUsersEvent()),
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
}

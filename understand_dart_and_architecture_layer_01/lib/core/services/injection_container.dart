import 'package:get_it/get_it.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/usecases/create_user.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/usecases/delete_user.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/domain/usecases/get_users.dart';
// import 'package:understand_dart_and_architecture_layer_01/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/presentation/cubit/authentication_cubit.dart';
import "package:http/http.dart" as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl
    // Cubit State Management
    ..registerFactory(
      () => AuthenticationCubit(
        createUser: sl(),
        getUsers: sl(),
        deleteUser: sl(),
      ),
    )
    /*
    // BLoC State Management
    ..registerFactory(
      () => AuthenticationBloc(createUser: sl(), getUsers: sl()),
    )
    */
    // Use cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))
    ..registerLazySingleton(() => DeleteUser(sl()))
    // Repositories
    ..registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImplementation(sl()),
    )
    // Data sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthenticationRemoteDataSourceImplementation(sl()),
    )
    // External dependencies
    ..registerLazySingleton(
      () => http.Client(),
    ); // same ..registerLazySingleton(http.Client.new);
}

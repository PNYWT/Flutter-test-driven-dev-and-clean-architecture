import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:understand_dart_and_architecture_layer_01/core/services/injection_container.dart';
// import 'package:understand_dart_and_architecture_layer_01/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/presentation/views/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // create: (_) => sl<AuthenticationBloc>(), // BLoC
      create: (context) => sl<AuthenticationCubit>(), // Cubit
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

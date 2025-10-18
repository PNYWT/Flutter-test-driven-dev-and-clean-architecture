import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/presentation/widgets/add_user_dialog.dart';
import 'package:understand_dart_and_architecture_layer_01/src/authentication/presentation/widgets/loading_column.dart';

// MARK: Example UI with BLoC

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _getUsers() {
    context.read<AuthenticationBloc>().add(const GetUsersEvent());
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is UserCreated) {
          _getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state is GettingUsers
              ? const LoadingColumn(message: "Getting Users")
              : state is CreatingUser
              ? const LoadingColumn(message: "Creating User")
              : state is UserLoaded
              ? Center(
                  child: ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatar),
                        ),
                        title: Text(user.name),
                        subtitle: Text("id: ${user.id}"),
                        trailing: Text(
                          user.createdAt,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),

          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddUserDialog(nameController: _nameController);
                },
              );
            },
            icon: const Icon(Icons.add),
            label: const Text("Add User"),
          ),
        );
      },
    );
  }
}

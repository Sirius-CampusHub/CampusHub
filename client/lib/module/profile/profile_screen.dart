import 'package:client/domain/bloc/auth/auth_event.dart';
import 'package:client/domain/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Профиль'),
        // Just for testing
        ElevatedButton(onPressed: () {
          context.read<AuthBloc>().add(AuthSignOutRequested());
        }, child: Text('UnLog')),
      ],
    ));
  }
}

import 'package:client/domain/model/auth_event.dart';
import 'package:client/domain/model/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      children: [
        Text('Профиль'),
        // Just for testing
        ElevatedButton(onPressed: () {
          context.read<AppBloc>().add(AuthSignOutRequested());
        }, child: Text('UnLog')),
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import 'login_page.dart';
import 'authenticated_shell.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (p, c) => p.isAuthenticated != c.isAuthenticated,
      builder: (context, state) {
        if (state.isAuthenticated) {
          return const AuthenticatedShell();
        }
        return const LoginPage();
      },
    );
  }
}

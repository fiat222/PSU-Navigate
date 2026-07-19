import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/app_colors.dart';
import '../../app/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/navigation/navigation_bloc.dart';
import '../../widgets/shell/prototype_shell.dart';

class AuthenticatedShell extends StatefulWidget {
  const AuthenticatedShell({super.key});

  @override
  State<AuthenticatedShell> createState() => _AuthenticatedShellState();
}

class _AuthenticatedShellState extends State<AuthenticatedShell> {
  void _showToast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.toastBg,
          duration: const Duration(milliseconds: 1800),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
  }

  void _onNavigate(String route, {String? toast, String? indoorRoomCode}) {
    context.read<NavigationBloc>().add(
      NavigateTo(route, toast: toast, indoorRoomCode: indoorRoomCode),
    );
  }

  void _onToggleNotifications() {
    context.read<NavigationBloc>().add(const ToggleNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (p, c) => c.toastMessage != p.toastMessage,
          listener: (context, state) {
            if (state.toastMessage != null) {
              _showToast(state.toastMessage!);
              context.read<AuthBloc>().add(const AuthToastShown());
            }
          },
        ),
        BlocListener<NavigationBloc, NavigationState>(
          listenWhen: (p, c) => c.pendingToast != p.pendingToast,
          listener: (context, state) {
            if (state.pendingToast != null) {
              _showToast(state.pendingToast!);
              context.read<NavigationBloc>().add(const NavigationToastShown());
            }
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return PrototypeShell(
                    currentRoute: state.currentRoute,
                    indoorRoomCode: state.indoorRoomCode,
                    device: AppLayout.deviceFor(constraints.maxWidth),
                    isTransitioning: state.isTransitioning,
                    notificationsEnabled: state.notificationsEnabled,
                    onToggleNotifications: _onToggleNotifications,
                    onNavigate: _onNavigate,
                    onToast: _showToast,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

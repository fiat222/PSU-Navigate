import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app_theme.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/navigation/navigation_bloc.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/event_repository.dart';
import 'data/repositories/mock_auth_repository.dart';
import 'data/repositories/mock_event_repository.dart';
import 'data/repositories/mock_place_repository.dart';
import 'data/repositories/mock_shuttle_repository.dart';
import 'data/repositories/place_repository.dart';
import 'data/repositories/shuttle_repository.dart';
import 'screens/auth/auth_gate.dart';

void main() {
  runApp(const PsuNavigatorApp());
}

class PsuNavigatorApp extends StatelessWidget {
  const PsuNavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => MockAuthRepository()),
        RepositoryProvider<PlaceRepository>(
          create: (_) => MockPlaceRepository(),
        ),
        RepositoryProvider<ShuttleRepository>(
          create: (_) => MockShuttleRepository(),
        ),
        RepositoryProvider<EventRepository>(
          create: (_) => MockEventRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (ctx) => AuthBloc(repo: ctx.read<AuthRepository>()),
          ),
          BlocProvider<NavigationBloc>(create: (_) => NavigationBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PSU Campus Navigator',
          theme: AppTheme.light,
          home: const AuthGate(),
        ),
      ),
    );
  }
}

import 'package:equatable/equatable.dart';

import '../../models/user_profile.dart';

enum AuthStatus { unknown, unauthenticated, authenticating, authenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.token,
    this.submitting = false,
    this.errorMessage,
    this.toastMessage,
  });

  final AuthStatus status;
  final UserProfile? user;
  final String? token;
  final bool submitting;
  final String? errorMessage;
  final String? toastMessage;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  AuthState copyWith({
    AuthStatus? status,
    UserProfile? user,
    String? token,
    bool? submitting,
    String? errorMessage,
    String? toastMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      submitting: submitting ?? this.submitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      toastMessage: toastMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    token,
    submitting,
    errorMessage,
    toastMessage,
  ];
}

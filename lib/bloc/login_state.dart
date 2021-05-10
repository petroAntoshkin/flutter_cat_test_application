part of 'auth_bloc.dart';

class LoginState {
  const LoginState({
    this.user,
  });

  final User user;

  LoginState copyWith({
    User user,
  }) {
    return LoginState(
      user: user ?? this.user,
    );
  }

  // List<Object> get props => [user];
}
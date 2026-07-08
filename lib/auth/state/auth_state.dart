abstract class AuthState {}

class AuthInitial extends AuthState {}
class LogInEmailState extends AuthState {}
class LogInPasswordState extends AuthState {
  final String email;
  LogInPasswordState(this.email);
}
class RecoverPasswordState extends AuthState {}
class VerifyCodeState extends AuthState {}
class SetPasswordState extends AuthState {}
class SignUpState extends AuthState {}
class GenrePreferencesState extends AuthState {}

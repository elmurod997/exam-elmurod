import 'package:flutter_application_1/auth/state/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(LogInEmailState());

  void goToEmailLogin() => emit(LogInEmailState());
  
  void goToPasswordLogin(String email) => emit(LogInPasswordState(email));
  
  void goToRecoverPassword() => emit(RecoverPasswordState());
  
  void goToVerifyCode() => emit(VerifyCodeState());
  
  void goToSetPassword() => emit(SetPasswordState());
  
  void goToSignUp() => emit(SignUpState());
  
  void goToGenres() => emit(GenrePreferencesState());
}

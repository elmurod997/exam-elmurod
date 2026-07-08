import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_1/auth/state/auth_state.dart';
import 'package:flutter_application_1/screens/genre_preferences_screen.dart';
import 'package:flutter_application_1/screens/login_email_screen.dart';
import 'package:flutter_application_1/screens/login_password_screen.dart';
import 'package:flutter_application_1/screens/recover_password_screen.dart';
import 'package:flutter_application_1/screens/set_password_screen.dart';
import 'package:flutter_application_1/screens/signup_screen.dart';
import 'package:flutter_application_1/screens/verify_code_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Nexus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: BlocProvider(
        create: (context) => AuthCubit(),
        child: const AuthNavigator(),
      ),
    );
  }
}

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is LogInEmailState) {
          return const LogInEmailScreen();
        } else if (state is LogInPasswordState) {
          return LogInPasswordScreen(email: state.email);
        } else if (state is RecoverPasswordState) {
          return const RecoverPasswordScreen();
        } else if (state is VerifyCodeState) {
          return const VerifyCodeScreen();
        } else if (state is SetPasswordState) {
          return const SetPasswordScreen();
        } else if (state is SignUpState) {
          return const SignUpScreen();
        } else if (state is GenrePreferencesState) {
          return const GenrePreferencesScreen();
        }
        return const LogInEmailScreen();
      },
    );
  }
}

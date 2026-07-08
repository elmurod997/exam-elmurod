import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_1/background/auth_background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogInEmailScreen extends StatelessWidget {
  const LogInEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return AuthBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            const Text(
              'Log in',
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: Color(0xFF666666)),
                      filled: true,
                      fillColor: const Color(0xFF1A1A1A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD2E8BE),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (emailController.text.isNotEmpty) {
                          context.read<AuthCubit>().goToPasswordLogin(emailController.text);
                        }
                      },
                      child: const Text('Continue', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.read<AuthCubit>().goToRecoverPassword(),
                    child: const Text('Forgot password?', style: TextStyle(color: Color(0xFFD2E8BE), fontSize: 14)),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xFF222222))),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Or', style: TextStyle(color: Color(0xFF555555)))),
                      Expanded(child: Divider(color: Color(0xFF222222))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _socialButton(Icons.facebook, 'Login with Facebook', Colors.blue),
                  const SizedBox(height: 10),
                  _socialButton(Icons.g_mobiledata, 'Login with Google', Colors.red),
                  const SizedBox(height: 10),
                  _socialButton(Icons.apple, 'Login with Apple', Colors.white),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                      GestureDetector(
                        onTap: () => context.read<AuthCubit>().goToSignUp(),
                        child: const Text("Sign up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, String text, Color iconColor) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}

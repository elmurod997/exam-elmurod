import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_1/background/auth_background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => context.read<AuthCubit>().goToRecoverPassword(),
              child: const Row(
                children: [
                  Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text('Back to Log in', style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 80),
            const Text('Verify Code', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0x801A1A1A), borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('An authentication code has been sent to your email.', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 20),
                  TextField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 4),
                    decoration: InputDecoration(
                      hintText: 'Enter Code',
                      hintStyle: const TextStyle(color: Color(0xFF666666), letterSpacing: 0, fontSize: 14),
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
                      onPressed: () => context.read<AuthCubit>().goToSetPassword(),
                      child: const Text('Verify', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't receive a code? ", style: TextStyle(color: Colors.grey, fontSize: 13)),
                      GestureDetector(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Text("Resend ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            Icon(Icons.refresh, color: Colors.white, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

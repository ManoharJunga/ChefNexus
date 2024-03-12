import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle password reset logic here
                _resetPassword(context);
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }

  void _resetPassword(BuildContext context) {
    // Implement your password reset logic here
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password reset link sent to ${_emailController.text}'),
      ),
    );
  }
}

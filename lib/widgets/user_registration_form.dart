import 'package:flutter/material.dart';

/// ---------------------------
// todo  Validation Helpers

bool isValidEmail(String email) {
  // Email must include text before & after @ and a valid domain
  final regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return regex.hasMatch(email.trim());
}

bool isStrongPassword(String password) {
  // Must include: upper, lower, digit, special char, min length 8
  return password.trim().length >= 8 &&
      RegExp(r'[a-z]').hasMatch(password) &&
      RegExp(r'[A-Z]').hasMatch(password) &&
      RegExp(r'\d').hasMatch(password) &&
      RegExp(r'[!@#\$%\^&\*(),.?":{}|<>_\-]').hasMatch(password);
}

/// ---------------------------
//todo  Registration Form UI

class UserRegistrationForm extends StatefulWidget {
  const UserRegistrationForm({super.key});

  @override
  State<UserRegistrationForm> createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  String _message = '';

  /// ---------------------------
  /// Submit Function (with validation)
  /// ---------------------------

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus(); // Close keyboard
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      // ❌ Stop if any field invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix errors before submitting'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Proceed if valid
    setState(() {
      _isLoading = true;
      _message = '';
    });

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _message = 'Registration successful!';
    });
  }

  /// ---------------------------
  // todo  Build UI

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        autovalidateMode:
            AutovalidateMode.onUserInteraction, // Real-time validation
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 👤 Full Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              validator: (value) {
                final name = value?.trim() ?? '';
                if (name.isEmpty) return 'Please enter your full name';
                if (name.length < 2)
                  return 'Name must be at least 2 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 📧 Email
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) return 'Please enter your email';
                if (!isValidEmail(email)) return 'Please enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 🔒 Password
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                helperText: 'At least 8 chars with upper/lower, number, symbol',
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              obscureText: true,
              validator: (value) {
                final password = value ?? '';
                if (password.isEmpty) return 'Please enter a password';
                if (!isStrongPassword(password)) return 'Password is too weak';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ✅ Confirm Password
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              obscureText: true,
              validator: (value) {
                final confirm = value ?? '';
                if (confirm.isEmpty) return 'Please confirm your password';
                if (confirm != _passwordController.text)
                  return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 24),

            // 🚀 Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Register'),
            ),

            // 🧾 Feedback Message
            if (_message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('successful')
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// ---------------------------
  // todo  Dispose Controllers

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

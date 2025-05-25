import 'package:buddy/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/login_button.dart';

/// LoginPage is the main authentication screen of the application.
/// It handles user login through username and password.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // region: Controllers & Keys
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  // endregion

  // region: Lifecycle
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  // endregion

  // region: Validation
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your username';
    // Keep existing validation logic if any other than empty
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    // Keep existing validation logic if any other than empty
    return null;
  }
  // endregion

  // region: Actions
  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            LoginRequested(
              username: _usernameController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthError) {
      _showSnackBar(context, state.message, AppColors.error);
    } else if (state is AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login successful!'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (state is AuthUnauthenticated) {
      _showSnackBar(context, 'Logged out successfully', AppColors.success);
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  // endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChange,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/login-img.jpg', 
                fit: BoxFit.cover,
              ),
            ),
            // Dark Overlay
            Positioned.fill(
              child: Container(
                color:
                    Colors.black.withOpacity(0.7), // Adjust opacity as needed
              ),
            ),
            // Overlay Container
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // Welcome text
                        const Text(
                          'Welcome to Guade!',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFBC02D),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // Username field
                        CustomTextField(
                          controller: _usernameController,
                          hintText: 'johndoe@gmail.com',
                          validator: _validateUsername,
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 16),
                          decoration: InputDecoration(
                            // Use InputDecoration directly for specific styling
                            hintStyle: TextStyle(
                                color: Colors.grey[400], fontSize: 16),
                            filled: true,
                            fillColor:
                                const Color(0xFFF5F5F5), // Light grey fill
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 0), // No border when focused
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14.0),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Password field
                        CustomTextField(
                          controller: _passwordController,
                          hintText: '********',
                          obscureText: !_isPasswordVisible,
                          validator: _validatePassword,
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 16),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          decoration: InputDecoration(
                            // Use InputDecoration directly for specific styling
                            hintStyle: TextStyle(
                                color: Colors.grey[400], fontSize: 16),
                            filled: true,
                            fillColor:
                                const Color(0xFFF5F5F5), // Light grey fill
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 0), // No border when focused
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14.0),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Login button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) => SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: LoginButton(
                              onPressed: _onLoginPressed,
                              isLoading: state is AuthLoading,
                              backgroundColor:
                                  const Color(0xFFFBC02D), // Yellow color
                              textColor: Colors.white,
                              buttonText:
                                  'Get started →', // Updated button text
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

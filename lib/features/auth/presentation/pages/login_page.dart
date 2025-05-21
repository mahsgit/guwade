import 'package:buddy/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/animated_buddy_logo.dart';
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
    if (value.length < 3) return 'Username must be at least 3 characters';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
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
    // Save token when authenticated
    
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

  // region: UI Builders
  Widget _buildLoginForm() => Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedBuddyLogo(),
            const SizedBox(height: 48),
            _buildUsernameField(),
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 32),
            _buildLoginButton(),
          ],
        ),
      );

  Widget _buildUsernameField() => CustomTextField(
        controller: _usernameController,
        hintText: 'Enter your username',
        prefixIcon: Icons.person,
        validator: _validateUsername,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: AppColors.textHint),
          prefixIconColor: AppColors.primary,
        ),
      );

  Widget _buildPasswordField() => CustomTextField(
        controller: _passwordController,
        hintText: 'Enter your password',
        prefixIcon: Icons.lock,
        obscureText: true,
        validator: _validatePassword,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: AppColors.textHint),
          prefixIconColor: AppColors.primary,
        ),
      );

  Widget _buildLoginButton() => BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) => LoginButton(
          onPressed: _onLoginPressed,
          isLoading: state is AuthLoading,
          backgroundColor: AppColors.buttonPrimary,
          textColor: Colors.white,
        ),
      );
  // endregion

  // region: Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChange,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: _buildLoginForm(),
            ),
          ),
        ),
      ),
    );
  }
  // endregion
}

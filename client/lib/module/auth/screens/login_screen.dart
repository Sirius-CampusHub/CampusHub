import 'package:client/domain/bloc/auth_event.dart';
import 'package:client/domain/bloc/auth_state.dart';
import 'package:client/domain/bloc/auth_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();

  bool _isLogin = true;
  String? _error;

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final passwordRepeat = _passwordRepeatController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Заполни все поля');
      return;
    } else if (!_isLogin && password != passwordRepeat) {
      setState(() => _error = 'Пароли не сопадают');
      return;
    }

    if (_isLogin) {
      context.read<AuthBloc>().add(AuthSignInRequested(email: email, password: password));
    } else {
      context.read<AuthBloc>().add(AuthSignUpRequested(email: email, password: password));
    }
  }

  String? _getErrorMessage(Exception error) {
    if (error is firebase.FirebaseAuthException) {
      switch (error.code) {
        case 'wrong-password':
          return 'Неверные почта или пароль';
        case 'user-disabled':
          return 'Неверные почта или пароль.';
        case 'user-not-found':
          return 'Неверные почта или пароль.';
        case 'invalid-credential':
          return 'Неверные почта или пароль.';
        case 'email-already-in-use':
          return 'Эта почта уже используется.';
        case 'invalid-email':
          return 'Неправильный формат почты.';
        case 'weak-password':
          return 'Слабый пароль.';
        case 'no-current-user':
          return null;
        default:
          return 'Ошибка ${_isLogin ? "входа" : "регистрации"}.';
      }
    } else if (error is DioException) {
      return 'Ошибка соединения.';
    } else {
      return 'Ошибка ${_isLogin ? "входа" : "регистрации"}.';
    }
  }

  void _switchType(){
    setState(() {
      _isLogin = !_isLogin;
      _error = null;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state)  {
              // Syncing _error with error from BLoC
              if (state is AuthError) {
                AuthError authError = state;
                setState(() {
                  _error = _getErrorMessage(authError.error);
                });
              } else if (_error != null) {
                _error = null;
              }
            },
            builder: (context, state) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO switch to logo
                const Icon(Icons.school, size: 80, color: Colors.blue),
                const SizedBox(height: 16),
                Text(
                  'CampHub',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 32),

                // Email field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: Icon(Icons.lock_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Repeat password field
                _isLogin ? const SizedBox() : TextField(
                  controller: _passwordRepeatController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Повторите пароль',
                    prefixIcon: Icon(Icons.lock_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Error display
                if (_error != null) Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _error!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
                if (_error != null) const SizedBox(height: 16),

                // Login/register button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: state is AuthLoading ? null : _submit,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state is AuthLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _isLogin ? 'Войти' : 'Зарегистрироваться',
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Switch auth type button
                TextButton(
                  onPressed: () => _switchType(),
                  child: Text(
                    _isLogin
                        ? 'Нет аккаунта? Зарегистрируйся'
                        : 'Уже есть аккаунт? Войди',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
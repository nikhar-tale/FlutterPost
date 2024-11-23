import 'package:flutter/material.dart';
import 'package:flutter_post/services/theme.dart';
import 'package:email_validator/email_validator.dart'; // Add this package to validate email addresses
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  final AuthBloc authBloc;

  const LoginScreen({Key? key, required this.authBloc}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  late final Stream<AuthState> _authStream;

  @override
  void initState() {
    super.initState();
    _authStream = widget.authBloc.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AuthState>(
        stream: _authStream,
        builder: (context, snapshot) {
          final state = snapshot.data;

          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthAuthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/posts');
            });
          }

          if (state is AuthError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            });
          }

          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50.0),
              child: Form(
                key: _formKey, // Attach the form key
                child: Column(
                  children: [
                    // App Logo or Header
                    Column(
                      children: [
                        Center(
                          child: Container(
                            /** FlutterLogo Widget **/
                            child: const FlutterLogo(
                              size: 100,
                              textColor: Colors.blue,
                              style: FlutterLogoStyle.stacked,
                            ), //FlutterLogo
                          ), //Container
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Welcome Back!',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: AppColors.primaryColor,
                                fontSize: 24,
                              ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Log in to your account',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.accentColor,
                                  ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Input Fields
                    Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email,
                                color: AppColors.primaryColor),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!EmailValidator.validate(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon:
                                Icon(Icons.lock, color: AppColors.primaryColor),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Forgot Password Logic
                            },
                            child: Text(
                              'Forgot Password?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Login Button
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // If all inputs are valid, proceed to login
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            widget.authBloc.add(
                                LogInEvent(email: email, password: password));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: Text(
                          'Log In',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Divider with Text
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                              color: AppColors.borderColor, thickness: 1),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'OR',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.accentColor,
                                  ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Divider(
                              color: AppColors.borderColor, thickness: 1),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Sign Up Button
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: Text(
                        'Don’t have an account? Sign Up',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

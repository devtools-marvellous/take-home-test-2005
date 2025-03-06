import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home_marv/auth/blocs/login/login_bloc.dart';
import 'package:take_home_marv/core/components/form_bloc_error.dart';
import 'package:take_home_marv/core/components/text_input.dart';
import 'package:take_home_marv/core/extensions/validation.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final passwordKey = GlobalKey();

  bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.formError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.formError!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              const Text(
                'Login Page',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const _Email(),
              const SizedBox(height: 20),
              const _Password(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text('Remember me'),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // Forgot password functionality would go here
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state.status.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    children: [
                      FormBlocError(
                        alignment: Alignment.center,
                        text: state.formError,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<LoginBloc>().add(LoginSubmitted());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              // Sign up functionality would go here
                            },
                            child: const Text('Sign Up'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginBloc, LoginState, FormInputError?>(
        selector: (state) => state.email.error,
        builder: (context, formError) {
          final error = switch (formError) {
            RequiredError() => 'Email is required',
            InvalidEmailError() => 'Invalid email',
            _ => null,
          };

          return TextInput.withError(
            labelText: 'Email',
            prefix: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.email, size: 24),
            ),
            hintText: 'Email',
            error: error,
            onChanged: (value) =>
                context.read<LoginBloc>().add(LoginEmailChanged(value)),
          );
        });
  }
}

class _Password extends StatelessWidget {
  const _Password();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginBloc, LoginState, FormInputError?>(
      selector: (state) => state.password.error,
      builder: (context, formError) {
        final error = switch (formError) {
          RequiredError() => 'Password is required',
          InvalidLengthError() => 'Password must be at least 6 characters',
          _ => null,
        };

        return TextInput.withError(
          labelText: 'Password',
          hintText: 'Password',
          autofillHints: const [AutofillHints.password],
          prefix: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.lock, size: 24),
          ),
          formFieldType: FormFieldType.password,
          hideable: true,
          error: error,
          onChanged: (value) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(value)),
        );
      },
    );
  }
}

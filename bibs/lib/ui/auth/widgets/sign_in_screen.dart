import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routing/routes.dart';
import '../../../utils/result.dart';
import '../view_models/sign_in_viewmodel.dart';

class SignInScreen extends StatefulWidget{
  const SignInScreen ({super.key, required this.viewModel});

  final SignInViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
    void initState() {
    super.initState();

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.passwordRecovery &&
          session?.accessToken != null &&
          session?.user != null) {
        GoRouter.of(context).go(Routes.resetPassword);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/bibs_logo_no_bg.png',
                      height: 250,
                    ),
                  ),

                  SizedBox(height:16.0),

                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text('Email'),
                      hintText: 'Type your email...',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16.0),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          label: Text('Password'),
                          hintText: 'Type your password...',
                        ),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.go(Routes.forgotPassword);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(30, 20),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 255),
                              decoration: TextDecoration.underline,
                              decorationColor: Color.fromARGB(255, 0, 0, 255),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),

                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid Input')),
                        );
                      }

                      final result = await widget.viewModel.signInWithEmailPassword(
                        _emailController.text,
                        _passwordController.text,
                      );

                      switch (result) {
                        case Ok<void>():
                          context.go(Routes.session);
                        case Error<void>():
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Invalid credentials.')),
                          );
                      }
                    },
                    child: const Text('Sign In'),
                  ),

                  const SizedBox(height: 16.0),

                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Sign up now!',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 255),
                              decoration: TextDecoration.underline,
                              decorationColor: Color.fromARGB(255, 0, 0, 255),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go(Routes.signUp);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
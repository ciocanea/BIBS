import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../../utils/result.dart';
import '../../connectivity_checker/connectivity_checker.dart';
import '../view_models/sign_up_viewmodel.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen ({super.key, required this.viewModel});

  final SignUpViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          tooltip: 'Back',
          onPressed: () {
            context.go(Routes.signIn);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
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

                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text('Email'),
                      hintText: 'Type your email...',
                    ),
                    validator: widget.viewModel.emailValidator
                  ),

                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      label: Text('Password'),
                      hintText: 'Type your password...',
                    ),
                    obscureText: true,
                    validator: widget.viewModel.passwordValidator
                  ),

                  SizedBox(height: 16.0),

                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      label: Text('Confirm Password'),
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

                  SizedBox(height: 16.0),

                  ElevatedButton(
                    onPressed: () async {
                      final emailValidationMessage = widget.viewModel.emailValidator(_emailController.text.trim());
                      final passwordValidationMessage = widget.viewModel.passwordValidator(_passwordController.text.trim());

                      
                      if (emailValidationMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(emailValidationMessage)),
                        );
                        return;
                      }
                      
                      if (passwordValidationMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(passwordValidationMessage)),
                        );
                        return;
                      }

                      if (_passwordController.text != _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Passwords do not match.')
                          )
                        );
                        return;
                      }
                      
                      final result = await widget.viewModel.signUpWithEmailPassword(_emailController.text, _passwordController.text);
          
                      switch (result) {
                        case Ok<void>():
                          context.go(Routes.session);
                        case Error<void>():
                          final hasConnection = await hasInternetAccess();
                          
                          if (!hasConnection) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No internet connection.')),
                            );
                            context.go(Routes.noInternet);
                            return;
                          }
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to sign up. Please try again later.')
                            )
                          );
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
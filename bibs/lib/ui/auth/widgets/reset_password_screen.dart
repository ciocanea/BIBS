import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routing/routes.dart';
import '../../../utils/result.dart';
import '../view_models/reset_password_viewmodel.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen ({super.key, required this.viewModel});

  final ResetPasswordViewModel viewModel;

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
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
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text("New Password"),
                      hintText: 'Type your new password...',
                    ),
                    validator: widget.viewModel.passwordValidator
                  ),

                  SizedBox(height: 16.0),
                  
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text("Confirm Password"),
                      hintText: 'Confirm your password...',
                    ),
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
                      final validationMessage = widget.viewModel.passwordValidator(_passwordController.text);
                      if (validationMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(validationMessage)),
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

                      final result = await widget.viewModel.changePassword(_passwordController.text);
                      
                      switch (result) {
                        case Ok<void>():
                          _passwordController.clear();
                          _confirmPasswordController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Password updated.')
                            )
                          );
                          context.go(Routes.signIn);
                        case Error<void>():
                          final error = result.error;
      
                          if(error is AuthException && error.statusCode == '422') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('New password should be different from the old one.')
                              )
                            );
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to change password.')
                              )
                            );
                        }
                      }
                    },
                    child: const Text('Reset Password'),
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
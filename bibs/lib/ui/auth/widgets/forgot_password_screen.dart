import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routing/routes.dart';
import '../../../utils/result.dart';
import '../../connectivity_checker/connectivity_checker.dart';
import '../view_models/forgot_password_viewmodel.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen ({super.key, required this.viewModel});

  final ForgotPasswordViewModel viewModel;

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
    void initState() {
    super.initState();

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn &&
          session?.accessToken != null &&
          session?.user != null) {
        debugPrint('[SignInPage] Signed in via deep link.');
        GoRouter.of(context).go(Routes.resetPassword);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
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
                      label: Text("Account Email"),
                      hintText: 'Type your account email...',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }

                      final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }

                      return null;
                    },
                  ),

                  SizedBox(height: 16.0),

                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid email.')
                          )
                        );
                      }

                      final result = await widget.viewModel.sendPasswordReset(_emailController.text.trim());

                      switch (result) {
                        case Ok<void>():
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Password reset email sent.')
                            )
                          );
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
                              content: Text('Failed to send password reset email.')
                            )
                          );
                      }
                    },
                    child: const Text('Send Password Reset Email'),
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
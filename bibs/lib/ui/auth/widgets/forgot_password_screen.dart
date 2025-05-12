import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routing/routes.dart';
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
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your account email',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      widget.viewModel.sendPasswordReset(_emailController.text.trim());
                      return;
                    }
                    else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid Input')
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
    );
  }
}
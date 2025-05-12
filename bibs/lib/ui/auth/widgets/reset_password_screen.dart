import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your new password',
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
                      await widget.viewModel.changePassword(_passwordController.text);
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
                  child: const Text('Reset Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
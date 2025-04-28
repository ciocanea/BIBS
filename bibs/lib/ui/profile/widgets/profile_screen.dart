import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../../utils/result.dart';
import '../view_models/profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen ({super.key, required this.viewModel});

  final ProfileViewmodel viewModel;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.load().then((result) {
      if (result is Error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: ${result.error}'))
        );
      }
    });
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          tooltip: 'Back',
          onPressed: () {
            context.go(Routes.session);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, child) {
              final userProfile = widget.viewModel.userProfile;

              if(userProfile == null) {
                return const CircularProgressIndicator();
              }

              _usernameController.text = userProfile.username;

              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: widget.viewModel.imageFile != null
                          ? FileImage(widget.viewModel.imageFile!)
                          : (userProfile.imagePath != null
                              ? NetworkImage(userProfile.imagePath!)
                              : null),
                      child: widget.viewModel.imageFile == null && userProfile.imagePath == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    ElevatedButton(
                      onPressed: widget.viewModel.pickImage,
                      child: const Text('Pick Profile'),
                    ),
                    ElevatedButton(
                      onPressed: widget.viewModel.changeImage,
                      child: const Text('Update Profile'),
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: 'Change your username',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField(
                      value: userProfile.campus,
                      items: [
                        DropdownMenuItem(
                          value: 'TU-Delft',
                          child: Text('TU-Delft')
                        ),
                        DropdownMenuItem(
                          value: 'Leiden University',
                          child: Text('Leiden University')
                        ),
                      ],
                      onChanged: (value) async{
                        await widget.viewModel.changeCampus(value!);
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final result = await widget.viewModel.changeUsername(_usernameController.text);
              
                          if(result is Error<void>) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${result.error}')
                              )
                            );
                            return;
                          }
              
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Profile updated succesfully.')
                            )
                          );
                        }
                        else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invalid Input')
                              )
                            );
                        }
                      },
                      child: const Text('Save changes'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
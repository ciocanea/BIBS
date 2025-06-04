import 'package:bibs/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final GlobalKey<FormState> _usernameFormKey= GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey= GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  String _campusController = '';

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.load().then((result) {
      if (result is Error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load page. Please check your connection and try again.'))
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
              _campusController = userProfile.campus!;

              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Form(
                        key: _usernameFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: (widget.viewModel.imageFile != null || userProfile.imagePath != null)
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 3,
                                      ),
                                    )
                                  : null,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: widget.viewModel.imageFile != null
                                    ? FileImage(widget.viewModel.imageFile!)
                                    : (userProfile.imagePath != null
                                        ? NetworkImage(userProfile.imagePath!)
                                        : null) as ImageProvider?,
                                child: widget.viewModel.imageFile == null && userProfile.imagePath == null
                                    ? const Icon(Icons.person, size: 60)
                                    : null,
                              ),
                            ),
                
                        
                            ElevatedButton(
                              onPressed: widget.viewModel.pickImage,
                              child: const Text('Edit Image'),
                            ),
                
                            SizedBox(height: 16.0),
                
                
                            TextFormField(
                              controller: _usernameController,
                              maxLength: 15,
                              decoration: const InputDecoration(
                                label: Text('Username'),
                                hintText: 'Type your username...',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                            
                            SizedBox(height: 16.0),
                
                            DropdownButtonFormField(
                              value: _campusController,
                              decoration: const InputDecoration(
                                label: Text('Campus')
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'TU-Delft',
                                  child: Text('TU-Delft')
                                ),
                                // DropdownMenuItem(
                                //   value: 'Leiden University',
                                //   child: Text('Leiden University')
                                // ),
                              ],
                              onChanged: (value) async{
                                _campusController = value!;
                              },
                            ),
                
                            SizedBox(height: 16.0),
                
                            ElevatedButton(
                              onPressed: () async {
                                if (!_usernameFormKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Username is not valid.')),
                                  );
                                  return;
                                }
                                
                                bool imageChanged = false;
                
                                if (widget.viewModel.imageFile != null) {
                                  imageChanged = true;
                                }
                
                                bool usernameChanged = false;  
                
                                if (_usernameController.text.trim() != userProfile.username) {
                                  usernameChanged = true;
                                }
                
                                bool campusChanged = false;
                
                                print(_campusController);
                                print(userProfile.campus);
                                if (_campusController != userProfile.campus) {
                                  campusChanged = true;
                                }
                
                                if (!imageChanged && !usernameChanged && !campusChanged) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Profile updated.')
                                    )
                                  );
                                }
                
                                if (imageChanged == true) {
                                  final result = await widget.viewModel.changeImage();
                
                                  switch (result) {
                                    case Ok<void>():
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Image updated.')
                                        )
                                      );
                                    case Error<void>():
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to update image. Please check your internet connection and try again.')
                                        )
                                      );
                                  }
                                }
                
                                if (usernameChanged == true) {
                                  final result = await widget.viewModel.changeUsername(_usernameController.text.trim());
                      
                                  switch (result) {
                                    case Ok<void>():
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Username updated.')
                                        )
                                      );
                                    case Error<void>():
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to update username. Please check your internet connection and try again.')
                                        )
                                      );
                                  }
                                }
                
                                if (campusChanged == true) {
                                  final result = await widget.viewModel.changeCampus(_campusController);
                
                                  switch (result) {
                                    case Ok<void>():
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Campus updated.')
                                        )
                                      );
                                    case Error<void>():
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to update campus. Please check your internet connection and try again.')
                                        )
                                      );
                                  }
                                }
                
                              },
                              child: const Text('Save Changes'),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16.0),
                
                      Divider(),
                
                      SizedBox(height: 16.0),
                
                      Form(
                        key: _passwordFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                label: Text('New Password'),
                                hintText: 'Type your new password...',
                              ),
                              validator: widget.viewModel.passwordValidator
                            ),
                
                            SizedBox(height: 16.0),
                
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                label: Text('Confirm Password'),
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
                                          content: Text('Failed to change password. Please check your internet connection and try again.')
                                        )
                                      );
                                  }
                                }
                
                              },
                              child: const Text('Change Password'),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16.0),

                      Divider(),

                      SizedBox(height: 16.0),

                      ElevatedButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Sign Out'),
                              content: const Text('Are you sure you want to sign out?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Sign Out'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final result = await widget.viewModel.signOut();

                            switch (result) {
                              case Ok<void>():
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Signed out.')
                                  )
                                );
                                context.go(Routes.signIn); 
                              case Error<void>():
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to sign out. Please check your internet connection and try again.')
                                  )
                                );
                            }
                          }
                        },
                        child: Text('Sign Out'),
                      ),

                      SizedBox(height: 16.0),

                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(AppColors.alertColor),
                          side: WidgetStatePropertyAll(BorderSide(color: AppColors.black, width: 2.0)),
                        ),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Account'),
                              content: const Text('Are you sure you want to delete your account? This will permanently delete any data linked to your account.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    foregroundColor: WidgetStatePropertyAll<Color>(AppColors.black),
                                    backgroundColor: WidgetStatePropertyAll<Color>(AppColors.alertColor),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final deleteAccountResult = await widget.viewModel.deteleAccount(userProfile.userId);

                            switch (deleteAccountResult) {
                              case Ok<void>():
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Account deleted.')
                                  )
                                );
                              case Error<void>():
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to delete account. Please check your internet connection and try again.')
                                  )
                                );
                                return;
                            }

                            final signOutResult = await widget.viewModel.signOut();

                            switch (signOutResult) {
                              case Ok<void>():
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Signed out.')
                                  )
                                );
                              case Error<void>():
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to sign out. Please check your internet connection and try again.')
                                  )
                                );
                                return;
                            }
                            context.go(Routes.signIn);
                          }
                        }, 
                        child: const Text('Delete Account')
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
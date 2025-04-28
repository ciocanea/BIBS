import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/models/user_profile/user_profile_model.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/result.dart';

class ProfileViewmodel extends ChangeNotifier{

  ProfileViewmodel({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  final UserRepository _userRepository;

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  File? _imageFile;
  File? get imageFile => _imageFile;

  Future<Result<void>> load() async {
    try {
      final userProfileResult = await _userRepository.getProfile();

      switch (userProfileResult) {
        case Ok<UserProfile>():
          _userProfile = userProfileResult.value;
          return Result.ok(null);
        case Error<UserProfile>():
          return Result.error(userProfileResult.error);
      }
    }
    finally {
      notifyListeners();
    }
  }

  Future<Result<void>> changeUsername (String newUsername) async {
    try {
      final userProfileResult = await _userRepository.setUsername(newUsername: newUsername);

      switch (userProfileResult) {
        case Ok<UserProfile>():
          _userProfile = userProfileResult.value;
          return Result.ok(null);
        case Error<UserProfile>():
          return Result.error(userProfileResult.error);
      }
    }
    finally {
      notifyListeners();
    }
  }

  Future<Result<void>> changeCampus (String newCampus) async {
    try {
      final userProfileResult = await _userRepository.setCampus(newCampus: newCampus);

      switch (userProfileResult) {
        case Ok<UserProfile>():
          _userProfile = userProfileResult.value;
          return Result.ok(null);
        case Error<UserProfile>():
          return Result.error(userProfileResult.error);
      }
    }
    finally {
      notifyListeners();
    }
  }

  Future<void> requestPermission() async {
    final permission = Platform.isIOS ? Permission.photos : Permission.storage;

    if (await permission.isDenied || await permission.isPermanentlyDenied) {
      await permission.request();
    }
  }

  Future<Result<void>> pickImage() async {
    try {
      await requestPermission();

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        return Result.error(Exception('No image selected.'));
      }
      
      _imageFile = File(image.path);

      return Result.ok(null);
    } 
    on Exception catch (error) {
      return Result.error(error);
    }
    finally {
      notifyListeners();
    }
  }

  Future<Result<void>> changeImage() async {
    try {
      if (_imageFile == null) {
        return Result.error(Exception('Please select an image.'));
      }

      final result = await _userRepository.uploadImage(imageFile: _imageFile!);

      switch (result) {
        case Ok<UserProfile>():
          _userProfile = result.value;
          return Result.ok(null);
        case Error<UserProfile>():
          return Result.error(result.error);
      }
    }
    finally {
      notifyListeners();
    }
  }
}
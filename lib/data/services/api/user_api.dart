import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/result.dart';
import '../responses.dart/profile_response.dart';
import '../responses.dart/time_response.dart';

class UserClient {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<Result<UserProfileResponse>> getProfile (String userId) async {
    try {
      final response = await _supabaseClient
      .from('profiles')
      .select()
      .eq('id', userId)
      .single();

      return Result.ok(UserProfileResponse(profile: response));
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<UserProfileResponse>> setUsername (String userId, String newUsername) async {
    try {
      final response = await _supabaseClient
      .from('profiles')
      .update({'username': newUsername})
      .eq('id', userId)
      .select()
      .single();

      return Result.ok(UserProfileResponse(profile: response));
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<UserProfileResponse>> setCampus (String userId, String newCampus) async {
    try {
      final response = await _supabaseClient
      .from('profiles')
      .update({'campus': newCampus})
      .eq('id', userId)
      .select()
      .single();

      return Result.ok(UserProfileResponse(profile: response));
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<String>> getPublicUrl (String imagePath) async {
    try {
      final response = _supabaseClient.storage
      .from('images')
      .getPublicUrl(imagePath);

      return Result.ok(response);
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<UserProfileResponse>> setImagePath (String userId, String imagePath) async {
    try {
      final response = await _supabaseClient
      .from('profiles')
      .update({'image_path': imagePath})
      .eq('id', userId)
      .select()
      .single();

      return Result.ok(UserProfileResponse(profile: response));
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<String>> uploadImage (File imageFile, String imagePath) async {
    try {
      final response = await _supabaseClient.storage
      .from('images')
      .upload(
        imagePath,
        imageFile,
        fileOptions: 
        const FileOptions(
          upsert: true,
        )
      );

      return Result.ok(response);
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<UserTimeResponse>> getTotalTime (String userId, String campus) async {
    try {
      final response = await _supabaseClient
      .from('times')
      .select()
      .eq('id', userId)
      .eq('campus', campus)
      .single();

      return Result.ok(UserTimeResponse(time: response));
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<UserTimeResponse>> setTotalTime (String userId, String campus, int newTotalTime) async {
    try {
      final response = await _supabaseClient
      .from('times')
      .update({'total_time': newTotalTime})
      .eq('id', userId)
      .eq('campus', campus)
      .select()
      .single();

      return Result.ok(UserTimeResponse(time: response));
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }
}
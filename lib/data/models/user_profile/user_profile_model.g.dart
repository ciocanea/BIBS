// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  userId: json['id'] as String,
  username: json['username'] as String,
  campus: json['campus'] as String?,
  imagePath: json['image_path'] as String?,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.userId,
      'username': instance.username,
      'campus': instance.campus,
      'image_path': instance.imagePath,
    };

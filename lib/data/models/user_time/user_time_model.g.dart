// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_time_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserTime _$UserTimeFromJson(Map<String, dynamic> json) => _UserTime(
  userId: json['id'] as String,
  campus: json['campus'] as String,
  username: json['username'] as String,
  totalTime: (json['total_time'] as num).toInt(),
  imagePath: json['image_path'] as String?,
);

Map<String, dynamic> _$UserTimeToJson(_UserTime instance) => <String, dynamic>{
  'id': instance.userId,
  'campus': instance.campus,
  'username': instance.username,
  'total_time': instance.totalTime,
  'image_path': instance.imagePath,
};

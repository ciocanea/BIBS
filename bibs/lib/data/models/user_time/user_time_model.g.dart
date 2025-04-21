// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_time_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserTime _$UserTimeFromJson(Map<String, dynamic> json) => _UserTime(
  id: json['id'] as String,
  campus: json['campus'] as String,
  username: json['username'] as String,
  time: (json['time'] as num).toInt(),
);

Map<String, dynamic> _$UserTimeToJson(_UserTime instance) => <String, dynamic>{
  'id': instance.id,
  'campus': instance.campus,
  'username': instance.username,
  'time': instance.time,
};

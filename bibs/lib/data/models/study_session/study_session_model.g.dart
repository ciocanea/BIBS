// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudySession _$StudySessionFromJson(Map<String, dynamic> json) =>
    _StudySession(
      id: json['id'] as String,
      time: (json['time'] as num).toInt(),
      startedAt: DateTime.parse(json['started_at'] as String),
    );

Map<String, dynamic> _$StudySessionToJson(_StudySession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
      'started_at': instance.startedAt.toIso8601String(),
    };

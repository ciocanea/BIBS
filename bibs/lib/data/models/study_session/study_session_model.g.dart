// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudySession _$StudySessionFromJson(Map<String, dynamic> json) =>
    _StudySession(
      sessionId: json['id'] as String,
      duration: (json['duration'] as num).toInt(),
      startedAt: DateTime.parse(json['started_at'] as String),
    );

Map<String, dynamic> _$StudySessionToJson(_StudySession instance) =>
    <String, dynamic>{
      'id': instance.sessionId,
      'duration': instance.duration,
      'started_at': instance.startedAt.toIso8601String(),
    };

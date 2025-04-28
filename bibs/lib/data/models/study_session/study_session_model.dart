import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_session_model.freezed.dart';
part 'study_session_model.g.dart';

@freezed
abstract class StudySession with _$StudySession {
  const factory StudySession ({
    @JsonKey(name: 'id') required String sessionId,
    required int duration,
    @JsonKey(name: 'started_at') required DateTime startedAt,
  }) = _StudySession;

  factory StudySession.fromJson(Map<String, dynamic> json) => _$StudySessionFromJson(json);
}
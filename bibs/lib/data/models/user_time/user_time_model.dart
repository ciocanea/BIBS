import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_time_model.freezed.dart';
part 'user_time_model.g.dart';

@freezed
abstract class UserTime with _$UserTime {
  const factory UserTime ({
    required String id,
    required String campus,
    required String username,
    required int time
  }) = _UserTime;

  factory UserTime.fromJson(Map<String, dynamic> json) => _$UserTimeFromJson(json);
}
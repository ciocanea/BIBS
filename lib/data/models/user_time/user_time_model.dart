import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_time_model.freezed.dart';
part 'user_time_model.g.dart';

@freezed
abstract class UserTime with _$UserTime {
  const factory UserTime ({
    @JsonKey(name: 'id') required String userId,
    required String campus,
    required String username,
    @JsonKey(name: 'total_time') required int totalTime,
    @JsonKey(name: 'image_path') String? imagePath
  }) = _UserTime;

  factory UserTime.fromJson(Map<String, dynamic> json) => _$UserTimeFromJson(json);
}
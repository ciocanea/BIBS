import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile ({
    @JsonKey(name: 'id') required String userId,
    required String username,
    String? campus,
    @JsonKey(name: 'image_path') String? imagePath
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel ({
    required String id,
    required String name,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) =>
    _$UserModelFromJson(json);
}